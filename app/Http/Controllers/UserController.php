<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Google_Client;
use Illuminate\Support\Str;


class UserController extends Controller
{
   public function register(Request $request){
$request->validate(['name'=>'required|string|max:255',
'email'=>'required|string|email|max:255|unique:users,email',
'password'=>'required|string|min:8|confirmed',
'phone' => 'required|string|regex:/^([0-9\s\-\+\(\)]*)$/|min:10|max:15|unique:users,phone',
 ]);
    $user=User::create([
        'name'=>$request->name,
        'email'=>$request->email,
        'password'=>Hash::make($request->password),
        'phone'=>$request->phone
    ]);
$token = $user->createToken('auth_token')->plainTextToken;

    return response()->json([
        'access_token' => $token,
        'token_type' => 'Bearer',
        
    ], 201);    }
    
    public function login(Request $request){
    $request->validate([

        'email'=>'required|string|email',
        'password'=>'required|string']);

if (!Auth::attempt($request->only('email','password')))
    return response()->json([
        'message'=>'invalid email or password'
],401);
$user=User::where('email',$request->email)->firstOrFail();
$token=$user->createToken('auth_token')->plainTextToken;
 return response()->json([
        'access_token' => $token,
        'token_type' => 'Bearer',
        'role'=>$request->user()->role,
        'user_id'=>$request->user()->id
    ]);
// return response()->json([
//         'message'=>'Token created',
//         'Token'=> $token,

// ],200);
        }

  public function logout(Request $request){
    /** @var \Laravel\Sanctum\PersonalAccessToken $token */

   $token= $request->user()->currentAccessToken();
$token->delete();
return response()->json([
        'message'=>'Successfully ',

],200);
 }

public function googleLogin(Request $request)
{
    $request->validate([
        'idToken' => 'required|string',
    ]);

    $idToken = $request->idToken;

    $client = new Google_Client(['client_id' => env('GOOGLE_CLIENT_ID')]);
    $payload = $client->verifyIdToken($idToken);

    if (!$payload) {
        return response()->json(['error' => 'Invalid Google ID token'], 401);
    }

    // تحقق من التحقق من البريد
    if (!isset($payload['email_verified']) || $payload['email_verified'] !== true) {
        return response()->json(['error' => 'Email not verified by Google'], 403);
    }

    $email = $payload['email'];
    $name = $payload['name'] ?? 'Google User';

    // جلب أو إنشاء المستخدم
    $user = User::firstOrCreate(
        ['email' => $email],
        [
            'name' => $name,
            'password' => Hash::make(Str::random(16)), // كلمة سر عشوائية
        ]
    );

    $token = $user->createToken('auth_token')->plainTextToken;

    return response()->json([
        'access_token' => $token,
        'token_type' => 'Bearer',
        'user' => $user,
    ]);
}


}
