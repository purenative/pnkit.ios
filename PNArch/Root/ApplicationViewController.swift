import UIKit

internal final class ApplicationViewController: UIViewController {
    private var currentRootViewController: UIViewController?
    
    deinit {
        currentRootViewController?.removeFromParentController()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        currentRootViewController?.layoutFillingParentController()
    }
    
    func updateRootViewController(_ newRootViewController: UIViewController?) {
        currentRootViewController?.removeFromParentController()
        
        guard let newRootViewController else { return }
        addChildController(newRootViewController)
        currentRootViewController = newRootViewController
    }
    
    func getRootTabBarController() -> UITabBarController? {
        currentRootViewController as? UITabBarController
    }
    
    func getCurrentPresentedNavigationController() -> UINavigationController? {
        var lastPresentedNavigationController = nextPresentedNavigationController(startsFrom: currentRootViewController) ?? currentRootViewController as? UINavigationController
        
        if let nextPresentedNavigationController = nextPresentedNavigationController(startsFrom: lastPresentedNavigationController) {
            lastPresentedNavigationController = nextPresentedNavigationController
        }
        
        return lastPresentedNavigationController
    }
    
    private func nextPresentedNavigationController(
        startsFrom viewController: UIViewController?
    ) -> UINavigationController? {
        switch viewController {
        case let tabBarController as UITabBarController: tabBarController.selectedViewController as? UINavigationController
        case let navigationController as UINavigationController: navigationController.presentedViewController as? UINavigationController
        default: viewController?.navigationController
        }
    }
}
