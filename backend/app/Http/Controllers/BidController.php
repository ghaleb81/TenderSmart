<?php

namespace App\Http\Controllers;
use App\Models\Tender;
use Illuminate\Http\Request;
use App\Models\Bid;
use Symfony\Component\Process\Process;
use Symfony\Component\Process\Exception\ProcessFailedException;

class BidController extends Controller
{
    public function index($tender_id)
{
    $tender = Tender::with(['bids.contractor'])->findOrFail($tender_id);

    $bids_data = $tender->bids->map(function ($bid) {
        return [
            "id" => $bid->id,
            "contractor_id" => $bid->contractor_id,
            "bid_amount" => $bid->bid_amount,
            "budget" => $bid->tender->estimated_budget,
            "completion_time" => $bid->completion_time,
            "required_duration" => $bid->tender->execution_duration_days,
            "quality_certificates" => $bid->contractor->quality_certificates ?? 0,
            "projects_last_5_years" => $bid->contractor->projects_last_5_years ?? 0,
            "technical_matched_count" => $bid->technical_matched_count,
            "technical_requirements_count" => $bid->tender->technical_requirements_count
        ];
    });

    // المسار الكامل إلى Python وملف السكربت
    $pythonPath = 'C:\Users\Lenovo\AppData\Local\Microsoft\WindowsApps\python.exe';
$scriptPath = 'C:\\Users\\Lenovo\\Desktop\\course laravel\\TenderLaravel\\ai\\evaluate_tenders.py';

$results = [];

foreach ($bids_data as $bid) {
    $bid_amount = $bid['bid_amount'];
    $budget = $bid['budget'];
    $completion_time = $bid['completion_time'];
    $required_duration = $bid['required_duration'];
    $quality_certificate_count = $bid['quality_certificates'];
    $years_of_experience = $bid['projects_last_5_years'];
    $technical_matched_count = $bid['technical_matched_count'];
    $technical_requirment_count = $bid['technical_requirements_count'];

    // الميزانية
    $budget_adherence = min(($bid_amount / $budget) * 10, 10);

    // السرعة
    if ($completion_time <= $required_duration) {
        $speed_score = 10;
    } else {
        $delay = $completion_time - $required_duration;
        $max_delay = 364;
        $normalized_delay = $delay / $max_delay;
        $speed_score = max(0, 10 * (1 - $normalized_delay));
    }

    // الجودة
    $quality_score = min(10, 5 + ($quality_certificate_count * 1) + ($years_of_experience > 5 ? 2 : 0));

    // التقني
    $technical_score = ($technical_matched_count / max($technical_requirment_count, 1)) * 10;

    // التقييم النهائي (نموذج بسيط تجريبي بديل عن ML)
    $final_score = round((
        0.3 * $technical_score +
        0.2 * $budget_adherence +
        0.2 * $quality_score +
        0.3 * $speed_score
    ), 2);

    $results[] = [
        "contractor_id" => $bid['contractor_id'],
        "predicted_score" => $final_score,
    ];
}

    // $process->setInput(json_encode($bids_data));
    // $process->run();

    // if (!$process->isSuccessful()) {
    //     throw new ProcessFailedException($process);
    // }

    // $results = json_decode($process->getOutput(), true);

    foreach ($results as $result) {
        Bid::where('contractor_id', $result['contractor_id'])
            ->where('tender_id', $tender_id)
            ->update(['final_bid_score' => $result['predicted_score']]);
    }

    $sorted_bids = Bid::where('tender_id', $tender_id)
        ->orderByDesc('final_bid_score')
        ->get();

    return view('bids.index', compact('tender', 'sorted_bids'));
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

        // هنا يمكن تحديد contractor_id بشكل ثابت أو من مصدر آخر
        $bid->contractor_id = 1; // على سبيل المثال، يمكنك تعيين قيمة ثابتة أو استخراجها من مصدر آخر

        $bid->bid_amount = $request->bid_amount;
        $bid->completion_time = $request->completion_time;
        $bid->technical_proposal_pdf = $pdfPath;
        $bid->technical_matched_count = $request->technical_matched_count;
      
        $bid->submission_date = now();
        $bid->save();

        return redirect()->route('bid', $request->tender_id)->with('success', 'تم تقديم العرض بنجاح!');
    }
}
