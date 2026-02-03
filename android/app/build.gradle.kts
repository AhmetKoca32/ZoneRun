plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

// Load .env file for API keys
val envFile = file("../../.env")
val env = mutableMapOf<String, String>()
if (envFile.exists()) {
    envFile.readLines().forEach { line ->
        val trimmedLine = line.trim()
        if (trimmedLine.isNotBlank() && !trimmedLine.startsWith("#") && trimmedLine.contains("=")) {
            val parts = trimmedLine.split("=", limit = 2)
            if (parts.size == 2) {
                val key = parts[0].trim()
                val value = parts[1].trim()
                if (key.isNotEmpty() && value.isNotEmpty()) {
                    env[key] = value
                }
            }
        }
    }
    val apiKey = env["GOOGLE_MAPS_API_KEY"] ?: ""
    println("✅ Loaded .env file: GOOGLE_MAPS_API_KEY = ${if (apiKey.isNotEmpty()) "***${apiKey.takeLast(4)}" else "NOT FOUND"}")
} else {
    println("⚠️ .env file not found at: ${envFile.absolutePath}")
}

android {
    namespace = "com.example.zone_run"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.zone_run"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Google Maps API Key from .env file
        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = env["GOOGLE_MAPS_API_KEY"] ?: ""
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.7.0"))
    
    // Firebase Analytics (optional but recommended)
    implementation("com.google.firebase:firebase-analytics")
    
    // Firebase Auth
    implementation("com.google.firebase:firebase-auth")
    
    // Cloud Firestore
    implementation("com.google.firebase:firebase-firestore")
}
