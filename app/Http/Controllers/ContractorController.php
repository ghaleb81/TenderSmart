<?php

namespace App\Http\Controllers;

use App\Models\Bid;
use App\Models\Contractor;
use App\Models\ContractorSignature;
use App\Models\Tender;
use App\Services\HelloSignService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Barryvdh\DomPDF\Facade\Pdf;
use Mpdf\Mpdf;
use Illuminate\Support\Facades\Http;


class ContractorController extends Controller
{
     public function index(Request $request)
{
    $contractors = Contractor::all();

    return response()->json([
        'Contractors' => $contractors
    ], 200);
}
    public function showByUserId($id)
{
    $contractor = Contractor::with('bids')->where('user_id', $id)->first();

    if (!$contractor) {
        return response()->json(['message' => 'المقاول غير موجود'], 404);
    }

    return response()->json([
        'contractor' => $contractor
    ], 200);
}
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

    $pdfPath = storage_path("app/contracts/contract_{$bidId}.pdf");

    $mpdf->Output($pdfPath, \Mpdf\Output\Destination::FILE);

    return $pdfPath; // ترجع مسار الملف عشان تستخدمه بعدين
}

// public function sendContractToSign($contractorId, $tenderId, $bidId, HelloSignService $signService)
// {
//     // 1. توليد مسار ملف PDF (عقد المناقصة)
//     $pdfPath = $this->generateContractPdf($contractorId, $tenderId, $bidId);

//     // 2. جلب المقاول والمستخدم التابع له
//     $contractor = Contractor::with('user')->findOrFail($contractorId);
//     $user = $contractor->user;

//     // 3. إرسال العقد إلى HelloSign والحصول على رد التوقيع
//     $response = $signService->sendEmbeddedSignatureRequest(
//         $user->email,
//         $user->name,
//         $pdfPath
//     );

//     // 4. استخراج signature_id من الرد
//     $signatureId = $response['signature_request']['signatures'][0]['signature_id'] ?? null;

//     // 5. توليد رابط التوقيع
//     $signingUrl = $signService->getEmbeddedSignUrl($signatureId);

//     // 6. حفظ سجل التوقيع في قاعدة البيانات
//     \App\Models\ContractorSignature::create([
//         'contractor_id' => $contractorId,
//         'tender_id'     => $tenderId,
//         'bid_id'        => $bidId,
//         'signing_url'   => $signingUrl,
//         'status'        => 'sent',
//     ]);

//     // 7. إرجاع رابط التوقيع (أو redirect أو إرسال لـ front-end)
//     return response()->json([
//         'signing_url' => $signingUrl,
//         'signature_id' => $signatureId,
//     ]);
// }
public function sendContractToSign($contractorId, $tenderId, $bidId, HelloSignService $signService)
{
    $contractor = Contractor::find($contractorId);
    if (!$contractor) {
        return response()->json(['message' => 'المقاول غير موجود'], 404);
    }

    $user = $contractor->user;
    if (!$user || !$user->email) {
        return response()->json(['message' => 'البريد الإلكتروني للمقاول غير متوفر'], 400);
    }

    $filePath = storage_path('app/contracts/contract_' . $bidId . '.pdf');

    if (!file_exists($filePath)) {
        return response()->json(['message' => 'ملف العقد غير موجود'], 404);
    }

  try {
    $response = $signService->sendSignatureRequest(
        $user->email,
        $user->name ?? 'المقاول',
        $filePath
    );

    $signatureRequest = $response->getSignatureRequest();
    $signatureRequestId = $signatureRequest->getSignatureRequestId();

    return response()->json([
        'message' => 'تم إرسال العقد للتوقيع بنجاح.',
        'signature_request_id' => $signatureRequestId,
    ]);
} catch (\Exception $e) {
    return response()->json(['message' => 'حدث خطأ أثناء إرسال العقد: ' . $e->getMessage()], 500);
}
}


