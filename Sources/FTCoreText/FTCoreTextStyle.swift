import UIKit

/// Default tag names recognised by ``FTCoreTextView``.
public enum FTCoreTextTag {
    public static let `default` = "_default"
    public static let image = "_image"
    public static let bullet = "_bullet"
    public static let page = "_page"
    public static let link = "_link"
    public static let paragraph = "_paragraph"
}

/// Represents a single style that can be applied to a tag in the source text.
public struct FTCoreTextStyle {
    public var name: String
    public var appendedCharacter: String?
    public var font: UIFont
    public var color: UIColor
    public var underlined: Bool
    public var textAlignment: NSTextAlignment
    public var paragraphInset: UIEdgeInsets
    public var leading: CGFloat
    public var maxLineHeight: CGFloat
    public var minLineHeight: CGFloat

    // Bullet specific values
    public var bulletCharacter: String?
    public var bulletFont: UIFont?
    public var bulletColor: UIColor?

    /// Callback invoked when the style is parsed.
    public var callback: (([String: Any]) -> Void)?

    /// If set to `false`, the paragraph styling of the enclosing style is used.
    public var applyParagraphStyling: Bool

    /// Creates a new style instance with the provided attributes.
    public init(name: String,
                appendedCharacter: String? = nil,
                font: UIFont = .systemFont(ofSize: UIFont.systemFontSize),
                color: UIColor = .black,
                underlined: Bool = false,
                textAlignment: NSTextAlignment = .natural,
                paragraphInset: UIEdgeInsets = .zero,
                leading: CGFloat = 0,
                maxLineHeight: CGFloat = 0,
                minLineHeight: CGFloat = 0,
                bulletCharacter: String? = nil,
                bulletFont: UIFont? = nil,
                bulletColor: UIColor? = nil,
                callback: (([String: Any]) -> Void)? = nil,
                applyParagraphStyling: Bool = true) {
        self.name = name
        self.appendedCharacter = appendedCharacter
        self.font = font
        self.color = color
        self.underlined = underlined
        self.textAlignment = textAlignment
        self.paragraphInset = paragraphInset
        self.leading = leading
        self.maxLineHeight = maxLineHeight
        self.minLineHeight = minLineHeight
        self.bulletCharacter = bulletCharacter
        self.bulletFont = bulletFont
        self.bulletColor = bulletColor
        self.callback = callback
        self.applyParagraphStyling = applyParagraphStyling
    }
}

public enum FTCoreTextDefaults {
    /// Returns a set of core styles that mimic the behaviour of the original Objective‑C implementation.
    public static func defaultStyles() -> [FTCoreTextStyle] {
        let defaultStyle = FTCoreTextStyle(name: FTCoreTextTag.default)
        let paragraphStyle = FTCoreTextStyle(name: FTCoreTextTag.paragraph)
        let linkStyle = FTCoreTextStyle(name: FTCoreTextTag.link, color: .blue, underlined: true)
        let bulletStyle = FTCoreTextStyle(name: FTCoreTextTag.bullet, bulletCharacter: "\u{2022}")
        return [defaultStyle, paragraphStyle, linkStyle, bulletStyle]
    }
}
