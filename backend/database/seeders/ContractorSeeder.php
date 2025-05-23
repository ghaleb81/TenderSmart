<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Contractor;

class ContractorSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // إنشاء مستخدمين ومقاولين مرتبطين بهم
        $contractors = [
            [
                'company_name' => 'شركة الأفق',
                'commercial_registration_number' => 'CR10001',
                'company_email' => 'ofok@example.com',
                'country' => 'سوريا',
                'city' => 'حلب',
                'phone_number' => '0987654321',
                'year_established' => 2012,
                'projects_last_5_years' => 6,
                'quality_certificates' => 2,
                'public_sector_successful_contracts' => 'مشاريع مع التعليم العالي والصحة',
                'website_url' => 'https://ofok.com',
                'linkedin_profile' => 'https://linkedin.com/in/ofok',
                'company_bio' => 'تعمل الشركة في مجال الإنشاءات العامة ومشاريع الطرق.',
                'official_documents' => 'documents/ofok.pdf',
            ],
            [
                'company_name' => 'شركة نيوسير',
                'commercial_registration_number' => 'CR342',
                'company_email' => 'neoser@example.com',
                'country' => 'سوريا',
                'city' => 'دمشق',
                'phone_number' => '0987650441',
                'year_established' => 2010,
                'projects_last_5_years' => 8,
                'quality_certificates' => 1,
                'public_sector_successful_contracts' => 'مشاريع مع وزارة الأشغال العامة',
                'website_url' => 'https://neoser.com',
                'linkedin_profile' => 'https://linkedin.com/in/neoser',
                'company_bio' => 'تعمل الشركة في مجال البناء والخدمات الصحية والخدمية.',
                'official_documents' => 'documents/neoser.pdf',
            ]
        ];

        foreach ($contractors as $data) {
            $user = User::factory()->create(); // ينشئ مستخدمًا جديدًا
            $data['user_id'] = $user->id; // ربط المقاول بالمستخدم الجديد
            Contractor::create($data);   // إنشاء المقاول
        }
    }
}
