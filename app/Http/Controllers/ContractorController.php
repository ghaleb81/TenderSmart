<?php

namespace App\Http\Controllers;

use App\Models\Bid;
use App\Models\Contractor;
use App\Models\ContractorSignature;
use App\Models\Tender;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Barryvdh\DomPDF\Facade\Pdf;
use Mpdf\Mpdf;
use Illuminate\Support\Facades\Http;


class ContractorController extends Controller
{
    /**
     * Show the contractor form.
     * 
     * 
     */
    public function show(Request $request){
    $user=$request->user();
    $contractor = Contractor::with('bids')->where('user_id', $user->id)->first();
        return response()->json(["The Detail of Contactor:"=>$contractor],200);
    }

    /**
     * Store contractor data.
     */
    public function store(Request $request)
    {
        $request->validate([
            'company_name' => 'required|string|max:255',
            'commercial_registration_number' => 'required|string|max:255',
            'company_email' => 'required|email|max:255',
            'country' => 'required|string|max:255',
            'city' => 'nullable|string|max:255',
            'phone_number' => 'required|string|max:20',
            'year_established' => 'required|digits:4|integer|min:1900|max:' . date('Y'),
            'projects_last_5_years' => 'required|integer|min:0',
            'quality_certificates' => 'required|array|',
            'quality_certificates.*' => 'string',
            'public_sector_successful_contracts' => 'nullable|string',
            'website_url' => 'nullable|url|max:255',
            'linkedin_profile' => 'nullable|url|max:255',
            'company_bio' => 'nullable|string',
            'official_documents' => 'nullable|file|mimes:pdf,doc,docx,zip',
        ]);

        $data = $request->except('official_documents');
        $data['user_id'] =$request->user_id;

        if ($request->hasFile('official_documents')) {
            $filePath = $request->file('official_documents')->store('contractor_documents', 'public');
            $data['official_documents'] = $filePath;
        }

        Contractor::updateOrCreate(
            ['user_id' => $request->user_id],
            $data
        );

        // return redirect()->back()->with('success', 'تم حفظ بيانات المقاول بنجاح.');
        return response()->json(["message:"=>'Success']);
    }

    public function checkProfile(Request $request)
{
    $user = $request->user();

    $hasProfile = $user->contractor()->exists(); 
    return response()->json([
        'has_profile' => $hasProfile,
    ], 200);
}

public function generateContractPdf($contractorId, $tenderId, $bidId)
{
    $contractor = Contractor::findOrFail($contractorId);
    $tender = Tender::findOrFail($tenderId);
    $bid = Bid::findOrFail($bidId);

    $html = view('contracts.contracts', compact('contractor', 'tender', 'bid'))->render();

    $mpdf = new \Mpdf\Mpdf([
        'mode' => 'utf-8',
        'format' => 'A4',
        'default_font' => 'dejavusans',
        'autoLangToFont' => true,
        'autoScriptToLang' => true,
    ]);

    $mpdf->WriteHTML($html);

    return $mpdf->Output('contract.pdf', 'I');
}

public function sendToSign($contractorId, $tenderId, $bidId)
{
    $contractor = Contractor::with('user')->findOrFail($contractorId);
    $tender = Tender::findOrFail($tenderId);
    $bid = Bid::findOrFail($bidId);

    // توليد PDF وتخزينه مؤقتاً
    $html = view('contracts.contracts', compact('contractor', 'tender', 'bid'))->render();
    $pdfPath = storage_path("app/contracts/contract_{$bid->id}.pdf");

    $mpdf = new \Mpdf\Mpdf();
    $mpdf->WriteHTML($html);
    $mpdf->Output($pdfPath, \Mpdf\Output\Destination::FILE);

    // إرسال الملف إلى Docsign API
    $response = Http::withToken('YOUR_DOCSIGN_API_TOKEN')
        ->attach('file', file_get_contents($pdfPath), 'contract.pdf')
        ->post('https://api.docsign.com/send', [
            'recipient_name' => $contractor->user->name,
            'recipient_email' => $contractor->user->email,
            'subject' => 'عقد تنفيذ المناقصة',
            'message' => 'يرجى توقيع العقد المرفق.'
        ]);

    if ($response->successful()) {
        $data = $response->json();

        // حفظ الرابط أو ID في قاعدة البيانات
        ContractorSignature::create([
            'contractor_id' => $contractorId,
            'tender_id' => $tenderId,
            'bid_id' => $bidId,
            'signing_url' => $data['signing_url'], // أو حسب الاستجابة الفعلية
            'status' => 'sent',
        ]);

        return redirect($data['signing_url']); // إعادة التوجيه للتوقيع
    }

    return back()->with('error', 'فشل إرسال العقد للتوقيع.');
}

}


