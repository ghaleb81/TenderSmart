<?php
namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class WinnerSelected extends Notification
{
    use Queueable;

   public $tender;
    public function __construct($tender)
    {
               $this->tender = $tender;

    }

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        return ['database'];
    }

    /**
     * Get the mail representation of the notification.
     */
    public function toDatabase( object $notifiable)
{
    return [
        'title' => ' مبروك تم اختيارك كفائز',
        'message' => 'تم اختيار عرضك كفائز في المناقصة: ' . $this->tender->title,
        'tender_id' => $this->tender->id,
    ];
}

    /**
     * Get the array representation of the notification.
     *
     * @return array<string, mixed>
     */
    public function toArray(object $notifiable): array
    {
        return [
            //
        ];
    }
}
