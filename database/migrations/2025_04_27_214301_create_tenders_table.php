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
        Schema::create('tenders', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->text('description')->nullable();
            $table->string('location');
            $table->decimal('estimated_budget', 15, 2);
            $table->integer('execution_duration_days');
            $table->date('submission_deadline');
            $table->integer('technical_requirements_count')->default(0);
            $table->enum('status', ['opened', 'progress', 'closed'])->default('opened');
            $table->string('attached_file')->nullable(); // Path to PDF

            $table->timestamps();

            $table->foreignId('created_by')->nullable()->constrained('users')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tenders');
    }
};