//   public function sendToSign($contractorId, $tenderId, $bidId, HelloSignService $signService)
// {
//     $contractor = Contractor::with('user')->findOrFail($contractorId);
//     $tender = Tender::findOrFail($tenderId);
//     $bid = Bid::findOrFail($bidId);

//     // 1. توليد العقد PDF وتخزينه مؤقتًا
//     $html = view('contracts.contracts', compact('contractor', 'tender', 'bid'))->render();
//     $pdfPath = storage_path("app/contracts/contract_{$bid->id}.pdf");

//     $mpdf = new \Mpdf\Mpdf();
//     $mpdf->WriteHTML($html);
//     $mpdf->Output($pdfPath, \Mpdf\Output\Destination::FILE);

//     // 2. إرسال طلب التوقيع المضمّن عبر خدمة HelloSign
//     $response = $signService->sendEmbeddedSignatureRequest(
//         $contractor->user->email,
//         $contractor->user->name,
//         $pdfPath
//     );

//     // 3. استخراج الـ signatureId من الاستجابة
//     $signatures = $response->getSignatureRequest()->getSignatures();
//     $signatureId = $signatures[0]->getSignatureId();

//     // 4. الحصول على رابط التوقيع المضمّن (Embedded Sign URL)
//     $signingUrl = $signService->getEmbeddedSignUrl($signatureId);

//     // 5. حفظ البيانات في قاعدة البيانات
//     ContractorSignature::create([
//         'contractor_id' => $contractorId,
//         'tender_id' => $tenderId,
//         'bid_id' => $bidId,
//         'signing_url' => $signingUrl,
//         'status' => 'sent',
//     ]);

//     // 6. عرض صفحة التوقيع داخل iframe أو إعادة توجيه للرابط
//     return view('contracts.sign', ['signUrl' => $signingUrl]);
// }



// public function testSendContractToSign()
// {
//     $contractorId = 1;  // استبدل بالقيمة المناسبة
//     $tenderId = 1;      // استبدل بالقيمة المناسبة
//     $bidId = 1;         // استبدل بالقيمة المناسبة

//     $signService = app(\App\Services\HelloSignService::class);

//     $pdfPath = $this->generateContractPdf($contractorId, $tenderId, $bidId);

//     $contractor = \App\Models\Contractor::with('user')->findOrFail($contractorId);

//     // 1. أرسل طلب التوقيع
//     $response = $signService->sendEmbeddedSignatureRequest(
//         $contractor->user->email,
//         $contractor->user->name,
//         $pdfPath
//     );

//     // 2. استخرج signature_id
//     $signatureId = $response['signature_request']['signatures'][0]['signature_id'] ?? null;

//     if (!$signatureId) {
//         return response()->json([
//             'error' => 'لم يتم استخراج signature_id'
//         ], 500);
//     }

//     // 3. استدعِ رابط التوقيع باستخدام signature_id
//     $signingUrl = $signService->getEmbeddedSignUrl($signatureId);

//     return response()->json([
//         'message' => 'تم إرسال طلب التوقيع بنجاح',
//         'signing_url' => $signingUrl,
//         'signature_id' => $signatureId,
//         'user_name' => $contractor->user->name
//     ]);
// }




    protected $helloSign;

    public function __construct(HelloSignService $helloSign)
    {
        $this->helloSign = $helloSign;
    }

    // public function downloadSignedContract($signatureRequestId, $bidId)
    // {
    //     try {
    //         $filePath = $this->helloSign->downloadSignedContract($signatureRequestId, $bidId);

    //         return response()->download($filePath, "signed_contract_{$bidId}.pdf", [
    //             'Content-Type' => 'application/pdf'
    //         ]);
    //     } catch (\Exception $e) {
    //         return response()->json([
    //             'message' => 'خطأ في تحميل العقد: ' . $e->getMessage()
    //         ], 500);
    //     }
    // }
}




