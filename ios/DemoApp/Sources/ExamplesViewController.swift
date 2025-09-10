import UIKit
import FTCoreText

// Simple model describing an example
struct FTCTExample {
    let title: String
    let subtitle: String
    let text: String
    let configure: (FTCoreTextView) -> Void
}

final class ExamplesViewController: UITableViewController {
    private var examples: [FTCTExample] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FTCoreText Examples"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        buildExamples()
    }

    private func buildExamples() {
        examples = [
            FTCTExample(
                title: "Basic + Link",
                subtitle: "Default styles with a tappable link",
                text: "Welcome to <_link>https://github.com/LiveUI/FTCoreText|FTCoreText</_link> demo.",
                configure: { view in
                    // Use default styles; link will be blue + underlined
                    view.removeAllStyles()
                    view.addStyles(FTCoreTextDefaults.defaultStyles())
                }
            ),
            FTCTExample(
                title: "Bulleted List",
                subtitle: "<_bullet> items with hanging indent",
                text: [
                    "<_bullet>First bullet item wraps to next line to demonstrate hanging indent.</_bullet>",
                    "<_bullet>Second bullet item with a link to <_link>https://apple.com|Apple</_link>.</_bullet>",
                    "<_bullet>Third bullet item.</_bullet>"
                ].joined(separator: "\n"),
                configure: { view in
                    view.removeAllStyles()
                    let bullet = FTCoreTextStyle(name: FTCoreTextTag.bullet,
                                                 font: .systemFont(ofSize: 16),
                                                 color: .label,
                                                 textAlignment: .left,
                                                 paragraphInset: UIEdgeInsets(top: 0, left: 20, bottom: 8, right: 0),
                                                 bulletCharacter: "\u{2022}")
                    let def = FTCoreTextStyle(name: FTCoreTextTag.default, font: .systemFont(ofSize: 16), color: .label)
                    let link = FTCoreTextStyle(name: FTCoreTextTag.link, color: .systemBlue, underlined: true)
                    view.addStyles([def, bullet, link])
                }
            ),
            FTCTExample(
                title: "Image Float (giraffe)",
                subtitle: "<_image>giraffe</_image> with drop cap and padding",
                text: "<_image>giraffe</_image>" +
                      "<_paragraph>" +
                      "<_dropcap>T</_dropcap>his text should wrap next to the image with padding. " +
                      Array(repeating: "More content continues to demonstrate wrapping. ", count: 10).joined() +
                      "</_paragraph>",
                configure: { view in
                    view.removeAllStyles()
                    let paragraph = FTCoreTextStyle(name: FTCoreTextTag.paragraph,
                                                    font: .systemFont(ofSize: 16),
                                                    color: .label,
                                                    textAlignment: .natural,
                                                    paragraphInset: .zero,
                                                    leading: 6)
                    let def = FTCoreTextStyle(name: FTCoreTextTag.default, font: .systemFont(ofSize: 16), color: .label)
                    let drop = FTCoreTextStyle(name: "_dropcap",
                                               font: .boldSystemFont(ofSize: 34),
                                               color: .label)
                    view.addStyles([def, paragraph, drop])
                }
            ),
            FTCTExample(
                title: "Heading + Paragraph",
                subtitle: "Centered heading and paragraph (via styles)",
                text: "<_h1>FTCoreText</_h1>\n<_paragraph>This paragraph uses the built-in paragraph tag with centered alignment set in code.</_paragraph>",
                configure: { view in
                    view.removeAllStyles()
                    view.addStyles(FTCoreTextDefaults.defaultStyles())
                    // Center both heading and paragraph via styles (no alignment tags in text)
                    let h1 = FTCoreTextStyle(
                        name: "_h1",
                        font: .boldSystemFont(ofSize: 28),
                        color: .label,
                        underlined: false,
                        textAlignment: .center
                    )
                    let paragraph = FTCoreTextStyle(
                        name: FTCoreTextTag.paragraph,
                        font: .systemFont(ofSize: 16),
                        color: .secondaryLabel,
                        underlined: false,
                        textAlignment: .center,
                        leading: 8
                    )
                    view.addStyles([h1, paragraph])
                }
            ),
            FTCTExample(
                title: "Custom Tag Rename",
                subtitle: "Map default paragraph to <p> tag",
                text: "<p>This uses a custom tag name after renaming default paragraph.</p>",
                configure: { view in
                    view.removeAllStyles()
                    view.addStyles(FTCoreTextDefaults.defaultStyles())
                    // Rename built-in paragraph tag to "p"
                    view.changeDefaultTag(FTCoreTextTag.paragraph, toTag: "p")
                }
            ),
            FTCTExample(
                title: "Monospace Code",
                subtitle: "Custom <_code> tag",
                text: "Inline <_code>let answer = 42</_code> sample.",
                configure: { view in
                    view.removeAllStyles()
                    view.addStyles(FTCoreTextDefaults.defaultStyles())
                    let code = FTCoreTextStyle(
                        name: "_code",
                        font: UIFont.monospacedSystemFont(ofSize: 15, weight: .regular),
                        color: .systemPurple
                    )
                    view.addStyle(code)
                }
            ),
            FTCTExample(
                title: "Suggested Size",
                subtitle: "Long text resized to fit width",
                text: "<_paragraph>" + Array(repeating: "Lorem ipsum dolor sit amet, ", count: 20).joined() + "</_paragraph>",
                configure: { view in
                    view.removeAllStyles()
                    let paragraph = FTCoreTextStyle(
                        name: FTCoreTextTag.paragraph,
                        font: .systemFont(ofSize: 15),
                        color: .label,
                        textAlignment: .left,
                        paragraphInset: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12),
                        leading: 6
                    )
                    let def = FTCoreTextStyle(name: FTCoreTextTag.default, font: .systemFont(ofSize: 15), color: .label)
                    view.addStyles([def, paragraph])
                }
            ),
        ]

        // Append any bundled .txt examples from Resources/Texts
        examples.append(contentsOf: loadResourceTextExamples())
    }

    private func loadResourceTextExamples() -> [FTCTExample] {
        // Some build systems may flatten resource folders; search broadly
        let urls = (
            Bundle.main.urls(forResourcesWithExtension: "txt", subdirectory: "Texts") ?? []
        ) + (
            Bundle.main.urls(forResourcesWithExtension: "txt", subdirectory: nil) ?? []
        )
        // Deduplicate by filename
        let uniqueByName: [String: URL] = urls.reduce(into: [:]) { acc, url in
            acc[url.lastPathComponent] = url
        }
        let ex: [FTCTExample] = uniqueByName.values.compactMap { url in
            let name = url.deletingPathExtension().lastPathComponent
            guard let content = try? String(contentsOf: url) else { return nil }
            return FTCTExample(
                title: "Resource: \(name)",
                subtitle: "From Texts/\(url.lastPathComponent)",
                text: content,
                configure: { view in
                    view.removeAllStyles()
                    view.addStyles(FTCoreTextDefaults.defaultStyles())
                }
            )
        }
        return ex.sorted { $0.title < $1.title }
    }

    // MARK: - Table datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        examples.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let example = examples[indexPath.row]
        var cfg = cell.defaultContentConfiguration()
        cfg.text = example.title
        cfg.secondaryText = example.subtitle
        cell.contentConfiguration = cfg
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let example = examples[indexPath.row]
        let vc = ExampleDetailViewController(example: example)
        navigationController?.pushViewController(vc, animated: true)
    }
}
