<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Bid;

class BidController extends Controller
{
    public function index($tender_id)
{
    // جلب المناقصة مع العروض المرتبطة بها
    $tender = \App\Models\Tender::with('bids')->findOrFail($tender_id);

    return view('bids.index', compact('tender'));
}

    public function store(Request $request, $tender_id)
    {
        $validated = $request->validate([
            'tender_id' => 'required|exists:tenders,id',
            'bid_amount' => 'required|numeric',
            'completion_time' => 'required|integer',
            'technical_proposal_pdf' => 'nullable|mimes:pdf|max:10240',
            'technical_matched_count' => 'required|integer',
            
        ]);

        $pdfPath = null;
        if ($request->hasFile('technical_proposal_pdf')) {
            $pdfPath = $request->file('technical_proposal_pdf')->store('bids/technical_proposals', 'public');
        }

        $bid = new Bid();
        $bid->tender_id = $request->tender_id;
        $bid->contractor_id = Auth::id();
        $bid->bid_amount = $request->bid_amount;
        $bid->completion_time = $request->completion_time;
        $bid->technical_proposal_pdf = $pdfPath;
        $bid->technical_matched_count = $request->technical_matched_count;
      
        $bid->submission_date = now();
        $bid->save();

        return redirect()->route('bid', $request->tender_id)->with('success', 'تم تقديم العرض بنجاح!');
    }
}
