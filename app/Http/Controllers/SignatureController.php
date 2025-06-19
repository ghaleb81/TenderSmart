<?php

namespace App\Http\Controllers;

use App\Models\ContractorSignature;
use Illuminate\Http\Request;

class SignatureController extends Controller
{
    public function handleCallback(Request $request)
{
    $status = $request->input('status'); // 'signed', 'rejected', ...
    $contractId = $request->input('contract_id');

    ContractorSignature::where('id', $contractId)->update(['status' => $status]);

    return response()->json(['message' => 'تم التحديث']);
}

}
