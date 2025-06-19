<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class DeviceTokenController extends Controller
{
    public function save(Request $request)
    {
        $request->validate([
            'device_token' => 'required|string',
        ]);

        $user = $request->user(); 

        $user->device_token = $request->device_token;
        $user->save();

        return response()->json([
            'message' => ' تم حفظ توكن الجهاز بنجاح'
        ]);
    }
}

