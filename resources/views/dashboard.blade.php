<!DOCTYPE html>
<html>
<head>
    <title>لوحة التحكم - المناقصات</title>
    <meta charset="UTF-8">
    <style>
        .alert { padding: 10px; background-color: #d4edda; color: #155724; margin-bottom: 15px; }
        .error { padding: 10px; background-color: #f8d7da; color: #721c24; margin-bottom: 15px; }
        .box { border: 1px solid #ccc; padding: 10px; margin-bottom: 15px; }
    </style>
</head>
<body>

    <h1>لوحة التحكم - إدارة المناقصات</h1>

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

    <!-- ✅ نموذج إضافة مناقصة -->
    <form action="{{ route('tenders.store') }}" method="POST">
        @csrf

        <label>عنوان المناقصة:</label><br>
        <input type="text" name="title" required><br><br>

        <label>الوصف:</label><br>
        <textarea name="description" required></textarea><br><br>

        <label>الميزانية التقديرية:</label><br>
        <input type="number" name="estimated_budget" required><br><br>

        <label>عدد الشروط الفنية المطلوبة:</label><br>
        <input type="number" name="technical_requirements_count" required><br><br>

        <label>الموقع:</label><br>
        <input type="text" name="location" required><br><br>

        <label>مدة التنفيذ (بالأيام):</label><br>
        <input type="number" name="execution_duration_days" required><br><br>

        <label>آخر موعد لتقديم العروض:</label><br>
        <input type="date" name="submission_deadline" required><br><br>

        <button type="submit">➕ إضافة المناقصة</button>
    </form>

    <hr>

    <!-- ✅ عرض قائمة المناقصات -->
    <h2>المناقصات الحالية</h2>

    @forelse($tenders as $tender)
        <div class="box">
            <strong>{{ $tender->title }}</strong><br>
            {{ $tender->description }}<br>
            💰 الميزانية: {{ $tender->estimated_budget }}<br>
            📍 الموقع: {{ $tender->location }}<br>
            📋 الشروط الفنية: {{ $tender->technical_requirements_count }}<br>
            🗓️ المدة: {{ $tender->execution_duration_days }} يوم<br>
            🗓️ آخر موعد للتقديم: {{ $tender->submission_deadline }}<br>
            ⚙️ الحالة: {{ $tender->status }}<br><br>

            <!-- ✅ تعديل -->
            <form action="{{ route('tenders.update', $tender->id) }}" method="POST" style="display:inline;">
                @csrf
                @method('PUT')
                <input type="text" name="title" value="{{ $tender->title }}" required>
                <input type="text" name="description" value="{{ $tender->description }}" required>
                <input type="text" name="location" value="{{ $tender->location }}" required>
                <input type="number" name="execution_duration_days" value="{{ $tender->execution_duration_days }}" required>
                <input type="number" name="estimated_budget" value="{{ $tender->estimated_budget }}" required>
                <input type="number" name="technical_requirements_count" value="{{ $tender->technical_requirements_count }}" required>
                <input type="date" name="submission_deadline" value="{{ $tender->submission_deadline }}" required>
                <button type="submit">💾 حفظ التعديل</button>
            </form>

            <!-- ✅ حذف -->
            <form action="{{ route('tenders.destroy', $tender->id) }}" method="POST" style="display:inline;" onsubmit="return confirm('هل أنت متأكد من حذف المناقصة؟');">
                @csrf
                @method('DELETE')
                <button type="submit">🗑️ حذف</button>
            </form>

            {{-- <!-- ✅ عرض العروض المقدمة -->
            <a href="{{ route('bid', $tender->id) }}">
                <button>📑 عرض العروض المقدمة</button>
            </a> --}}

            {{-- <a href="{{ route('bids.form', $tender->id) }}">
                <button>➕ تقديم عرض</button>
            </a> --}}
            

            <!-- ✅ نموذج تقديم العرض للمناقصة -->
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
            <form action="{{ route('bids.store', $tender->id) }}" method="POST" enctype="multipart/form-data">
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
                    <strong>قيمة العرض:</   strong> {{ $bid->bid_amount }}<br>
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
            <!-- زر تقييم العروض -->
<form action="{{ route('tenders.evaluate', $tender->id) }}" method="GET" onsubmit="return confirm('هل تريد تقييم العروض؟')">
    <button type="submit" class="btn btn-warning mt-3">تقييم العروض</button>
</form> 
        </div>
    @empty
        <p>لا توجد مناقصات حالياً.</p>
    @endforelse

</body>
</html>
