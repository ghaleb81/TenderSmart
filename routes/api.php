<?php

use App\Http\Controllers\DeviceTokenController;
use App\Http\Controllers\ReportController;
use App\Http\Controllers\SignatureController;
use Illuminate\Http\Request;
use App\Http\Middleware\CheckUser;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TenderController;
use App\Http\Controllers\BidController;
use App\Http\Controllers\ContractorController;
use App\Http\Controllers\notificationcontroller;
use App\Http\Controllers\SavedTenderController;
use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\Log;


Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('register',[UserController::class,'register']);
Route::post('login',[UserController::class,'login']);
Route::post('logout',[UserController::class,'logout'])->middleware('auth:sanctum');
Route::post('/google-login', [UserController::class, 'googleLogin']);


Route::middleware('auth:sanctum')->post('/save-device-token', [DeviceTokenController::class, 'save']);
         
Route::middleware(['auth:sanctum', CheckUser::class . ':admin'])->group(function () {
    Route::get('report/summary', [ReportController::class, 'summary']);
});
        Route::get('report/trends', [ReportController::class, 'priceTrends']);
        Route::get('report/contractor-performance', [ReportController::class, 'contractorStats']);











// Route::post('storeTender', [TenderController::class,'storeApi']);  

// Route::get ('showTender/{id}',[TenderController::class,'showApi']); 

// Route::get ('indexApi',[TenderController::class,'indexApi']); 


// Route::put('updateTender/{id}',[TenderController::class,'updateApi']); 

// Route::delete ('destroyTender/{id}',[TenderController::class,'destroyApi']); 

//--------------------------------------For Tender --------------------------------------

Route::middleware('auth:sanctum')->group(function(){
    Route::prefix('Tender')->group(function(){
         Route::get ('/index',[TenderController::class,'indexApi']); 
         Route::post('/{id}/save',[SavedTenderController::class,'savetender']);
         Route::delete('/{id}/delete',[SavedTenderController::class,'deletetender']);
         Route::get('/saved',[SavedTenderController::class,'getSavedTenders']);
         Route::get('/opened',[TenderController::class,'openedTenders']);


         Route::middleware([CheckUser::class.':admin'])->group(function(){
              Route::get ('/show/{id}',[TenderController::class,'showApi']); 

              Route::post('/store', [TenderController::class,'storeApi']);

              Route::put('/update/{id}',[TenderController::class,'updateApi']); 

               Route::delete ('destroy/{id}',[TenderController::class,'destroyApi']);
               Route::post('/winner', [TenderController::class, 'setManualWinner']);

               Route::post('{tender}/evaluate', [BidController::class, 'evaluateBidsApi']);


}); 

});
});


Route::middleware('auth:sanctum')->get('/notifications', function (Illuminate\Http\Request $request) {
    return $request->user()->notifications;
});





///------------------------------ for Bid --------------------------------------------------

Route::middleware('auth:sanctum')->group(function(){
    Route::prefix('bid')->group(function(){
        Route::post('/store', [BidController::class, 'storeApi']); // POST
        Route::put('/update/{id}', [BidController::class, 'updateApi']); 
        Route::middleware([CheckUser::class.':admin,committee'])->group(function(){

           Route::get('/index', [BidController::class, 'index']);

            Route::get('/show/{id}',[BidController::class,'show']);
       Route::middleware([CheckUser::class.':admin'])->group(function () {
           Route::get('/index', [BidController::class, 'index']);
});

    });

                 
    });
});




Route::middleware('auth:sanctum')->group(function(){
    Route::prefix('contractor')->group(function(){
        Route::post('/store', [ContractorController::class, 'store']); // POST
        Route::get('/user/{id}', [ContractorController::class, 'showByUserId']);   

        Route::get('/bids',[BidController::class,'previousbids']);
        Route::get('/show/{id}', [ContractorController::class, 'index']);

        Route::get('/show', [ContractorController::class, 'index']);
    });   

});

//  الحصول على نتيجة التقييم 
Route::get('/bids/{id}/result', [BidController::class, 'result']);

Route::get('/contract/pdf/{contractor}/{tender}/{bid}', 
 [ContractorController::class, 'generateContractPdf'])->name('contract.pdf');

// Route::post('/docsign/callback', [SignatureController::class, 'handleCallback']);


Route::get('/contracts/send/{contractorId}/{tenderId}/{bidId}', 
[ContractorController::class, 'sendToSign'])->name('contract.send');




// Route::get('/test-signature', [SignatureController::class, 'test']);

Route::get('/send-to-sign/{contractorId}/{tenderId}/{bidId}', 
[ContractorController::class, 'sendContractToSign']);






               
Route::get('/contracts/download/{signatureRequestId}/{bidId}', [ContractorController::class, 'downloadSignedContract']);


Route::get('/test-send-contract', [ContractorController ::class , 'testSendContractToSign']);


Route::get('/test-env', function () {
    return env('HELLOSIGN_CLIENT_ID');
});


use App\Services\HelloSignService;

Route::get('/test-hellosign', function (HelloSignService $service) {
    $testPdf = storage_path('app/test.pdf'); // ملف بسيط صغير

    if (!file_exists($testPdf)) {
        file_put_contents($testPdf, 'Test Contract');
    }

    return $service->sendSignatureRequest(
        'alkhatibeyad3@gmail.com',
        'اسم تجريبي',
        $testPdf
    );
});

