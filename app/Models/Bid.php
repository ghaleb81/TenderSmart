<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Bid extends Model
{
    use HasFactory;

    protected $fillable = [
        'tender_id',
        'contractor_id',
        'bid_amount',
        'completion_time',
        'technical_proposal_pdf',
        'technical_matched_count',
        'final_bid_score',
        
    ];

    // العلاقة بين العرض والمناقصة
    public function tender()
    {
        return $this->belongsTo(Tender::class);
    }

    // العلاقة بين العرض والمقاول
  public function contractor()
{
    return $this->belongsTo(Contractor::class, 'contractor_id');
}


}
