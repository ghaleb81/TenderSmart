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
        Schema::table('tenders', function (Blueprint $table) {
            $table->unsignedBigInteger('winner_bid_id')->nullable()->after('status');
                $table->foreign('winner_bid_id')->references('id')->on('bids')->nullOnDelete();

        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('tenders', function (Blueprint $table) {
             $table->dropForeign(['winner_bid_id']);
        $table->dropColumn('winner_bid_id');
        });
    }
};
