<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;
use Illuminate\Support\Facades\Log;

class Kernel extends ConsoleKernel
{
    protected $commands = [
    \App\Console\Commands\CloseExpiredTenders::class,
];

    protected function schedule(Schedule $schedule)
    {
        $schedule->command('app:close-expired-tenders')->everyMinute();

        $schedule->call(function () {
            Log::info("✅ Scheduler is working: " . now());
        })->everyMinute();
    }

    protected function commands()
    {
        $this->load(__DIR__.'/Commands');

        require base_path('routes/console.php');
    }
}
