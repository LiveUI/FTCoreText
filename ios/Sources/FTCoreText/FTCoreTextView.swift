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

    // TextKit components for layout/hit-testing (e.g., links)
    private let layoutManager = NSLayoutManager()
    private let textContainer = NSTextContainer(size: .zero)
    private var textStorage: NSTextStorage?
    // Floating image support (leading image that text wraps around)
    private var floatingImage: UIImage?
    private var floatingImageBounds: CGRect = .zero
    private let floatingImagePadding: CGFloat = 12

    // MARK: - Initialisation

    /// Creates a new text view with the given frame and default styles.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        applyDefaultStyles()
        setupTextKit()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }

    /// Creates a new text view from a decoder with default styles applied.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        isOpaque = false
        applyDefaultStyles()
        setupTextKit()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }

    private func setupTextKit() {
        textContainer.lineFragmentPadding = 0
        layoutManager.addTextContainer(textContainer)
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
        // Reset floating image state for fresh layout
        floatingImage = nil
        floatingImageBounds = .zero

        let result = NSMutableAttributedString(string: text)
        let fullRange = NSRange(location: 0, length: result.length)

        if let defaultStyle = styles[FTCoreTextTag.default] {
            apply(style: defaultStyle, to: result, range: fullRange)
        }

        // Regex to match <_tag>...</tag> or <tag>...</tag> and allow underscore in closing tag too
        let pattern = "<_?(\\w+)>(.*?)</_?\\1>"
        let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])

        while let match = regex?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
            let tagName = (text as NSString).substring(with: match.range(at: 1))
            let content = (text as NSString).substring(with: match.range(at: 2))

            let replacementRange = match.range
            let nsText = text as NSString

            var replacementAttr = NSAttributedString(string: "")
            var replacementPlain = ""
            var linkURL: URL?

            if tagName.lowercased() == "image" {
                // Support base64 inline images and asset-named images
                var image: UIImage?
                if content.hasPrefix("base64:") {
                    let base64 = String(content.dropFirst("base64:".count))
                    if let data = Data(base64Encoded: base64, options: [.ignoreUnknownCharacters]) {
                        image = UIImage(data: data)
                    }
                } else {
                    image = UIImage(named: content)
                }
                if let image {
                    let targetWidth: CGFloat = 80
                    let scale = targetWidth / max(image.size.width, 1)
                    let height = image.size.height * scale
                    if replacementRange.location == 0 {
                        // Float the leading image: remove from text and draw separately
                        floatingImage = image
                        floatingImageBounds = CGRect(x: 0, y: 0, width: targetWidth, height: height)
                        replacementAttr = NSAttributedString(string: "")
                        replacementPlain = ""
                    } else {
                        let attachment = NSTextAttachment()
                        attachment.image = image
                        attachment.bounds = CGRect(x: 0, y: 0, width: targetWidth, height: height)
                        replacementAttr = NSAttributedString(attachment: attachment)
                        replacementPlain = "\u{FFFC}"
                    }
                } else {
                    replacementAttr = NSAttributedString(string: "")
                    replacementPlain = ""
                }
            } else {
                var textContent = content
                if tagName.lowercased() == "link" {
                    let parts = content.split(separator: "|", maxSplits: 1, omittingEmptySubsequences: false)
                    if parts.count == 2 {
                        linkURL = URL(string: String(parts[0]))
                        textContent = String(parts[1])
                    } else {
                        linkURL = URL(string: content)
                    }
                }
                if let style = styles["_" + tagName] ?? styles[tagName], style.bulletCharacter != nil || tagName.lowercased() == "bullet" {
                    let bullet = styles["_" + tagName]?.bulletCharacter ?? styles[tagName]?.bulletCharacter ?? "\u{2022}"
                    textContent = "\(bullet) \(textContent)"
                }
                replacementAttr = NSAttributedString(string: textContent)
                replacementPlain = textContent
            }

            text = nsText.replacingCharacters(in: replacementRange, with: replacementPlain)
            result.replaceCharacters(in: replacementRange, with: replacementAttr)

            if let style = styles["_" + tagName] ?? styles[tagName] {
                let range = NSRange(location: replacementRange.location, length: replacementAttr.length)
                apply(style: style, to: result, range: range)
                if let url = linkURL {
                    result.addAttribute(.link, value: url, range: range)
                }
            }
        }

        processedString = text
        attributedString = result
        // Update TextKit storage for layout, drawing and hit-testing
        if let existing = textStorage { existing.removeLayoutManager(layoutManager) }
        let storage = NSTextStorage(attributedString: result)
        storage.addLayoutManager(layoutManager)
        textStorage = storage
        textContainer.size = bounds.size
        updateExclusionPathForFloatingImage()
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
        // Basic hanging indent support for bullets
        if style.bulletCharacter != nil {
            paragraphStyle.firstLineHeadIndent = style.paragraphInset.left
            paragraphStyle.headIndent = style.paragraphInset.left + 16
        } else {
            paragraphStyle.firstLineHeadIndent = style.paragraphInset.left
            paragraphStyle.headIndent = style.paragraphInset.left
        }
        paragraphStyle.tailIndent = -style.paragraphInset.right
        attributes[.paragraphStyle] = paragraphStyle
        attributedString.addAttributes(attributes, range: range)
    }

    // MARK: - Drawing

    /// Draws the attributed string using TextKit so exclusion paths are respected, and draws any floating image.
    open override func draw(_ rect: CGRect) {
        guard textStorage != nil else { return }
        if let image = floatingImage, floatingImageBounds.size != .zero {
            image.draw(in: floatingImageBounds)
        }
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: .zero)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
        updateExclusionPathForFloatingImage()
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

