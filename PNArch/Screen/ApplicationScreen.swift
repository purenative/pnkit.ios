import UIKit

public protocol ApplicationScreen {
    @MainActor
    func buildController() -> UIViewController
}
