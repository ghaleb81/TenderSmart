<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('bids', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('tender_id'); // رقم المناقصة المرتبطة
            $table->unsignedBigInteger('contractor_id'); // رقم المقاول (من جلسة الدخول)
            $table->decimal('bid_amount', 15, 2); // قيمة العرض
            $table->integer('completion_time'); // مدة التنفيذ المقترحة (باليام)
            $table->string('technical_proposal_pdf')->nullable(); // ملف العرض الفني (PDF)
            $table->integer('technical_matched_count'); // ملف العرض الفني (PDF)
 
            $table->decimal('final_bid_score', 5, 2)->nullable(); // التقييم الآلي للعرض
            $table->timestamps();
        
        $table->foreign('tender_id')->references('id')->on('tenders')->onDelete('cascade');
        $table->foreign('contractor_id')->references('id')->on('users')->onDelete('cascade'); // assuming contractor is a user
    });
    
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('bids');
    }
};
