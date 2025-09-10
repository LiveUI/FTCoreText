import UIKit
import FTCoreText

final class ExampleDetailViewController: UIViewController {
    private let example: FTCTExample

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let ftView = FTCoreTextView(frame: .zero)
    private let processedLabel = UILabel()
    private let sizeLabel = UILabel()

    init(example: FTCTExample) {
        self.example = example
        super.init(nibName: nil, bundle: nil)
        title = example.title
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        renderExample()
    }

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        ftView.translatesAutoresizingMaskIntoConstraints = false
        processedLabel.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false

        processedLabel.numberOfLines = 0
        sizeLabel.numberOfLines = 0
        processedLabel.textColor = .secondaryLabel
        sizeLabel.textColor = .secondaryLabel
        // Use a small, consistent font for meta labels
        let smallFont = UIFont.preferredFont(forTextStyle: .footnote)
        processedLabel.font = smallFont
        sizeLabel.font = smallFont
        processedLabel.adjustsFontForContentSizeCategory = true
        sizeLabel.adjustsFontForContentSizeCategory = true

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(ftView)
        contentView.addSubview(processedLabel)
        contentView.addSubview(sizeLabel)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            ftView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ftView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ftView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),

            processedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            processedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            processedLabel.topAnchor.constraint(equalTo: ftView.bottomAnchor, constant: 16),

            sizeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sizeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            sizeLabel.topAnchor.constraint(equalTo: processedLabel.bottomAnchor, constant: 8),
            sizeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    private func renderExample() {
        // Configure styles for this example
        example.configure(ftView)
        ftView.text = example.text

        // Calculate suggested height for the current width
        view.layoutIfNeeded()
        let width = view.bounds.width - 32
        let size = ftView.suggestedSize(constrainedTo: CGSize(width: width, height: .greatestFiniteMagnitude))
        ftView.heightAnchor.constraint(equalToConstant: max(80, size.height)).isActive = true

        // Show original source text (with markup) using a small font
        processedLabel.text = "Original source:\n\(example.text)"
        sizeLabel.text = String(format: "Suggested size: %.0fx%.0f", size.width, size.height)
    }
}
