<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Contractor extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'company_name',
        'commercial_registration_number',
        'company_email',
        'country',
        'city',
        'phone_number',
        'year_established',
        'projects_last_5_years',
        'quality_certificates',
        'public_sector_successful_contracts',
        'website_url',
        'linkedin_profile',
        'company_bio',
        'official_documents',
    ];

    protected $casts = [
        'quality_certificates' => 'array', // تحويلها تلقائياً لمصفوفة عند القراءة والكتابة
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
    public function bids()
{
    return $this->hasMany(Bid::class);
}
public function signatures()
{
    return $this->hasMany(ContractorSignature::class);
}

}
