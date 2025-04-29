<!DOCTYPE html>
<html>
<head>
    <title>العروض المقدمة للمناقصة</title>
    <meta charset="UTF-8">
    <style>
        .box { border: 1px solid #ccc; padding: 10px; margin-bottom: 15px; }
        .alert { padding: 10px; background-color: #d4edda; color: #155724; margin-bottom: 15px; }
    </style>
</head>
<body>

<h1>📄 العروض المقدمة للمناقصة: {{ $tender->title }}</h1>

@if ($tender->bids->isEmpty())
    <p>لا توجد عروض حتى الآن.</p>
@else
    @foreach ($tender->bids as $bid)
        <div class="box">
            <strong>💰 قيمة العرض:</strong> {{ $bid->bid_amount }}<br>
            <strong>⏳ مدة التنفيذ:</strong> {{ $bid->completion_time }} أيام<br>
            <strong>📋 الشروط المحققة:</strong> {{ $bid->technical_matched_count }}<br>
            <strong>📂 الملف الفني:</strong> 
            @if($bid->technical_proposal_pdf)
                <a href="{{ asset('storage/' . $bid->technical_proposal_pdf) }}" target="_blank">عرض</a>
            @else
                غير مرفق
            @endif
            <br>
            <strong>📅 تاريخ التقديم:</strong> {{ $bid->created_at->format('Y-m-d') }}<br>
            <strong>🤖 التقييم الآلي:</strong> {{ $bid->final_bid_score ?? 'لم يُحسب بعد' }}<br>
        </div>
    @endforeach
@endif

</body>
</html>
