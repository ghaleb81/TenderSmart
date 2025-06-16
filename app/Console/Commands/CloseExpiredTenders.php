<?php

namespace App\Console\Commands;

use App\Models\Tender;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;

class CloseExpiredTenders extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:close-expired-tenders';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Closes tenders whose submission deadline has passed';

    /**
     * Execute the console command.
     */
    public function handle()
{
    $now = Carbon::now();
    Log::info("⏱️ تم تشغيل الأمر في: $now"); // ✅ سطر للتأكد من التشغيل

    $expiredTenders = Tender::where('status', 'opened')
        ->where('submission_deadline', '<', $now)
        ->get();

    if ($expiredTenders->count() > 0) {
        foreach ($expiredTenders as $tender) {
            $tender->status = 'closed';
            $tender->save();
        }

        $this->info("Closed {$expiredTenders->count()} expired tenders.");
        Log::info("Closed {$expiredTenders->count()} expired tenders at " . now());
    } else {
        $this->info("No expired tenders found.");
        Log::info("No expired tenders found at " . now());
    }
}

}
