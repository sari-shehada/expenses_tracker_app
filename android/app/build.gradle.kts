import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val internalSigningPropertiesFile = rootProject.file("key.properties")
val internalSigningProperties =
    Properties().apply {
        if (internalSigningPropertiesFile.exists()) {
            FileInputStream(internalSigningPropertiesFile).use { inputStream ->
                load(inputStream)
            }
        }
    }

fun internalSigningValue(environmentName: String, propertyName: String): String? =
    System.getenv(environmentName)?.takeIf { it.isNotBlank() }
        ?: internalSigningProperties.getProperty(propertyName)?.takeIf { it.isNotBlank() }

val internalKeystorePath = internalSigningValue("ANDROID_KEYSTORE_PATH", "storeFile")
val internalKeystorePassword =
    internalSigningValue("ANDROID_KEYSTORE_PASSWORD", "storePassword")
val internalKeyAlias = internalSigningValue("ANDROID_KEY_ALIAS", "keyAlias")
val internalKeyPassword = internalSigningValue("ANDROID_KEY_PASSWORD", "keyPassword")
val internalSigningValues =
    listOf(
        internalKeystorePath,
        internalKeystorePassword,
        internalKeyAlias,
        internalKeyPassword,
    )
val hasInternalSigning = internalSigningValues.all { !it.isNullOrBlank() }

if (!hasInternalSigning && internalSigningValues.any { !it.isNullOrBlank() }) {
    throw GradleException(
        "Internal Android signing requires store file, store password, key alias, " +
            "and key password values from the environment or android/key.properties.",
    )
}

android {
    namespace = "com.example.expenses_tracker"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.expenses_tracker"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasInternalSigning) {
            create("internal") {
                storeFile = file(internalKeystorePath!!)
                storePassword = internalKeystorePassword
                keyAlias = internalKeyAlias
                keyPassword = internalKeyPassword
            }
        }
    }

    buildTypes {
        release {
            // CI environment variables take precedence over local key.properties.
            // Release builds retain the existing debug fallback when neither is configured.
            signingConfig =
                signingConfigs.getByName(if (hasInternalSigning) "internal" else "debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
