import UIKit

/// A lightweight Swift rendition of the original Objective‑C ``FTCoreTextView``.
///
/// The view parses a simple markup language using the tags defined by ``FTCoreTextTag``
/// and applies matching ``FTCoreTextStyle`` definitions to the text.
open class FTCoreTextView: UIView {
    /// Raw text containing markup.
    open var text: String? { didSet { processedString = text; updateAttributedString() } }

    /// The text stripped from markup after parsing.
    public private(set) var processedString: String?

    /// Final attributed string ready for drawing.
    public private(set) var attributedString: NSAttributedString?

    /// Registered styles keyed by tag name.
    private var styles: [String: FTCoreTextStyle] = [:]

    /// Convenience access to registered style names.
    open var stylesArray: [FTCoreTextStyle] { Array(styles.values) }

    // MARK: - Initialisation

    /// Creates a new text view with the given frame and default styles.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        applyDefaultStyles()
    }

    /// Creates a new text view from a decoder with default styles applied.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        isOpaque = false
        applyDefaultStyles()
    }

    private func applyDefaultStyles() {
        FTCoreTextDefaults.defaultStyles().forEach { addStyle($0) }
    }

    // MARK: - Style Management

    /// Replaces one of the built-in tag identifiers with a custom tag name.
    open func changeDefaultTag(_ coreTextTag: String, toTag newDefaultTag: String) {
        if let style = styles.removeValue(forKey: coreTextTag) {
            styles[newDefaultTag] = FTCoreTextStyle(name: newDefaultTag,
                                                   appendedCharacter: style.appendedCharacter,
                                                   font: style.font,
                                                   color: style.color,
                                                   underlined: style.underlined,
                                                   textAlignment: style.textAlignment,
                                                   paragraphInset: style.paragraphInset,
                                                   leading: style.leading,
                                                   maxLineHeight: style.maxLineHeight,
                                                   minLineHeight: style.minLineHeight,
                                                   bulletCharacter: style.bulletCharacter,
                                                   bulletFont: style.bulletFont,
                                                   bulletColor: style.bulletColor,
                                                   callback: style.callback,
                                                   applyParagraphStyling: style.applyParagraphStyling)
        }
    }

    /// Registers a single style for a tag.
    open func addStyle(_ style: FTCoreTextStyle) {
        styles[style.name] = style
        updateAttributedString()
    }

    /// Registers multiple styles in one call.
    open func addStyles(_ styles: [FTCoreTextStyle]) {
        styles.forEach { addStyle($0) }
    }

    /// Removes all previously registered styles.
    open func removeAllStyles() {
        styles.removeAll()
        updateAttributedString()
    }

    /// Returns the style associated with the supplied tag name.
    open func style(forName tagName: String) -> FTCoreTextStyle? { styles[tagName] }

    // MARK: - Parsing

    private func updateAttributedString() {
        guard var text = text else {
            attributedString = nil
            setNeedsDisplay()
            return
        }

        let result = NSMutableAttributedString(string: text)
        let fullRange = NSRange(location: 0, length: result.length)

        if let defaultStyle = styles[FTCoreTextTag.default] {
            apply(style: defaultStyle, to: result, range: fullRange)
        }

        // Regex to match <_tag>...</tag>
        let pattern = "<_(\\w+)>(.*?)</\\1>"
        let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])

        while let match = regex?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
            let tagName = (text as NSString).substring(with: match.range(at: 1))
            let content = (text as NSString).substring(with: match.range(at: 2))

            let replacementRange = match.range
            let nsText = text as NSString
            text = nsText.replacingCharacters(in: replacementRange, with: content)
            result.replaceCharacters(in: replacementRange, with: NSAttributedString(string: content))

            if let style = styles["_" + tagName] ?? styles[tagName] {
                let range = NSRange(location: replacementRange.location, length: content.utf16.count)
                apply(style: style, to: result, range: range)
            }
        }

        processedString = text
        attributedString = result
        setNeedsDisplay()
    }

    private func apply(style: FTCoreTextStyle, to attributedString: NSMutableAttributedString, range: NSRange) {
        var attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: style.color,
            .font: style.font
        ]
        if style.underlined {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = style.textAlignment
        paragraphStyle.paragraphSpacing = style.leading
        paragraphStyle.firstLineHeadIndent = style.paragraphInset.left
        paragraphStyle.headIndent = style.paragraphInset.left
        paragraphStyle.tailIndent = -style.paragraphInset.right
        attributes[.paragraphStyle] = paragraphStyle
        attributedString.addAttributes(attributes, range: range)
    }

    // MARK: - Drawing

    /// Draws the attributed string inside the specified rectangle.
    open override func draw(_ rect: CGRect) {
        if let attributedString = attributedString {
            attributedString.draw(in: rect)
        }
    }

    // MARK: - Utilities

    /// Computes the size required to render the current text constrained to a given size.
    open func suggestedSize(constrainedTo size: CGSize) -> CGSize {
        guard let attributedString = attributedString else { return .zero }
        let rect = attributedString.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return rect.integral.size
    }

    /// Returns a copy of the string with all markup tags removed.
    open class func stripTags(for string: String) -> String {
        let regex = try? NSRegularExpression(pattern: "<[^>]+>", options: [])
        let range = NSRange(location: 0, length: string.utf16.count)
        return regex?.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "") ?? string
    }

    /// Splits the text into pages separated by the ``<_page/>`` tag.
    open class func pages(from text: String) -> [String] {
        text.components(separatedBy: "<_page/>")
    }
}

public extension String {
    /// Wraps the receiver into a pair of tags.
    func stringByAppendingTagName(_ tagName: String) -> String {
        "<\(tagName)>\(self)</\(tagName)>"
    }
}
