package io.liveui.ftcoretext

import android.content.Context
import android.graphics.BitmapFactory
import android.graphics.Paint
import android.graphics.Typeface
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.text.*
import android.text.method.LinkMovementMethod
import android.text.style.AbsoluteSizeSpan
import android.text.style.AlignmentSpan
import android.text.style.BulletSpan
import android.text.style.DrawableMarginSpan
import android.text.style.ForegroundColorSpan
import android.text.style.ImageSpan
import android.text.style.LeadingMarginSpan
import android.text.style.StyleSpan
import android.text.style.URLSpan
import android.text.style.TypefaceSpan
import android.text.style.UnderlineSpan
import android.util.AttributeSet
import androidx.appcompat.widget.AppCompatTextView
import kotlin.math.ceil
import kotlin.math.max

class FTCoreTextView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : AppCompatTextView(context, attrs, defStyleAttr) {

    var processedString: String? = null
        private set

    private val styles: MutableMap<String, FTCoreTextStyle> = mutableMapOf()
    private var isReady: Boolean = false

    private var floatDrawable: Drawable? = null
    private var floatPaddingPx: Int = dpToPx(12)
    private var floatWidthPx: Int = dpToPx(80)
    private var floatHeightPx: Int = 0
    private var floatLines: Int = 0

    fun addStyle(style: FTCoreTextStyle) {
        styles[style.name] = style
        updateSpannable()
    }

    fun addStyles(list: List<FTCoreTextStyle>) {
        list.forEach { addStyle(it) }
    }

    fun removeAllStyles() {
        styles.clear()
        updateSpannable()
    }

    fun style(forName: String): FTCoreTextStyle? = styles[forName]

    fun changeDefaultTag(coreTextTag: String, toTag: String) {
        styles[coreTextTag]?.let { s ->
            styles.remove(coreTextTag)
            styles[toTag] = s.copy(name = toTag)
            updateSpannable()
        }
    }

    override fun setText(text: CharSequence?, type: BufferType?) {
        super.setText(text, type)
        if (isReady) updateSpannable()
    }

    init {
        // Mark ready after base constructor completes; now safe to parse and apply spans
        isReady = true
        updateSpannable()
    }