// MARK: - Interaction
private extension FTCoreTextView {
    /// Applies a drop cap style to the first letter of the text if a "_dropcap" style exists,
    /// or synthesizes one from the current font (2.2x, bold).
    func applyAutoDropCapIfNeeded(to result: NSMutableAttributedString, processedText: String) {
        // Require some text
        guard !processedText.isEmpty else { return }
        // Find first letter in the string
        let scalars = processedText.unicodeScalars
        let letters = CharacterSet.letters
        var scalarIndex = scalars.startIndex
        var offset = 0
        while scalarIndex < scalars.endIndex {
            let scalar = scalars[scalarIndex]
            if letters.contains(scalar) { break }
            offset += scalar.utf16.count
            scalarIndex = scalars.index(after: scalarIndex)
        }
        guard offset < result.length else { return }

        let range = NSRange(location: offset, length: 1)
        // Prefer a user-provided _dropcap style
        if let drop = styles["_dropcap"] {
            var attrs: [NSAttributedString.Key: Any] = [
                .font: drop.font,
                .foregroundColor: drop.color
            ]
            if drop.underlined { attrs[.underlineStyle] = NSUnderlineStyle.single.rawValue }
            result.addAttributes(attrs, range: range)
        } else {
            // Synthesize from current font
            let currentFont = (result.attribute(.font, at: offset, effectiveRange: nil) as? UIFont) ?? UIFont.systemFont(ofSize: 16)
            let dropFont = UIFont.boldSystemFont(ofSize: currentFont.pointSize * 2.2)
            result.addAttributes([.font: dropFont], range: range)
        }
    }

    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .ended, let attributedString = attributedString else { return }
        let location = recognizer.location(in: self)
        let glyphIndex = layoutManager.glyphIndex(for: location, in: textContainer)
        let charIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
        if charIndex < attributedString.length, let value = attributedString.attribute(.link, at: charIndex, effectiveRange: nil) as? URL {
            UIApplication.shared.open(value)
        }
    }

    /// If a floating image is present, set an exclusion path to make text flow to its right with padding.
    func updateExclusionPathForFloatingImage() {
        if let _ = floatingImage, floatingImageBounds.size != .zero {
            let rect = CGRect(x: 0, y: 0, width: floatingImageBounds.width + floatingImagePadding, height: floatingImageBounds.height)
            textContainer.exclusionPaths = [UIBezierPath(rect: rect)]
        } else {
            textContainer.exclusionPaths = []
        }
    }
}
