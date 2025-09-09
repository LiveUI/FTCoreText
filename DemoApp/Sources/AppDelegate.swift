import UIKit
import FTCoreText

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    /// Configures the main window and root view controller when the app launches.
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = DemoViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