    private fun updateSpannable() {
        val raw = text?.toString() ?: run {
            processedString = null
            return
        }

        // reset float
        floatDrawable = null
        floatHeightPx = 0
        floatLines = 0

        var working = raw
        val sb = SpannableStringBuilder(raw)

        // Apply default style upfront
        styles[FTCoreTextTag.DEFAULT]?.let { applyStyleSpans(sb, 0, sb.length, it) }

        val regex = Regex("<_?(\\w+)>(.*?)</_?\\1>", RegexOption.DOT_MATCHES_ALL)
        while (true) {
            val match = regex.find(working) ?: break
            val tag = match.groupValues[1]
            val content = match.groupValues[2]
            val startInWorking = match.range.first
            val endInWorking = match.range.last + 1

            var replacementText: CharSequence = content
            var styleName = tag
            var spanToApply: ((SpannableStringBuilder, Int, Int) -> Unit)? = null

            if (tag.equals("link", ignoreCase = true)) {
                val parts = content.split("|", limit = 2)
                val url = if (parts.size == 2) parts[0] else content
                val label = if (parts.size == 2) parts[1] else content
                replacementText = label
                spanToApply = { dest, s, e ->
                    dest.setSpan(URLSpan(url), s, e, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
                    movementMethod = LinkMovementMethod.getInstance()
                }
            } else if (tag.equals("image", ignoreCase = true)) {
                val (drawable, w, h) = resolveDrawable(content)
                if (drawable != null) {
                    // If image is the first element, float it
                    val isLeading = startInWorking == 0
                    if (isLeading) {
                        floatDrawable = drawable.apply { setBounds(0, 0, w, h) }
                        floatWidthPx = w
                        floatHeightPx = h
                        replacementText = "" // remove tag from text
                        spanToApply = { dest, s, e ->
                            // add drawable margin span at start
                            dest.setSpan(DrawableMarginSpan(floatDrawable!!, floatPaddingPx), 0, 1.coerceAtMost(dest.length), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
                            // approximate lines now; refine after layout
                            val approxLineHeight = paint.fontMetricsInt.let { it.descent - it.ascent }
                            floatLines = ceil(max(1f, (floatHeightPx.toFloat() / approxLineHeight))).toInt()
                            dest.setSpan(FloatedLeadingMarginSpan2(floatLines, floatWidthPx + floatPaddingPx, 0), 0, dest.length, Spanned.SPAN_INCLUSIVE_EXCLUSIVE)
                        }
                    } else {
                        val imageSpan = ImageSpan(drawable.apply { setBounds(0, 0, w, h) }, ImageSpan.ALIGN_BASELINE)
                        replacementText = "\uFFFC"
                        spanToApply = { dest, s, e -> dest.setSpan(imageSpan, s, e, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE) }
                    }
                } else {
                    replacementText = ""
                }
            } else if (tag.equals("bullet", ignoreCase = true)) {
                // Use BulletSpan and LeadingMarginSpan over the entire paragraph range.
                val textContent = if (content.endsWith("\n")) content else content + "\n"
                replacementText = textContent
                spanToApply = { dest, s, e ->
                    val paraStart = findParagraphStart(dest, s)
                    val paraEnd = findParagraphEnd(dest, e)
                    val style = styles[FTCoreTextTag.BULLET]
                    val color = style?.bulletColor ?: currentTextColor
                    val gap = style?.bulletGapWidthPx ?: dpToPx(12)
                    val indent = gap * 2
                    dest.setSpan(BulletSpan(gap, color), paraStart, paraEnd, Spanned.SPAN_PARAGRAPH)
                    dest.setSpan(LeadingMarginSpan.Standard(indent, indent), paraStart, paraEnd, Spanned.SPAN_PARAGRAPH)
                }
            }

            // Replace in both working string and spannable builder
            val replaceStart = startInWorking
            val replaceEnd = endInWorking
            working = working.substring(0, replaceStart) + replacementText + working.substring(replaceEnd)

            // Map to current sb indices (same positions as working)
            sb.replace(replaceStart, replaceEnd, replacementText)
            val applyStart = replaceStart
            val applyEnd = replaceStart + replacementText.length

            // Apply tag style if present
            styles[tag]?.let { applyStyleSpans(sb, applyStart, applyEnd, it) }
            styles["_$tag"]?.let { applyStyleSpans(sb, applyStart, applyEnd, it) }

            // Apply special spans (link, image, bullet)
            spanToApply?.invoke(sb, applyStart, applyEnd)
        }

        processedString = working

        // Drop cap: only applied when tag exists; no auto-application here

        super.setText(sb, BufferType.SPANNABLE)

        // Refine floating line count after layout
        post { adjustFloatingLines() }
    }

    private fun adjustFloatingLines() {
        val text = text
        if (text !is Spannable || floatDrawable == null) return
        val lm = layout ?: return
        val lineHeight = lm.getLineBottom(0) - lm.getLineTop(0)
        if (lineHeight <= 0) return
        val newLines = ceil(max(1f, (floatHeightPx.toFloat() / lineHeight))).toInt()
        if (newLines != floatLines) {
            floatLines = newLines
            // remove existing LeadingMarginSpan2 and reapply
            val spans = text.getSpans(0, text.length, LeadingMarginSpan.LeadingMarginSpan2::class.java)
            spans.forEach { span -> text.removeSpan(span) }
            text.setSpan(FloatedLeadingMarginSpan2(floatLines, floatWidthPx + floatPaddingPx, 0), 0, text.length, Spanned.SPAN_INCLUSIVE_EXCLUSIVE)
            invalidate()
        }
    }

    private fun applyDropCap(sb: SpannableStringBuilder, style: FTCoreTextStyle) {
        val idx = sb.indexOfFirst { it.isLetter() }
        if (idx < 0) return
        val end = (idx + 1).coerceAtMost(sb.length)
        sb.setSpan(StyleSpan(Typeface.BOLD), idx, end, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
        val sizeSp = if (style.fontSizeSp > 0f) style.fontSizeSp else 34f
        sb.setSpan(AbsoluteSizeSpan(sizeSp.toInt(), true), idx, end, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
        sb.setSpan(ForegroundColorSpan(style.color), idx, end, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
    }

    private fun applyStyleSpans(sb: SpannableStringBuilder, start: Int, end: Int, style: FTCoreTextStyle) {
        if (start >= end) return
        sb.setSpan(ForegroundColorSpan(style.color), start, end, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
        sb.setSpan(AbsoluteSizeSpan(style.fontSizeSp.toInt().coerceAtLeast(1), true), start, end, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
        if (style.typeface != Typeface.DEFAULT) {
            // Apply monospace or other family if specified
            val family = if (style.typeface == Typeface.MONOSPACE) "monospace" else null
            family?.let { sb.setSpan(TypefaceSpan(it), start, end, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE) }
        }
        if (style.underlined) sb.setSpan(UnderlineSpan(), start, end, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
        when (style.textAlignment) {
            Layout.Alignment.ALIGN_CENTER -> sb.setSpan(AlignmentSpan.Standard(Layout.Alignment.ALIGN_CENTER), start, end, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
            Layout.Alignment.ALIGN_OPPOSITE -> sb.setSpan(AlignmentSpan.Standard(Layout.Alignment.ALIGN_OPPOSITE), start, end, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
            else -> {}
        }
        val left = style.paragraphInsetLeft
        val rest = left
        if (left != 0) sb.setSpan(LeadingMarginSpan.Standard(left, rest), start, end, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
    }

    private fun resolveDrawable(content: String): Triple<Drawable?, Int, Int> {
        // base64
        if (content.startsWith("base64:")) {
            val dataStr = content.removePrefix("base64:")
            return try {
                val bytes = android.util.Base64.decode(dataStr, android.util.Base64.DEFAULT)
                val bmp = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
                val (w, h) = scaleToWidth(bmp.width, bmp.height, floatWidthPx)
                Triple(BitmapDrawable(resources, bmp), w, h)
            } catch (_: Throwable) { Triple(null, 0, 0) }
        }
        // drawable resource by name
        val id = resources.getIdentifier(content, "drawable", context.packageName)
        if (id != 0) {
            val d = resources.getDrawable(id, context.theme)
            val (w, h) = scaleToWidth(d.intrinsicWidth, d.intrinsicHeight, floatWidthPx)
            return Triple(d, w, h)
        }
        // assets fallback: try name, name.png, name.jpg
        val tryNames = listOf(
            content,
            "$content.png",
            "$content.jpg",
            "Images/$content",
            "Images/$content.png",
            "Images/$content.jpg",
            // iOS xcassets imageset path if mounted directly
            "giraffe.imageset/$content.png"
        )
        for (name in tryNames) {
            try {
                context.assets.open(name).use { stream ->
                    val bmp = BitmapFactory.decodeStream(stream)
                    val (w, h) = scaleToWidth(bmp.width, bmp.height, floatWidthPx)
                    return Triple(BitmapDrawable(resources, bmp), w, h)
                }
            } catch (_: Throwable) {
                // ignore and continue
            }
        }
        return Triple(null, 0, 0)
    }

    private fun scaleToWidth(w: Int, h: Int, targetW: Int): Pair<Int, Int> {
        if (w <= 0 || h <= 0) return targetW to targetW
        val scale = targetW.toFloat() / w
        val nh = (h * scale).toInt().coerceAtLeast(1)
        return targetW to nh
    }

    private fun dpToPx(dp: Int): Int = (dp * resources.displayMetrics.density).toInt()

    private fun findParagraphStart(text: CharSequence, index: Int): Int {
        var i = index
        while (i > 0 && text[i - 1] != '\n') i--
        return i
    }

    private fun findParagraphEnd(text: CharSequence, index: Int): Int {
        var i = index
        val len = text.length
        while (i < len && text[i] != '\n') i++
        if (i < len && text[i] == '\n') i++ // include the newline in the paragraph span
        return i
    }

    companion object Utils {
        fun stripTags(input: String): String = input.replace(Regex("<[^>]+>"), "")
        fun pages(from: String): List<String> = from.split("<_page/>")
    }
}

/**
 * Custom span implementing LeadingMarginSpan2 to indent only the first [lines]
 * lines by [first] pixels and the rest by [rest] pixels.
 */
private class FloatedLeadingMarginSpan2(
    private val lines: Int,
    private val firstMargin: Int,
    private val restMargin: Int
) : LeadingMarginSpan.LeadingMarginSpan2 {
    override fun getLeadingMargin(first: Boolean): Int = if (first) firstMargin else restMargin
    override fun getLeadingMarginLineCount(): Int = lines
    override fun drawLeadingMargin(
        c: android.graphics.Canvas?,
        p: Paint?,
        x: Int,
        dir: Int,
        top: Int,
        baseline: Int,
        bottom: Int,
        text: CharSequence?,
        start: Int,
        end: Int,
        first: Boolean,
        layout: Layout?
    ) {
        // No-op; margin only
    }
}
