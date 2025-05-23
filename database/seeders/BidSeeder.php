<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Bid;
use App\Models\Tender;
use App\Models\Contractor;

class BidSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $tender = Tender::first();
    $contractors = Contractor::all();

    Bid::create([
        'tender_id' => 1, // تأكد أن المناقصة موجودة
        'contractor_id' => 1, // تأكد أن المقاول موجود
        'bid_amount' => 8500000,
        'completion_time' => 90,
        'technical_proposal_pdf' => 'bids/technical_proposals/proposal1.pdf',
        'technical_matched_count' => 8,
        'final_bid_score' => null, // سيملأه سكربت التقييم لاحقًا
    ]);
    Bid::create([
        'tender_id' => 1,
        'contractor_id' => 2,
        'bid_amount' => 7200000,
        'completion_time' => 85,
        'technical_proposal_pdf' => 'bids/technical_proposals/contractor2.pdf',
        'technical_matched_count' => 9,
        'final_bid_score' => null,
    ]);
    Bid::create([
        'tender_id' => 1,
        'contractor_id' => 2,
        'bid_amount' => 600000,
        'completion_time' => 70,
        'technical_proposal_pdf' => 'bids/technical_proposals/contractor2.pdf',
        'technical_matched_count' => 9,
        'final_bid_score' => null,
    ]);

    Bid::create([
        'tender_id' => 1,
        'contractor_id' => 2,
        'bid_amount' => 9000000,
        'completion_time' => 120,
        'technical_proposal_pdf' => 'bids/technical_proposals/contractor2.pdf',
        'technical_matched_count' => 8,
        'final_bid_score' => null,
    ]);

    Bid::create([
        'tender_id' => 1,
        'contractor_id' => 1,
        'bid_amount' => 9500000,
        'completion_time' => 100,
        'technical_proposal_pdf' => 'bids/technical_proposals/contractor2.pdf',
        'technical_matched_count' => 6,
        'final_bid_score' => null,
    ]);


    Bid::create([
        'tender_id' => 1,
        'contractor_id' => 1,
        'bid_amount' => 5000000,
        'completion_time' => 90,
        'technical_proposal_pdf' => 'bids/technical_proposals/contractor2.pdf',
        'technical_matched_count' => 4,
        'final_bid_score' => null,
    ]);
    }
    }

