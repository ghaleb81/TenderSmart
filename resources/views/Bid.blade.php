<!DOCTYPE html>
<html>
<head>
    <title>لوحة التحكم - العروض</title>
    <meta charset="UTF-8">
    <style>
        .alert { padding: 10px; background-color: #d4edda; color: #155724; margin-bottom: 15px; }
        .error { padding: 10px; background-color: #f8d7da; color: #721c24; margin-bottom: 15px; }
        .box { border: 1px solid #ccc; padding: 10px; margin-bottom: 15px; }
    </style>
</head>
<body>
<h1>إدارة العروض للمناقصة: {{ $tender->title }}</h1>

<!-- ✅ عرض رسالة نجاح -->
@if (session('success'))
    <div class="alert">{{ session('success') }}</div>
@endif

<!-- ✅ عرض رسائل أخطاء التحقق -->
@if ($errors->any())
    <div class="error">
        <ul>
            @foreach ($errors->all() as $error)
                <li>⚠️ {{ $error }}</li>
            @endforeach
        </ul>
    </div>
@endif

<!-- ✅ نموذج تقديم العرض -->
<form action="{{ route('bid.store', $tender->id) }}" method="POST" enctype="multipart/form-data">
    @csrf

    <label>قيمة العرض:</label><br>
    <input type="number" name="bid_amount" required><br><br>

    <label>مدة التنفيذ المقترحة (بالأيام):</label><br>
    <input type="number" name="completion_time" required><br><br>

    <label>الملف الفني (PDF):</label><br>
    <input type="file" name="technical_proposal_pdf" accept=".pdf"><br><br>

    <label>عدد الشروط الفنية المحققة:</label><br>
    <input type="number" name="technical_matched_count" required><br><br>

    <button type="submit">تقديم العرض</button>
</form>

<!-- ✅ قائمة العروض المقدمة -->
<h3>العروض المقدمة:</h3>
@foreach ($tender->bids as $bid)
    <div class="box">
        <strong>قيمة العرض:</strong> {{ $bid->bid_amount }}<br>
        <strong>مدة التنفيذ المقترحة:</strong> {{ $bid->completion_time }} أيام<br>

        <strong>الملف الفني:</strong>
        @if ($bid->technical_proposal_pdf)
            <a href="{{ asset('storage/' . $bid->technical_proposal_pdf) }}" target="_blank">عرض الملف</a><br>
        @else
            لا يوجد<br>
        @endif

        <strong>عدد الشروط الفنية المحققة:</strong> {{ $bid->technical_matched_count }}<br>
        <strong>التقييم الآلي:</strong> {{ $bid->final_bid_score ?? 'غير محدد بعد' }}<br>
    </div>
@endforeach

</body>
</html>
