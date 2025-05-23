<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Tender;


class TenderSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Tender::create([
            'title' => 'مشروع بناء مدرسة ابتدائية',
            'description' => 'مناقصة لبناء مدرسة وفق المعايير الحديثة.',
            'location' => 'دمشق',
            'estimated_budget' => 8000000,
            'execution_duration_days' => 120,
            'submission_deadline' => now()->addDays(7),
            'technical_requirements_count' => 10,
            'status' => 'opened',
            'created_by' => 1,
            'attached_file' => 'tenders/specs1.pdf',
        ]);
    }
}
