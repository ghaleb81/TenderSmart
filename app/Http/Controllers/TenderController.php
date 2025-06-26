<?php

namespace App\Http\Controllers;

use App\Models\Bid;
use App\Models\Tender;
use App\Models\User;
use App\Notifications\NewTenderNotification;
use App\Notifications\WinnerSelected;
use App\Services\FirebaseService;
use App\Services\HelloSignService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class TenderController extends Controller   
{
    
    public function index()
    {
        $tenders = Tender::all();
        return view('dashboard', compact(var_name: 'tenders'));
    }

   public function indexApi(Request $request)
{
    $tenders = Tender::orderBy('submission_deadline', 'desc')->paginate(20);

    return response()->json([
        'tenders' => $tenders
    ], 200);
}

    public function openedTenders()
{
    $tenders = Tender::where('status', 'opened')->paginate(10); // 10 بكل صفحة

    return response()->json([
        'message' => 'تمت العملية بنجاح',
        'data' => $tenders,
    ], 200);
}


    public function store(Request $request)
    {
        $request->validate([    
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'location' => 'required|string|max:255',
            'estimated_budget' => 'nullable|numeric',
            'execution_duration_days' => 'nullable|integer',
            'submission_deadline' => 'required|date|after:today',
            'technical_requirements_count' => 'nullable|integer|min:0',
            'attached_file' => 'nullable|file|mimes:pdf,doc,docx,zip',
        ]);

        $data = $request->except('attached_file');

        if ($request->hasFile('attached_file')) {
            $filePath = dd($request->file('attached_file'))->store('tender_files', 'public');
            $data['attached_file'] = $filePath;
        }

        Tender::create($data);

        return redirect()->back()->with('success', 'تم إنشاء المناقصة بنجاح.');
    }
    public function storeApi(Request $request,FirebaseService $firebase)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'location' => 'required|string|max:255',
            'estimated_budget' => 'nullable|numeric',
            'execution_duration_days' => 'nullable|integer',
            'submission_deadline' => 'required|date|after:today',
            'technical_requirements_count' => 'nullable|integer|min:0',
            'attached_file' => 'nullable|file|mimes:pdf,doc,docx,zip',
        ]);
    
        $data = $request->except('attached_file');
    
        if ($request->hasFile('attached_file')) {
            $filePath = $request->file('attached_file')->store('tender_files', 'public');
            $data['attached_file'] = $filePath;
        }
    
        $tender = Tender::create($data);
    $users = User::whereNotNull('device_token')->get();
         foreach ($users as $user) {
        $firebase->sendNotification(
            $user->device_token,
            ' تمت إضافة مناقصة جديدة',
            $tender->title
        );
    
}
    $tender->attached_file_url = $tender->attached_file
        ? asset('storage/' . $tender->attached_file)
        : null;

        return response()->json([
            'message' => 'تم إنشاء المناقصة بنجاح.',
            'data' => $tender,
        ], 201);
    }

    /**
     * عرض تفاصيل مناقصة محددة.
     */
    public function show($id)
    {
        $tender = Tender::with('bids')->findOrFail($id);
        return view('tenders.show', compact('tender'));
    }


    public function showApi($id)
    {
        $tender = Tender::with('bids')->findOrFail($id);
        return response()->json([
                "Tender is "=>$tender],200);
    }

    /**
     * تحديث مناقصة محددة.
     */
    public function update(Request $request, $id)
    {
        $tender = Tender::findOrFail($id);

        $request->validate([
            'title' => '|string|max:255',
            'description' => '|string',
            'location' => '|string|max:255',
            'estimated_budget' => 'nullable|numeric',
            'execution_duration_days' => 'nullable|integer',
            'submission_deadline' => '|date',
            'technical_requirements_count' => 'nullable|integer|min:0',
            'attached_file' => 'nullable|file|mimes:pdf,doc,docx,zip',
        ]);

        $data = $request->except('attached_file');

        if ($request->hasFile('attached_file')) {
            if ($tender->attached_file) {
                Storage::disk('public')->delete($tender->attached_file);
            }
            $filePath = $request->file('attached_file')->store('tender_files', 'public');
            $data['attached_file'] = $filePath;
        }

        $tender->update($data);

        return redirect()->back()->with('success', 'تم تحديث المناقصة بنجاح.');
    }
    public function updateApi(Request $request,$id){
        $tender = Tender::findOrFail($id);

        $request->validate([
            'title' => '|string|max:255',
            'description' => '|string',
            'location' => '|string|max:255',
            'estimated_budget' => 'nullable|numeric',
            'execution_duration_days' => 'nullable|integer',
            'submission_deadline' => '|date',
            'technical_requirements_count' => 'nullable|integer|min:0',
            'attached_file' => 'nullable|file|mimes:pdf,doc,docx,zip',
        ]);
        $data = $request->except('attached_file');

        if ($request->hasFile('attached_file')) {
            if ($tender->attached_file) {
                Storage::disk('public')->delete($tender->attached_file);
            }
            $filePath = $request->file('attached_file')->store('tender_files', 'public');
            $data['attached_file'] = $filePath;
        }

        $tender->update($data);

        return response()->json(["message"=>"تم تحديث المناقصة بنجاح.",'dataa:'=> $tender],200);
    }

    /**
     * حذف مناقصة.
     */
    public function destroy($id)
    {
        $tender = Tender::findOrFail($id);

        if ($tender->attached_file) {
            Storage::disk('public')->delete($tender->attached_file);
        }

        $tender->delete();

        return redirect()->back()->with('success', 'تم حذف المناقصة بنجاح.');
    }

    public function destroyApi($id){
        $tender = Tender::findOrFail($id);

        if ($tender->attached_file) {
            Storage::disk('public')->delete($tender->attached_file);
        }

        $tender->delete();
        return response()->json(["message"=>"تم حذف المناقصة بنجاح."],200);
    }

   public function selectWinner($tenderId)
{
    //  جلب المناقصة والعروض والمقاول المرتبط بكل عرض
    $tender = Tender::with('bids.contractor.user')->findOrFail($tenderId);

    //  التأكد أن المناقصة مغلقة
    if ($tender->status !== 'closed') {
        return response()->json(['message' => 'لا يمكن اختيار الفائز إلا بعد إغلاق المناقصة.'], 400);
    }

    //  التأكد من وجود عروض
    if ($tender->bids->isEmpty()) {
        return response()->json(['message' => 'لا توجد عروض لهذه المناقصة.'], 404);
    }

    //  اختيار العرض بأعلى final_bid_score
    $winningBid = $tender->bids->sortByDesc('final_bid_score')->first();

    //  تحديث المناقصة بربط العرض الفائز
    $tender->winner_bid_id = $winningBid->id;
    $tender->save();

    // إرسال إشعار Firebase للمقاول الفائز
    $contractorUser = $winningBid->contractor->user;

    if ($contractorUser->device_token) {
        app(FirebaseService::class)->sendNotification(
            $contractorUser->device_token,
            ' تهانينا! فزت بالمناقصة',
            "لقد تم اختيار عرضك كعرض فائز في مناقصة: {$tender->title}"
        );
    }

    //  إنشاء العقد وإرساله للتوقيع
    app(ContractorController::class)
        ->sendContractToSign($winningBid->contractor_id, $tender->id, $winningBid->id, app(\App\Services\HelloSignService::class));

    return response()->json([
        'message' => 'تم اختيار الفائز وإرسال إشعار وإنشاء عقد.',
        'winner_bid' => $winningBid
    ]);
}

