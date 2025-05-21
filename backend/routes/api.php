<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TenderController;
use App\Http\Controllers\BidController;
use App\Http\Controllers\ContractorController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');


//  إضافة مناقصة 
Route::post('/storeTender', [TenderController::class,'storeApi']);  

Route::get ('showTender/{id}',[TenderController::class,'showApi']); 

Route::get ('indexApi',[TenderController::class,'indexApi']); 


Route::put('updateTender/{id}',[TenderController::class,'updateApi']); 

Route::delete ('destroyTender/{id}',[TenderController::class,'destroyApi']); 


//  تقديم عرض لمناقصة
Route::post('/bids', [BidController::class, 'store']); // POST

//  إرسال معلومات المقاول
Route::post('/storeContractore', [ContractorController::class, 'store']); // POST

Route::get('/showContractor/{id}', [ContractorController::class, 'show']); 
//  الحصول على نتيجة التقييم 
Route::get('/bids/{id}/result', [BidController::class, 'result']);