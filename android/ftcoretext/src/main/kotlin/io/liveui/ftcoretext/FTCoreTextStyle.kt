package io.liveui.ftcoretext

import android.graphics.Color
import android.graphics.Typeface
import android.text.Layout

data class FTCoreTextStyle(
    val name: String,
    val appendedCharacter: String? = null,
    val typeface: Typeface = Typeface.DEFAULT,
    val fontSizeSp: Float = 16f,
    val color: Int = Color.BLACK,
    val underlined: Boolean = false,
    val textAlignment: Layout.Alignment = Layout.Alignment.ALIGN_NORMAL,
    val paragraphInsetLeft: Int = 0,
    val paragraphInsetTop: Int = 0,
    val paragraphInsetRight: Int = 0,
    val paragraphInsetBottom: Int = 0,
    val leading: Int = 0,
    val maxLineHeight: Int = 0,
    val minLineHeight: Int = 0,
    val bulletCharacter: String? = null,
    val bulletGapWidthPx: Int = 16,
    val bulletColor: Int? = null,
    val applyParagraphStyling: Boolean = true
)

object FTCoreTextDefaults {
    fun defaultStyles(): List<FTCoreTextStyle> = listOf(
        FTCoreTextStyle(name = FTCoreTextTag.DEFAULT),
        FTCoreTextStyle(name = FTCoreTextTag.PARAGRAPH),
        FTCoreTextStyle(name = FTCoreTextTag.LINK, color = 0xFF0000FF.toInt(), underlined = true),
        FTCoreTextStyle(name = FTCoreTextTag.BULLET, bulletCharacter = "\u2022")
    )
}

