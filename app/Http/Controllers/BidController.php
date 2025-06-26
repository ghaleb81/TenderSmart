<?php

namespace App\Http\Controllers;
use App\Models\Contractor;
use App\Models\Tender;
use Illuminate\Http\Request;
use App\Models\Bid;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Auth as FacadesAuth;
use Illuminate\Support\Facades\Auth as SupportFacadesAuth;
use Illuminate\Support\Facades\Auth as IlluminateSupportFacadesAuth;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\Process\Process;
use Symfony\Component\Process\Exception\ProcessFailedException;

class BidController extends Controller
{

public function index(Request $request)
{
    $user = $request->user();

    // جلب كل العروض مع المناقصة المرتبطة بها
    $bids = Bid::with('tender')->get();

    return response()->json(['the bids' =>$bids ],200);
}
public function show(Request $request,$tenderId)
{
    $user = $request->user();

    // جلب كل العروض مع المناقصة المرتبطة بها
    $bids = Bid::where('tender_id',$tenderId)->get();

    return response()->json(['the bids' =>$bids ],200);
}

//     public function evaluate(Request $request ,$tender_id)
// {
//     $user = $request->user();
//     $tender = Tender::with(['bids.contractor'])->findOrFail($tender_id);

//     $bids_data = $tender->bids->map(function ($bid) {
//         return [    
//             "id" => $bid->id,
//             "contractor_id" => $bid->contractor_id,
//             "bid_amount" => $bid->bid_amount,
//             "budget" => $bid->tender->estimated_budget,
//             "completion_time" => $bid->completion_time,
//             "required_duration" => $bid->tender->execution_duration_days,
//             "quality_certificates" => $bid->contractor->quality_certificates ?? 0,
//             "projects_last_5_years" => $bid->contractor->projects_last_5_years ?? 0,
//             "technical_matched_count" => $bid->technical_matched_count,
//             "technical_requirements_count" => $bid->tender->technical_requiremen_count
//         ];
//     });

//     $results = [];

//     foreach ($bids_data as $bid) {
//         $bid_amount = $bid['bid_amount'];
//         $budget = $bid['budget'];
//         $completion_time = $bid['completion_time'];
//         $required_duration = $bid['required_duration'];
//         $quality_certificate_count = $bid['quality_certificates'];
//         $years_of_experience = $bid['projects_last_5_years'];
//         $technical_matched_count = $bid['technical_matched_count'];
//         $technical_requirment_count = $bid['technical_requirements_count'];

//         // الميزانية
//         $budget_adherence = min(($bid_amount / $budget) * 10, 10);

//         // السرعة
//         if ($completion_time <= $required_duration) {
//             $speed_score = 10;
//         } else {
//             $delay = $completion_time - $required_duration;
//             $max_delay = 364;
//             $normalized_delay = $delay / $max_delay;
//             $speed_score = max(0, 10 * (1 - $normalized_delay));
//         }

//         // الجودة
//         $quality_score = min(10, 5 + ($quality_certificate_count * 1) + ($years_of_experience > 5 ? 2 : 0));

//         // التقني
//         $technical_score = ($technical_matched_count / max($technical_requirment_count, 1)) * 10;

//         // التقييم النهائي باستخدام أوزان LinearRegression
//         $final_score = (
//             $bid_amount * -1.38207769e-09 +
//             $completion_time * -0.0503555671 +
//             $technical_score * 0.200395639 +
//             $budget_adherence * 0.299928946 +
//             $quality_score * 0.200395639 +
//             $speed_score * -1.63714523 +
//             19.2779203899846
//         );

//         $results[] = [
//             "contractor_id" => $bid['contractor_id'],
//             "predicted_score" => $final_score
//         ];
//     }

//     // تحديث قاعدة البيانات
//     foreach ($results as $result) {
//         Bid::where('contractor_id', $result['contractor_id'])
//             ->where('tender_id', $tender_id)
//             ->update(['final_bid_score' => $result['predicted_score']]);
//     }

//     // ترتيب العروض حسب التقييم النهائي
//     $sorted_bids = Bid::where('tender_id', $tender_id)
//         ->orderByDesc('final_bid_score')
//         ->get();

//     return view('bids.index', compact('tender', 'sorted_bids'));
// }




// public function evaluateBidsApii($tender_id, Request $request)
// {
//     $tender = Tender::with(['bids.contractor'])->findOrFail($tender_id);

//     if ($tender->status !== 'closed') {
//         return response()->json(['error' => 'لا يمكن تقييم العروض قبل إغلاق المناقصة.'], 400);
//     }

//     $bids_data = $tender->bids->map(function ($bid) {
//         return [
//             "id" => $bid->id,
//             "contractor_id" => $bid->contractor_id,
//             "bid_amount" => $bid->bid_amount,
//             "estimated_budget" => $bid->tender->estimated_budget,
//             "completion_time" => $bid->completion_time,
//             "execution_duration_days" => $bid->tender->execution_duration_days,
//             "quality_certificates" => $bid->contractor->quality_certificates ?? 0,
//             "projects_last_5_years" => $bid->contractor->projects_last_5_years ?? 0,
//             "technical_matched_count" => $bid->technical_matched_count,
//             "technical_requirements_count" => $bid->tender->technical_requirements_count,
//         ];
//     })->values();

//     $pythonPath = 'C:\Users\Lenovo\AppData\Local\Programs\Python\Python311\python.exe';
//     $scriptPath = base_path('ai/evaluate_tenders.py');

//     $process = new Process([$pythonPath, $scriptPath]);
//     $process->setInput(json_encode($bids_data));
//     $process->run();

//     if (!$process->isSuccessful()) {
//         return response()->json(['error' => $process->getErrorOutput()], 500);
//     }

//     $results = json_decode($process->getOutput(), true);

//     foreach ($results as $result) {
//         Bid::where('id', $result['id'])->update([
//             'final_bid_score' => $result['predicted_score'],
//         ]);
//     }

//     $topBid = collect($results)->sortByDesc('predicted_score')->first();
//     if ($topBid) {
//         $tender->winner_bid_id = $topBid['id'];
//         $tender->save();
//     }

//     return response()->json([
//         'message' => 'تم تقييم العروض بنجاح.',
//         'results' => $results,
//         'winner_bid_id' => $topBid['id'] ?? null
//     ]);
// }
public function evaluateBidsApi($tender_id, Request $request)
{
    $tender = Tender::with(['bids.contractor'])->findOrFail($tender_id);

    if ($tender->status !== 'closed') {
        return response()->json(['error' => 'لا يمكن تقييم العروض قبل إغلاق المناقصة.'], 400);
    }

    // تجهيز بيانات العروض لإرسالها لسكربت البايثون
    $bidsPayload = [];

    foreach ($tender->bids as $bid) {
        $bidsPayload[] = [
            'id' => $bid->id,
            'contractor_id' => $bid->contractor_id,
            'bid_amount' => (float) $bid->bid_amount,
            'estimated_budget' => (float) $tender->estimated_budget,
            'completion_time' => (float) $bid->completion_time,
            'execution_duration_days' => (float) $tender->execution_duration_days,
            'quality_certificates' => (float) ($bid->contractor->quality_certificates ?? 0),
            'projects_last_5_years' => (float) ($bid->contractor->projects_last_5_years ?? 0),
            'technical_matched_count' => (float) $bid->technical_matched_count,
            'technical_requirements_count' => (float) $tender->technical_requirements_count,
        ];
    }

    // تنفيذ سكربت بايثون
    $process = new Process(['python3', base_path('ai/evaluate_tenders.py')]);
    $process->setInput(json_encode($bidsPayload));
    $process->run();

    if (!$process->isSuccessful()) {
        throw new ProcessFailedException($process);
    }
$results = json_decode($process->getOutput(), true);

// تحديث درجات العروض في قاعدة البيانات
foreach ($results as $result) {
    Bid::where('id', $result['id'])->update([
        'final_bid_score' => $result['predicted_score'],
    ]);
}

// ترتيب النتائج من الأعلى للأقل
usort($results, fn($a, $b) => $b['predicted_score'] <=> $a['predicted_score']);

// تحديث حقل winner_bid_id في جدول المناقصات بأفضل عرض
if (!empty($results)) {
    $topBidId = $results[0]['id'];
    $tender->winner_bid_id = $topBidId;
    $tender->save();
}

return response()->json([
    'results' => $results
]);
}



public function storeApi(Request $request)
{
      $user =$request->user();
    $contractor = Contractor::where('user_id', $user->id)->firstOrFail();
    
    $hasProfile =$user->contractor()->exists();
    if (!$hasProfile){
        return response()->json(
        ['message' => 'please fill your information'], 200);
     }

    $request->validate([
        'tender_id' => 'required|exists:tenders,id',
        'contractor_id' => 'exists:contractor->id',
        'bid_amount' => 'required|numeric',
        'completion_time' => 'required|integer',
        'technical_proposal_pdf' => 'nullable|mimes:pdf|max:10240',
        'technical_matched_count' => 'required|integer',
    ]);

    $pdfPath = null;
    if ($request->hasFile('technical_proposal_pdf')) {
        $pdfPath = $request->file('technical_proposal_pdf')->store('bids/technical_proposals', 'public');
    }

    $bid = Bid::create([
        'tender_id' => $request->tender_id,
'contractor_id' => $contractor->id,
        'bid_amount' => $request->bid_amount,
        'completion_time' => $request->completion_time,
        'technical_proposal_pdf' => $pdfPath,
        'technical_matched_count' => $request->technical_matched_count,
    ]);

    return response()->json([
        'message' => 'تم تقديم العرض بنجاح!',
        'data' => $bid
    ], 201);
}



public function updateApi(Request $request, $id)
{
    $bid = Bid::findOrFail($id);
    if ($request->user()->contractor->id !== $bid->contractor_id) {
        return response()->json(['message' => 'Unauthorized'], 403);
    }
 // الوصول إلى المناقصة المرتبطة
    $tender = $bid->tender;

    // التحقق مما إذا كانت المناقصة مغلقة
    if ($tender->status === 'closed') {
        return response()->json(['message' => 'انتهى وقت التقديم، لا يمكنك تعديل العرض.'], 403);
    }
    $request->validate([
        'bid_amount' => 'nullable|numeric',
        'completion_time' => 'nullable|integer',
        'technical_proposal_pdf' => 'nullable|mimes:pdf|max:10240',
        'technical_matched_count' => 'nullable|integer',
    ]);

    $data = $request->except('technical_proposal_pdf');

    if ($request->hasFile('technical_proposal_pdf')) {
        // حذف الملف القديم إذا موجود
        if ($bid->technical_proposal_pdf) {
            Storage::disk('public')->delete($bid->technical_proposal_pdf);
        }
        // تخزين الملف الجديد
        $filePath = $request->file('technical_proposal_pdf')->store('bids/technical_proposals', 'public');
        $data['technical_proposal_pdf'] = $filePath;
    }

    $bid->update($data);

    return response()->json([
        'message' => 'Bid updated successfully',
        'data' => $bid
    ], 200);
}

public function previousbids(Request $request){
$user=$request->user();

$contractor=$user->contractor;

   if (!$contractor) {
        return response()->json(['message' => 'لا يوجد لديك حساب مقاول'], 404);
    }

    $bids = $contractor->bids()->with('tender')->latest()->get();

    return response()->json($bids);
}

}