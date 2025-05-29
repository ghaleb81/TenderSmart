import sys
import json
import joblib

# تحميل النماذج المدربة
lr_model = joblib.load('C:/Users/Lenovo/Desktop/course laravel/TenderLaravel/ai/models/linear_regression_model.pkl')
svm_model = joblib.load('C:/Users/Lenovo/Desktop/course laravel/TenderLaravel/ai/models/svm_model.pkl')
scaler = joblib.load('C:/Users/Lenovo/Desktop/course laravel/TenderLaravel/ai/models/scaler.pkl')


# قراءة البيانات القادمة من Laravel
input_json = sys.stdin.read()
bids_data = json.loads(input_json)

results = []

for bid in bids_data:
    # استخراج المتغيرات من البيانات
    bid_amount = bid['bid_amount']
    budget = bid['estimated_budget']
    completion_time = bid['completion_time']
    required_duration = bid['execution_duration_days']
    quality_certificate_count = bid['quality_certificates']
    years_of_experience = bid['projects_last_5_years']
    technical_matched_count = bid['technical_matched_count']
    technical_requirment_count = bid['technical_requirements_count']
    
    # حساب الخصائص
    budget_adherence = min((bid_amount / budget) * 10, 10)

    if completion_time <= required_duration:
        speed_score = 10
    else:
        delay = completion_time - required_duration
        max_delay = 364
        normalized_delay = delay / max_delay
        speed_score = max(0, 10 * (1 - normalized_delay))

    quality_score = min(10, 5 + (quality_certificate_count * 1) + (2 if years_of_experience > 5 else 0))
    technical_score = (technical_matched_count / technical_requirment_count) * 10

    features = [[bid_amount, completion_time, technical_score, budget_adherence, quality_score, speed_score]]
    scaled_features = scaler.transform(features)

    # التنبؤ بالدرجات
    #lr_pred = lr_model.predict([[bid_amount, completion_time, technical_score, budget_adherence, quality_score, speed_score]])
    #svm_pred = svm_model.predict([[bid_amount, completion_time, technical_score, budget_adherence, quality_score, speed_score]])
    svm_pred = svm_model.predict(scaled_features)
    lr_pred = lr_model.predict(scaled_features)

    # تخزين النتائج
    results.append({
        "contractor_id": bid['contractor_id'],
        "predicted_score": svm_pred[0],  # يمكن استخدام أي نموذج تفضله (lr_pred أو svm_pred)
    })

# إرسال النتائج مرة أخرى إلى Laravel بتنسيق JSON
print(json.dumps(results))