public function setManualWinner(Request $request)
{
    $request->validate([
        'tender_id' => 'required|exists:tenders,id',
        'bid_id' => 'required|exists:bids,id',
    ]);

    $tender = Tender::with('bids')->find($request->tender_id);

    if (!$tender) {
        return response()->json(['message' => 'المناقصة غير موجودة'], 404);
    }

    if ($tender->status !== 'closed') {
        return response()->json(['message' => 'لا يمكن اختيار فائز قبل إغلاق المناقصة.'], 400);
    }

    if ($tender->bids->isEmpty()) {
        return response()->json(['message' => 'لا توجد عروض مرتبطة بهذه المناقصة.'], 404);
    }

    $bid = Bid::find($request->bid_id);

    if (!$bid) {
        return response()->json(['message' => 'العرض غير موجود'], 404);
    }

    if ($bid->tender_id !== $tender->id) {
        return response()->json(['message' => 'العرض لا يتبع لهذه المناقصة.'], 400);
    }

    // تعيين العرض كفائز يدويًا
    $tender->manual_winner_bid_id = $bid->id;
    $tender->save();

    // إرسال إشعار للمقاول الفائز
    if ($bid->contractor && $bid->contractor->user && $bid->contractor->user->device_token) {
        app(FirebaseService::class)->sendNotification(
            $bid->contractor->user->device_token,
            'تهانينا! فزت بالمناقصة',
            "لقد تم اختيار عرضك كعرض فائز في مناقصة: {$tender->title}"
        );
    }

//     // إرسال العقد للتوقيع
// $contractController = app(ContractorController::class);
// $signService = app(\App\Services\HelloSignService::class);

// $response = $contractController->sendContractToSign(
//     $bid->contractor_id,
//     $tender->id,
//     $bid->id,
//     $signService
// );

// // استخرج رابط التوقيع لتسليمه للواجهة
// $signingUrl = $response->getData(true)['signing_url'] ?? null;

// return response()->json([
//     'message' => 'تم تعيين العرض الفائز يدويًا بنجاح، وتم إرسال العقد للتوقيع.',
//     'signing_url' => $signingUrl
// ]);

// }


try {
    // استدعاء الكونترولر وخدمة HelloSign
    $contractController = app(ContractorController::class);
    $signService = app(HelloSignService::class);

    // إرسال العقد للتوقيع
    $response = $contractController->sendContractToSign(
        $bid->contractor_id,
        $tender->id,
        $bid->id,
        $signService
    );

    return response()->json([
        'message' => 'تم تعيين العرض الفائز يدويًا بنجاح، وتم إرسال العقد إلى بريد المقاول للتوقيع.',
        'email' => $bid->contractor->user->email,
        'hellosign_response' => $response 
    ]);

} catch (\Exception $e) {
    return response()->json([
        'error' => 'حدث خطأ أثناء إرسال العقد للتوقيع: ' . $e->getMessage()
    ], 500);
}
}}