buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // ✅ تحديث لإصدار Gradle plugin متوافق مع Gradle 8.10.2 و Java 17
        classpath("com.android.tools.build:gradle:7.4.2")
        classpath("com.google.gms:google-services:4.4.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 🔧 تغيير مكان مجلد build (اختياري جيد إن كنت تحتاجه)
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
