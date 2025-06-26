<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;
use Illuminate\Support\Facades\Log;
use App\Console\Commands\CloseExpiredTenders;

class Kernel extends ConsoleKernel
{
    protected $commands = [
    CloseExpiredTenders::class,
];
protected $routeMiddleware = [
    // ...
    'CheckUser' => \App\Http\Middleware\CheckUser::class,
];
    protected function schedule(Schedule $schedule)
    {
        $schedule->command(command: 'app:close-expired-tenders')->everyMinute();

        // $schedule->call(function () {
        //     Log::info(" Scheduler is working: " . now());
        // })->everyMinute();


    }

    protected function commands()
    {
        $this->load(__DIR__.'/Commands');

        require base_path('routes/console.php');
    }
}
