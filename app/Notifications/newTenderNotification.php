<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;

class NewTenderNotification extends Notification
{
    use Queueable;

    protected $tender;

    public function __construct($tender)
    {
        $this->tender = $tender;
    }

    public function via($notifiable)
    {
        return ['database'];
    }

    public function toDatabase($notifiable)
    {
        return [
            'title' => 'تمت إضافة مناقصة جديدة',
            'body' => "تمت إضافة المناقصة: {$this->tender->title}",
            'tender_id' => $this->tender->id,
        ];
    }
}
    