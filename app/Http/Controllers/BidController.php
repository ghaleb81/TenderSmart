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
    public function showw(Request $request, $tender_id)
{
    $user = $request->user();

    // جلب المناقصة مع عروضها والمقاولين المرتبطين
    $tender = Tender::with(['bids.contractor'])->findOrFail($tender_id);

    // تجهيز بيانات العروض لتُرسل إلى سكربت الذكاء الاصطناعي
    $bids_data = $tender->bids->map(function ($bid) {
        return [
            "contractor_id" => $bid->contractor_id,
            "bid_amount" => $bid->bid_amount,
            "estimated_budget" => $bid->tender->estimated_budget,
            "completion_time" => $bid->completion_time,
            "execution_duration_days" => $bid->tender->execution_duration_days,
            "quality_certificates" => $bid->contractor->quality_certificates ?? 0,
            "projects_last_5_years" => $bid->contractor->projects_last_5_years ?? 0,
            "technical_matched_count" => $bid->technical_matched_count,
            "technical_requirements_count" => $bid->tender->technical_requirements_count
        ];
    })->toArray();

    // المسارات للبايثون والسكربت
    $pythonPath = 'C:\Users\Lenovo\AppData\Local\Programs\Python\Python311\python.exe';
    $scriptPath = 'C:\\Users\\Lenovo\\Desktop\\course laravel\\TenderLaravel\\ai\\evaluate_tenders.py';

    // إنشاء عملية بايثون
    $process = new Process([$pythonPath, $scriptPath]);
    $process->setInput(json_encode($bids_data));
    $process->run();

    // التحقق من النجاح
    if (!$process->isSuccessful()) {
        throw new ProcessFailedException($process);
    }

    // تحليل النتائج القادمة من السكربت
    $results = json_decode($process->getOutput(), true);

    // تحديث نتائج التقييم في قاعدة البيانات
    foreach ($results as $result) {
        Bid::where('contractor_id', $result['contractor_id'])
            ->where('tender_id', $tender_id)
            ->update(['final_bid_score' => $result['predicted_score']]);
    }

    // ترتيب العروض حسب التقييم النهائي
    $sorted_bids = Bid::where('tender_id', $tender_id)
        ->orderByDesc('final_bid_score')
        ->get();

    return view('bids.index', compact('tender', 'sorted_bids'));
}
//     public function index(Request $request ,$tender_id)
// {
//     $user=$request->user();
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
//             "technical_requirements_count" => $bid->tender->technical_requirements_count
//         ];
//     });

//     // المسار الكامل إلى Python وملف السكربت
//     $pythonPath = 'C:\Users\Lenovo\AppData\Local\Microsoft\WindowsApps\python.exe';
// $scriptPath = 'C:\\Users\\Lenovo\\Desktop\\course laravel\\TenderLaravel\\ai\\evaluate_tenders.py';

// $results = [];

// foreach ($bids_data as $bid) {
//     $bid_amount = $bid['bid_amount'];
//     $budget = $bid['budget'];
//     $completion_time = $bid['completion_time'];
//     $required_duration = $bid['required_duration'];
//     $quality_certificate_count = $bid['quality_certificates'];
//     $years_of_experience = $bid['projects_last_5_years'];
//     $technical_matched_count = $bid['technical_matched_count'];
//     $technical_requirment_count = $bid['technical_requirements_count'];

//     // الميزانية
//     // $budget_adherence = min(($bid_amount / $budget) * 10, 10);

//     // السرعة
//     // if ($completion_time <= $required_duration) {
//     //     $speed_score = 10;
//     // } else {
//     //     $delay = $completion_time - $required_duration;
//     //     $max_delay = 364;
//     //     $normalized_delay = $delay / $max_delay;
//     //     $speed_score = max(0, 10 * (1 - $normalized_delay));
//     // }

//     // الجودة
//     // $quality_score = min(10, 5 + ($quality_certificate_count * 1) + ($years_of_experience > 5 ? 2 : 0));

//     // التقني
//     // $technical_score = ($technical_matched_count / max($technical_requirment_count, 1)) * 10;

//     // التقييم النهائي (نموذج بسيط تجريبي بديل عن ML)
//     // $final_score = round((
//     //     0.3 * $technical_score +
//     //     0.2 * $budget_adherence +
//     //     0.2 * $quality_score +
//     //     0.3 * $speed_score
//     // ), 2);

//     $results[] = [
//         "contractor_id" => $bid['contractor_id'],
//         "predicted_score" => $final_score,
//     ];
// }

//     // $process->setInput(json_encode($bids_data));
//     // $process->run();

//     // if (!$process->isSuccessful()) {
//     //     throw new ProcessFailedException($process);
//     // }

//     // $results = json_decode($process->getOutput(), true);

//     foreach ($results as $result) {
//         Bid::where('contractor_id', $result['contractor_id'])
//             ->where('tender_id', $tender_id)
//             ->update(['final_bid_score' => $result['predicted_score']]);
//     }

//     $sorted_bids = Bid::where('tender_id', $tender_id)
//         ->orderByDesc('final_bid_score')
//         ->get();

//     return view('bids.index', compact('tender', 'sorted_bids'));
// }

// public function index($tender_id)
// {
//     $tender = Tender::with(['bids.contractor'])->findOrFail($tender_id);

//     // تحضير البيانات للعروض
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
//             "technical_requirements_count" => $bid->tender->technical_requirements_count
//         ];
//     })->values(); // مهم لتحويل من Collection إلى Array مرقّم

//     // تحديد مسار البايثون والسكريبت
//     $pythonPath = 'C:\Users\Lenovo\AppData\Local\Microsoft\WindowsApps\python.exe';
//     $scriptPath = 'C:\\Users\\Lenovo\\Desktop\\course laravel\\TenderLaravel\\ai\\evaluate_tenders.py';

//     // تشغيل السكربت
//     $process = new Process([$pythonPath, $scriptPath]);
//     $process->setInput(json_encode($bids_data));
//     $process->run();

//     if (!$process->isSuccessful()) {
//         throw new ProcessFailedException($process);
//     }

//     $results = json_decode($process->getOutput(), true);

//     // تحديث درجات العروض
//     foreach ($results as $result) {
//         Bid::where('contractor_id', $result['contractor_id'])
//             ->where('tender_id', $tender_id)
//             ->update(['final_bid_score' => $result['predicted_score']]);
//     }

//     // ترتيب العروض حسب الدرجة
//     $sorted_bids = Bid::where('tender_id', $tender_id)
//         ->orderByDesc('final_bid_score')
//         ->get();

//     return view('bids.index', compact('tender', 'sorted_bids'));
// }


public function store(Request $request,$tender)
    {
        $validated = $request->validate([
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
        $bid->tender_id = $tender;

        $bid->contractor_id = 1; 

        $bid->bid_amount = $request->bid_amount;
        $bid->completion_time = $request->completion_time;
        $bid->technical_proposal_pdf = $pdfPath;
        $bid->technical_matched_count = $request->technical_matched_count;
      
        $bid->save();

        return redirect()->route('bid', $request->tender_id)->with('success', 'تم تقديم العرض بنجاح!');
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