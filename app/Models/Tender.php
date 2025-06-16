<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Tender extends Model
{
    use HasFactory;

    protected $fillable = [
        'title',
        'description',
        'location',
        'estimated_budget',
        'execution_duration_days',
        'submission_deadline',
        'technical_requirements_count',
        'status',
        'created_by',
        'attached_file',
    ];

    public function bids() { 
        return 
        $this->hasMany(Bid::class); }

    public function savedByUsers()
{
    return $this->belongsToMany(User::class, 'saved_tenders')->withTimestamps();
}
public function winnerBid()
{
    return $this->belongsTo(Bid::class, 'winner_bid_id');
}


}
