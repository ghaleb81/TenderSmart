plugins {
    id("com.android.application")
    id("kotlin-android")

    // Flutter plugin يجب أن يأتي بعد android/kotlin
    id("dev.flutter.flutter-gradle-plugin")

    // ✅ تفعيل Google Services هنا (بدون apply false)
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.tendersmart"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
    isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.tendersmart"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Firebase BoM لتوحيد الإصدارات
    implementation(platform("com.google.firebase:firebase-bom:33.15.0"))

    // ✅ مكتبات Firebase التي تريد استخدامها:
    implementation("com.google.firebase:firebase-messaging")    // للإشعارات FCM
    implementation("com.google.firebase:firebase-analytics")    // (اختياري) لتحليلات الاستخدام
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")


    // يمكنك إضافة المزيد حسب الحاجة:
    // https://firebase.google.com/docs/android/setup#available-libraries
}
