<?php

namespace App\Http\Controllers;

use App\Models\Bid;
use App\Models\Contractor;
use App\Models\Tender;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ReportController extends Controller
{
 public function summary(Request $request)
{
    // إحصائيات 
    $totalTenders = Tender::count();
    $totalBids = Bid::count();
    $averageBidsPerTender = $totalTenders > 0 ? round($totalBids / $totalTenders, 2) : 0;

    // تحليل الأسعار
    $avgBidPrice = Bid::avg('bid_amount');
    $maxBidPrice = Bid::max('bid_amount');
    $minBidPrice = Bid::min('bid_amount');

    // متوسط التقييم النهائي
    $avgFinalScore = Bid::avg('final_bid_score');

    // أفضل المقاولين من حيث عدد العروض
    $topContractors = Contractor::with('user')
        ->withCount('bids')
        ->orderByDesc('bids_count')
        ->take(5)
        ->get();

    // تحليل متوسط الأسعار لأحدث المناقصات
   $priceAnalysis = Tender::withAvg('bids', 'bid_amount')
    ->orderBy('created_at', 'desc')
    ->take(5)
    ->get(['id', 'title', 'created_at']);


    // المقاولون الفائزون
    $winners = Tender::with(['winnerBid.contractor.user'])
        ->whereNotNull('winner_bid_id')
        ->where('status', 'closed')
        ->get();

    if ($request->wantsJson()) {
        return response()->json([
            'totalTenders' => $totalTenders,
            'totalBids' => $totalBids,
            'averageBidsPerTender' => $averageBidsPerTender,
            'avgBidPrice' => $avgBidPrice,
            'maxBidPrice' => $maxBidPrice,
            'minBidPrice' => $minBidPrice,
            'avgFinalScore' => $avgFinalScore,
            'topContractors' => $topContractors,
            'priceAnalysis' => $priceAnalysis,
            'winners' => $winners->map(function ($tender) {
                return [
                    'tender_title' => $tender->title,
                    'contractor_user_name' => $tender->winnerBid->contractor->user->name ?? null,
                    'score' => $tender->winnerBid->final_bid_score ?? null,
                ];
            }),
        ]);
    }

    return view('admin.reports.summary', compact(
        'totalTenders',
        'totalBids',
        'averageBidsPerTender',
        'avgBidPrice',
        'maxBidPrice',
        'minBidPrice',
        'avgFinalScore',
        'topContractors',
        'priceAnalysis',
        'winners'
    ));
}


  public function performance(Request $request)
{
    //إحصائيات حالات المناقصات
    $tendersStatusCount = Tender::select('status')
        ->selectRaw('COUNT(*) as count')
        ->groupBy('status')
        ->get();

    // العروض المقبولة في مناقصات مغلقة
    $acceptedBidsCount = Bid::whereHas('tender', function ($q) {
        $q->where('status', 'closed')
          ->where(function ($sub) {
              $sub->whereColumn('tenders.winner_bid_id', 'bids.id')
                   ->orWhereColumn('tenders.manual_winner_bid_id', 'bids.id');
          });
    })->count();

    $totalBidsInClosedTenders = Bid::whereHas('tender', fn($q) => $q->where('status', 'closed'))->count();
    $rejectedBidsCount = $totalBidsInClosedTenders - $acceptedBidsCount;

    $bidsStatusCount = collect([
        (object)['status' => 'مقبولة', 'count' => $acceptedBidsCount],
        (object)['status' => 'مرفوضة', 'count' => $rejectedBidsCount],
    ]);

    // متوسط مدة التنفيذ في المناقصات المغلقة فقط
    $averageDuration = Tender::where('status', 'closed')
        ->whereNotNull('execution_duration_days')
        ->avg('execution_duration_days');

    // أداء المقاولين (فقط في المناقصات المغلقة)
    $contractors = Contractor::with('user')
        ->withCount([
            'bids as total_bids' => fn($q) =>
                $q->whereHas('tender', fn($t) => $t->where('status', 'closed')),
            'bids as accepted_bids' => fn($q) =>
                $q->whereHas('tender', function ($t) {
                    $t->where('status', 'closed')
                      ->where(function ($sub) {
                          $sub->whereColumn('tenders.winner_bid_id', 'bids.id')
                               ->orWhereColumn('tenders.manual_winner_bid_id', 'bids.id');
                      });
                }),
        ])
        ->orderByDesc('accepted_bids')
        ->get();

    if ($request->wantsJson()) {
        return response()->json([
            'tendersStatusCount' => $tendersStatusCount,
            'bidsStatusCount' => $bidsStatusCount,
            'averageDuration' => $averageDuration,
            'contractors' => $contractors->map(function ($c) {
                return [
                    'name' => $c->user->name ?? $c->company_name,
                    'total_bids' => $c->total_bids,
                    'accepted_bids' => $c->accepted_bids,
                ];
            }),
        ]);
    }

    return view('admin.reports.performance', compact(
        'tendersStatusCount',
        'bidsStatusCount',
        'averageDuration',
        'contractors'
    ));
}
}