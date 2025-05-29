<?php

namespace App\Http\Controllers;

use App\Models\Tender;
use Illuminate\Http\Request;


class SavedTenderController extends Controller
{
    public function savetender(Request $request,$tenderId){

        $user = $request->user();

    $tender = Tender::findOrFail($tenderId);

    if ($user->savedTenders()->where('tender_id', $tenderId)->exists()) {
        return response()->json(['message' => 'تم حفظ المناقصة مسبقًا'],
         200);
    }

    $user->savedTenders()->attach($tenderId);

    return response()->json(['message' => 'تم حفظ المناقصة بنجاح'],
     201);
        
        


    }

    public function deletetender(Request $request,$tenderId){
        $user=$request->user();
        $user->savedTenders()->detach($tenderId);

        return response()->json(['message' => 'تم إزالة المناقصة من المحفوظات'],
         200);


    }
    public function getSavedTenders(Request $request)
{
    $user = $request->user();
    $savedTenders = $user->savedTenders()->get();

    return response()->json($savedTenders);
}

}
