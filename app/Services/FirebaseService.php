<?php

namespace App\Services;

use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\Notification;
use Kreait\Firebase\Messaging\CloudMessage;
use Illuminate\Support\Facades\Log;

class FirebaseService
{
    protected $messaging;

    public function __construct()
    {
        try {
            $factory = (new Factory)->withServiceAccount(
                storage_path('firebase/tendersmart-3a8f7-firebase-adminsdk-fbsvc-17f1b40fe9.json')
            );

            $this->messaging = $factory->createMessaging();

            Log::info('Firebase initialized successfully');
        } catch (\Throwable $e) {
            Log::error('Firebase init failed: ' . $e->getMessage());
            throw $e;
        }
    }

    public function sendNotification($token, $title, $body)
    {
        $notification = Notification::create($title, $body);

        $message = CloudMessage::new()
            ->withTarget('token', $token)
            ->withNotification($notification);

        try {
            $response = $this->messaging->send($message);
            Log::info("Notification sent to token: $token | Title: $title | Body: $body");
            return $response;
        } catch (\Throwable $e) {
            Log::error('Firebase Notification Error: ' . $e->getMessage());
            return false;
        }
    }
}
