package io.liveui.ftcoretext.sample

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import io.liveui.ftcoretext.FTCoreTextDefaults
import io.liveui.ftcoretext.FTCoreTextStyle
import io.liveui.ftcoretext.FTCoreTextTag
import io.liveui.ftcoretext.FTCoreTextView

class DetailActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_detail)

        val title = intent.getStringExtra("title") ?: "Example"
        val text = intent.getStringExtra("text") ?: ""
        setTitle(title)

        val view: FTCoreTextView = findViewById(R.id.coreTextView)
        view.removeAllStyles()
        val styles = FTCoreTextDefaults.defaultStyles().toMutableList()
        // Add basic styles
        // Center heading + paragraph only for the "Heading + Paragraph" example
        if (title == "Heading + Paragraph") {
            styles += FTCoreTextStyle(name = FTCoreTextTag.PARAGRAPH, textAlignment = android.text.Layout.Alignment.ALIGN_CENTER)
            styles += FTCoreTextStyle(name = "_h1", fontSizeSp = 28f, textAlignment = android.text.Layout.Alignment.ALIGN_CENTER)
        } else {
            styles += FTCoreTextStyle(name = FTCoreTextTag.PARAGRAPH)
            styles += FTCoreTextStyle(name = "_h1", fontSizeSp = 28f)
        }
        if (text.contains("<_dropcap>", ignoreCase = true)) {
            styles += FTCoreTextStyle(name = "_dropcap", fontSizeSp = 34f)
        }
        // Support custom <p> tag rename
        if (text.contains("<p>", ignoreCase = true)) {
            styles += FTCoreTextStyle(name = "p")
        }
        // Monospace code styling
        if (text.contains("<_code>", ignoreCase = true)) {
            // Match iOS code color (systemPurple approximation) and monospace font
            styles += FTCoreTextStyle(
                name = "_code",
                fontSizeSp = 15f,
                color = 0xFF9C27B0.toInt(), // Purple 500
                typeface = android.graphics.Typeface.MONOSPACE
            )
        }
        view.addStyles(styles)
        view.text = text

        val source = findViewById<TextView>(R.id.source)
        source.text = "Original source:\n$text"

        val sizeView = findViewById<TextView>(R.id.size)
        view.post {
            val w = view.width
            val h = view.layout?.height ?: 0
            sizeView.text = "Suggested size: ${w}x${h}"
        }
    }
}
