<?php

// namespace App\Services;

// use Dropbox\Sign\Configuration;
// use Dropbox\Sign\Model\SignatureRequestCreateEmbeddedRequest;
// use Dropbox\Sign\Model\SubSignatureRequestSigner;
// use Dropbox\Sign\Api\SignatureRequestApi;
// use Dropbox\Sign\Api\EmbeddedApi;

// class HelloSignService
// {
//     private SignatureRequestApi $signatureApi;
//     private EmbeddedApi $embeddedApi;
//     private string $clientId;

//     public function __construct()
//     {
//         $apiKey = config('services.hellosign.api_key');
//         $this->clientId = config('services.hellosign.client_id');

//         if (!$apiKey || !$this->clientId) {
//             throw new \Exception("HelloSign API key or Client ID not set in config.");
//         }

//         $config = Configuration::getDefaultConfiguration()
//             ->setUsername($apiKey);

//         $this->signatureApi = new SignatureRequestApi($config);
//         $this->embeddedApi = new EmbeddedApi($config);
//     }

//     // إرسال طلب توقيع مضمّن (Embedded)
//     public function sendEmbeddedSignatureRequest(string $email, string $name, string $filePath)
//     {
//         $signer = new SubSignatureRequestSigner([
//             'email_address' => $email,
//             'name' => $name,
//         ]);

//         $request = new SignatureRequestCreateEmbeddedRequest([
//             'client_id' => $this->clientId,
//             'title' => 'عقد تنفيذ المناقصة',
//             'subject' => 'يرجى توقيع العقد',
//             'message' => 'يرجى توقيع هذا العقد.',
//             'signers' => [$signer],
//             'files' => [$filePath],
//             'test_mode' => true,
//         ]);

//         return $this->signatureApi->signatureRequestCreateEmbedded($request);
//     }

//     // الحصول على رابط التوقيع المضمّن
//     public function getEmbeddedSignUrl(string $signatureId): string
//     {
//         $response = $this->embeddedApi->embeddedSignUrl($signatureId);
//         return $response->getEmbedded()->getSignUrl();
//     }
// } 


namespace App\Services;

use Dropbox\Sign\Configuration;
use Dropbox\Sign\Api\SignatureRequestApi;
use Dropbox\Sign\Model\SignatureRequestSendRequest;
use Dropbox\Sign\Model\SubSignatureRequestSigner;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Http;

class HelloSignService
{
    private SignatureRequestApi $signatureApi;

    public function __construct()
    {
        $apiKey = config('services.hellosign.api_key');

        if (!$apiKey) {
            throw new \Exception("HelloSign API key not set in config.");
        }

        $config = Configuration::getDefaultConfiguration()
            ->setUsername($apiKey);

        $this->signatureApi = new SignatureRequestApi($config);
    }

    //(non-embedded)
    public function sendSignatureRequest(string $email, string $name, string $filePath)
    {
        $signer = new SubSignatureRequestSigner([
            'email_address' => $email,
            'name' => $name,
        ]);

        $request = new SignatureRequestSendRequest([
            'title' => 'عقد تنفيذ المناقصة',
            'subject' => 'يرجى توقيع العقد',
            'message' => 'يرجى توقيع هذا العقد.',
            'signers' => [$signer],
            'files' => [$filePath],
            'test_mode' => true,
        ]);

        return $this->signatureApi->signatureRequestSend($request);
    }

}  