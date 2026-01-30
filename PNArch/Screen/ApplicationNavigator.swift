import UIKit

@MainActor
public final class AppNavigator {
    let applicationViewController = ApplicationViewController()
    var navigationControllerType: UINavigationController.Type = UINavigationController.self
    
    public func setNavigationControllerType(_ navigationControllerType: UINavigationController.Type) {
        self.navigationControllerType = navigationControllerType
    }
    
    public func setRoot(viewController: UIViewController) {
        let newRootController = switch viewController {
        case let navigationController as UINavigationController: navigationController
        case let tabBarController as UITabBarController: tabBarController
        default: navigationControllerType.init(rootViewController: viewController)
        }
        applicationViewController.updateRootViewController(newRootController)
    }
    
    public func setRoot(screen: ApplicationScreen) {
        setRoot(viewController: screen.buildController())
    }
    
    public func changeTab(tabIndex: Int) {
        applicationViewController.getRootTabBarController()?.selectedIndex = tabIndex
    }
    
    public func push(viewController: UIViewController) {
        guard let navigationController = applicationViewController.getCurrentPresentedNavigationController() else { return }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func push(screen: ApplicationScreen) {
        push(viewController: screen.buildController())
    }
    
    public func popCurrentScreen() {
        guard let navigationController = applicationViewController.getCurrentPresentedNavigationController() else { return }
        navigationController.popViewController(animated: true)
    }
    
    public func present(viewController: UIViewController) {
        guard let navigationController = applicationViewController.getCurrentPresentedNavigationController() else { return }
        let targetPresentationController = navigationController.presentedViewController ?? navigationController
        targetPresentationController.present(viewController, animated: true, completion: nil)
    }
    
    public func present(screen: ApplicationScreen) {
        present(viewController: screen.buildController())
    }
}
