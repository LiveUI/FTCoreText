FTCoreText (Android)

Overview
- Kotlin port that mirrors the Swift API and markup so the same localized strings can be rendered on both platforms.

Modules
- `android/ftcoretext`: Android library (Kotlin)
- `android/sample`: Demo app showcasing the same examples as iOS

Build
- Requirements: Android Studio Giraffe+ or `./gradlew` with JDK 17.
- From the repo root: open `android/` in Android Studio, or run:
  - `./gradlew :android:ftcoretext:assemble` (library)
  - `./gradlew :android:sample:assembleDebug` (demo)

API Parity
- Class names and methods mirror the Swift API: `FTCoreTextView`, `FTCoreTextStyle`, `FTCoreTextTag`, `FTCoreTextDefaults`.
- Markup identical: `<_link>url|display</_link>`, `<_image>name</_image>` or `base64:...`, `_bullet`, `_paragraph`, `_dropcap`.

Status
- Initial skeleton included; rendering implementation to follow based on `shared/CONTRACT.md`.

## Quick Example

```kotlin
import android.graphics.Typeface
import android.text.Layout
import io.liveui.ftcoretext.FTCoreTextDefaults
import io.liveui.ftcoretext.FTCoreTextStyle
import io.liveui.ftcoretext.FTCoreTextTag
import io.liveui.ftcoretext.FTCoreTextView

val coreTextView = FTCoreTextView(context)

// 1) Start from defaults
coreTextView.removeAllStyles()
val styles = mutableListOf<FTCoreTextStyle>().apply {
    addAll(FTCoreTextDefaults.defaultStyles())
    // 2) Center heading and paragraph in code (no alignment tags in the string)
    add(FTCoreTextStyle(name = FTCoreTextTag.PARAGRAPH, textAlignment = Layout.Alignment.ALIGN_CENTER))
    add(FTCoreTextStyle(name = "_h1", fontSizeSp = 28f, textAlignment = Layout.Alignment.ALIGN_CENTER))
    // Monospace code with iOS-like purple color
    add(FTCoreTextStyle(name = "_code", fontSizeSp = 15f, color = 0xFF9C27B0.toInt(), typeface = Typeface.MONOSPACE))
}
coreTextView.addStyles(styles)

// 3) Render
coreTextView.text = "<_h1>FTCoreText</_h1>\n<_paragraph>This paragraph is centered via styles.</_paragraph>\nInline <_code>val answer = 42</_code>."
```

