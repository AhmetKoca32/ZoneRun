import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

// Release signing: create android/key.properties (see docs/PLAY_STORE_RELEASE_CHECKLIST.md)
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
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
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"]?.toString()
                keyPassword = keystoreProperties["keyPassword"]?.toString()
                storeFile = (keystoreProperties["storeFile"]?.toString())?.let { path -> rootProject.file(path) }
                storePassword = keystoreProperties["storePassword"]?.toString()
            }
        }
    }

    defaultConfig {
        // TODO: Replace with your own Application ID before publishing (e.g. com.yourcompany.zonerun)
        applicationId = "com.example.zone_run"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = env["GOOGLE_MAPS_API_KEY"] ?: ""
    }

    buildTypes {
        release {
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.7.0"))
    
    // Firebase Analytics (optional but recommended)
    implementation("com.google.firebase:firebase-analytics")
    
    // Firebase Auth
    implementation("com.google.firebase:firebase-auth")
    
    // Cloud Firestore
    implementation("com.google.firebase:firebase-firestore")
}
