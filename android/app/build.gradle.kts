plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Function to read properties from file
fun readProperty(propertyName: String): String {
    return try {
        val propsFile = rootProject.file("appkey.properties")
        if (propsFile.exists()) {
            val contents = propsFile.readText()
            val keyLine = contents.lines().find { it.startsWith("$propertyName=") }
            keyLine?.substringAfter("$propertyName=") ?: ""
        } else {
            ""
        }
    } catch (e: Exception) {
        logger.warn("Failed to read property $propertyName: ${e.message}")
        ""
    }
}

// Read various properties
val googleMapKey = readProperty("googleMapKey")


android {
    namespace = "com.example.moniepoint"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.moniepoint"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        manifestPlaceholders["googleMapKey"] = googleMapKey
        manifestPlaceholders["applicationName"] = "io.flutter.app.FlutterApplication"
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
