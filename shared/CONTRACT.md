FTCoreText Cross‑Platform Contract (iOS + Android)

Scope
- Provide identical markup and public API semantics on iOS (Swift) and Android (Kotlin) so localized strings can be reused verbatim across platforms.

Markup Grammar
- Tags: `<_tag> ... </_tag>` and `<tag> ... </tag>` are accepted; closing `</_tag>` is valid for either form.
- Supported tags (names are case‑insensitive during parsing, but emitted styles use exact keys below):
  - `_default`: Base font/color applied to all text.
  - `_paragraph`: Paragraph styling; alignment, insets, line spacing (leading).
  - `_link`: Links. Content supports either `url|display` or a raw URL. Example: `<_link>https://a.com|Open</_link>`.
  - `_bullet`: Bullet paragraphs. The style may define a `bulletCharacter`; default is • (U+2022). A hanging indent is applied.
  - `_image`: Inline image. Content is either an asset name (e.g. `giraffe`) or a Base64 image: `base64:<BASE64>`.
  - `_page`: Page separator; `FTCoreTextView.pages(from:)` splits text on `<_page/>`.
  - `_dropcap` (optional): If a style with this name exists, apply it to the first letter (drop cap) of the rendered text.

Parsing Rules
- Default style is applied to the entire text first; specific tag ranges then override.
- Links: If content contains `|`, split into url (left) and display text (right). Otherwise treat content as both URL and display.
- Bullets: The bullet glyph and a space are prepended to the tag’s content, and paragraph uses a hanging indent.
- Images:
  - First image at the very start of the text floats left with padding; text flows from the top next to the image for its height.
  - Other images are inline.
  - Asset lookup is by name; Base64 images are decoded from `data = base64(content)`.

Rendering Semantics
- Floating image (first image only):
  - Place at top‑left; width = platform default (e.g., 80pt/80dp) unless overridden by style insets or future attributes.
  - Padding between image and text: 12pt/12dp.
  - Text starts at the same top line and wraps to the right for the image’s height.
- Drop cap: If `_dropcap` style exists, apply to the first letter after parsing; otherwise, synthesize a bold font ~2.2× default size.

Public API Parity
- FTCoreTextView
  - `var text: String?`
  - `val/var processedString: String?` (read‑only to consumers)
  - `fun addStyle(style: FTCoreTextStyle)`
  - `fun addStyles(styles: List<FTCoreTextStyle>)`
  - `fun removeAllStyles()`
  - `fun style(forName: String): FTCoreTextStyle?`
  - `fun changeDefaultTag(coreTextTag: String, toTag: String)`
  - `fun suggestedSize(constrainedTo: Size): Size`
- FTCoreTextStyle
  - name, appendedCharacter?, font, color, underlined, textAlignment, paragraphInset, leading, maxLineHeight, minLineHeight,
    bulletCharacter?, bulletFont?, bulletColor?, callback? (platform‑specific), applyParagraphStyling (bool)
- FTCoreTextTag constants: `_default`, `_image`, `_bullet`, `_page`, `_link`, `_paragraph`.
- FTCoreTextDefaults.defaultStyles(): returns the minimal set of core styles (default, paragraph, link, bullet).
- Utilities: `stripTags(for: String) -> String`, `pages(from: String) -> List<String>`.

Platform Notes
- iOS renders NSAttributedString; Android renders Spannable. Exposed API mirrors names; attribute mapping is platform‑specific.
- Fonts: Align defaults (system 16) and accept small visual variance; ensure relative sizes (e.g., drop cap factor) match.
- Links: tap opens via platform default (UIApplication/Intent). Optional callback hook may be added with identical signature.

Testing & Parity
- Use the same sample texts in `shared/Texts` and images in `shared/Images` in both demos.
- Parity tests compare attribute ranges (weight/size/color/underline, margins, links) structurally—not pixel output.

