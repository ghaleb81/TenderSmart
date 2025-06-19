<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class ContractorSignature extends Model
{
       use HasFactory;

    protected $fillable = [
        'contractor_id',
        'tender_id',
        'bid_id',
        'signing_url',
        'status',
        'signed_at',
    ];

    public function contractor()
    {
        return $this->belongsTo(Contractor::class);
    }

    public function tender()
    {
        return $this->belongsTo(Tender::class);
    }

    public function bid()
    {
        return $this->belongsTo(Bid::class);
    }
}
