plugins {
    id("com.android.application") version "8.7.2"
    id("org.jetbrains.kotlin.android") version "2.0.20"
}

android {
    namespace = "io.liveui.ftcoretext.sample"
    compileSdk = 34

    defaultConfig {
        applicationId = "io.liveui.ftcoretext.sample"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }

    sourceSets {
        getByName("main") {
            // Mount shared assets under a single root so relative paths include subfolders (avoids duplicate READMEs)
            assets.srcDirs(
                "src/main/assets",
                "../../shared",
                // Include iOS Texts directly so Base64Example.txt is present
                "../../ios/DemoApp/Resources/Texts",
                // Include iOS giraffe imageset directly so giraffe.png is packaged
                "../../ios/DemoApp/Resources/Assets.xcassets/giraffe.imageset",
                "$buildDir/generated/assets"
            )
            // Also include our own generated res so we can expose giraffe as @drawable/giraffe
            // Use a custom folder to avoid colliding with AGP's own generated outputs
            res.srcDirs(
                "src/main/res",
                "$buildDir/ftct_generated/res"
            )
        }
    }
}

dependencies {
    implementation(project(":ftcoretext"))
    implementation("androidx.core:core-ktx:1.13.1")
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("com.google.android.material:material:1.12.0")
    implementation("androidx.recyclerview:recyclerview:1.3.2")
}

// Copy helpful iOS demo images (like giraffe) into generated assets if present
tasks.register<Copy>("prepareSharedAssets") {
    // Copy iOS giraffe image into assets/Images
    val iosGiraffeDir = project.rootProject.projectDir.resolve("ios/DemoApp/Resources/Assets.xcassets/giraffe.imageset")
    val imagesOut = layout.buildDirectory.dir("generated/assets/Images")
    if (iosGiraffeDir.exists()) {
        from(iosGiraffeDir) {
            include("giraffe.png", "giraffe@2x.png", "giraffe@3x.png")
            rename { "giraffe.png" } // normalize to a single expected filename
        }
        into(imagesOut.get().asFile)
    }
}

// Generate a drawable resource from the iOS giraffe.png so it can be resolved as @drawable/giraffe
tasks.register<Copy>("prepareSharedRes") {
    val iosGiraffePng = rootProject.projectDir.resolve("ios/DemoApp/Resources/Assets.xcassets/giraffe.imageset/giraffe.png")
    val outDir = layout.buildDirectory.dir("ftct_generated/res/drawable")
    onlyIf { iosGiraffePng.exists() }
    from(iosGiraffePng)
    rename { "giraffe.png" }
    into(outDir.get().asFile)
}

tasks.named("preBuild").configure {
    dependsOn("prepareSharedRes")
}

tasks.named("preBuild").configure {
    dependsOn("prepareSharedAssets")
}
