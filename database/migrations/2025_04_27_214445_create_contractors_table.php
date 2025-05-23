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
        Schema::create('contractors', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id'); // لربط المقاول بالمستخدم (يفترض وجود users table)

            $table->string('company_name');
            $table->string('commercial_registration_number');
            $table->string('company_email');
            $table->string('country');
            $table->string('city')->nullable();
            $table->string('phone_number');
            $table->year('year_established');
            $table->integer('projects_last_5_years');
            $table->json('quality_certificates')->nullable(); // كخيارات، نخزنها JSON
            $table->text('public_sector_successful_contracts')->nullable();
            $table->string('website_url')->nullable();
            $table->string('linkedin_profile')->nullable();
            $table->text('company_bio')->nullable();
            $table->string('official_documents')->nullable(); // رابط المستندات بعد الرفع

            $table->timestamps();

            // علاقة Foreign Key
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('contractors');
    }
};
