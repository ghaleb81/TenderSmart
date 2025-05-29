<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TenderController;
use App\Http\Controllers\BidController;
use App\Http\Controllers\ContractorController;
use App\Http\Controllers\SavedTenderController;
use App\Http\Controllers\UserController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('register',[UserController::class,'register']);
Route::post('login',[UserController::class,'login']);
Route::post('logout',[UserController::class,'logout'])->middleware('auth:sanctum');


Route::post('storeTender', [TenderController::class,'storeApi']);  

Route::get ('showTender/{id}',[TenderController::class,'showApi']); 

Route::get ('indexApi',[TenderController::class,'indexApi']); 


Route::put('updateTender/{id}',[TenderController::class,'updateApi']); 

Route::delete ('destroyTender/{id}',[TenderController::class,'destroyApi']); 

//--------------------------------------For Tender --------------------------------------

// Route::middleware('auth:sanctum')->group(function(){
//     Route::prefix('Tender')->group(function(){
//          Route::get ('/index',[TenderController::class,'indexApi']); 
//          Route::post('/{id}/save',[SavedTenderController::class,'savetender']);
//          Route::delete('/{id}/delete',[SavedTenderController::class,'deletetender']);
//          Route::middleware('CheckUser')->group(function(){
//               Route::get ('/show/{id}',[TenderController::class,'showApi']); 

//               Route::post('/store', [TenderController::class,'storeApi']);

//               Route::put('/update/{id}',[TenderController::class,'updateApi']); 

//                Route::delete ('destroy/{id}',[TenderController::class,'destroyApi']);
// }); 

// });
// });
// });






///------------------------------ for Bid --------------------------------------------------

Route::middleware('auth:sanctum')->group(function(){
    Route::prefix('bid')->group(function(){
        Route::post('/store', [BidController::class, 'storeApi']); // POST
        Route::post('/update', [BidController::class, 'updateApi']); 
                 
    });
});




Route::middleware('auth:sanctum')->group(function(){
    Route::prefix('contractor')->group(function(){
        Route::post('/store', [ContractorController::class, 'store']); // POST

        Route::get('/show/{id}', [ContractorController::class, 'show']); 
        Route::get('/bids',[BidController::class,'previousbids']);
    });
});

//  الحصول على نتيجة التقييم 
Route::get('/bids/{id}/result', [BidController::class, 'result']);