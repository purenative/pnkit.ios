import UIKit

extension UIApplication {
    var windowScene: UIWindowScene? {
        connectedScenes.first { $0 is UIWindowScene } as? UIWindowScene
    }
    var keyWindow: UIWindow? {
        windowScene?.keyWindow
    }
}
