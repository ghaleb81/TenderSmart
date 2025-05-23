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

<table class="table mt-4">
    <thead>
        <tr>
            <th>المقاول</th>
            <th>قيمة العرض</th>
            <th>المدة</th>
            <th>الدرجة النهائية</th>
        </tr>
    </thead>
    <tbody>
        @foreach($sorted_bids as $bid)
        <tr>
            <td>{{ $bid->contractor->company_name ?? '---' }}</td>
            <td>{{ $bid->bid_amount }}</td>
            <td>{{ $bid->completion_time }} يوم</td>
            <td>{{ round($bid->final_bid_score, 2) }}</td>
        </tr>
        @endforeach
    </tbody>
</table>

</body>
</html>
