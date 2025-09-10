import UIKit
import FTCoreText

final class DemoViewController: UIViewController {
    /// Sets up the demo view and renders example markup.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let coreTextView = FTCoreTextView(frame: view.bounds)
        coreTextView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coreTextView.text = "Welcome to <_link>https://example.com|FTCoreText</_link> demo."

        view.addSubview(coreTextView)
    }
}
