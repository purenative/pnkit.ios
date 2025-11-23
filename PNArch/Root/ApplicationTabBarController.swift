import UIKit

open class ApplicationTabBarController<
    Item: ApplicationTabItem,
    NavigationController: UINavigationController
>: UITabBarController {
    private let backgroundColor: UIColor
    private let items: [Item]
    private let authorizationStateProvider: ApplicationScreenAuthorizationProvider?
    
    private var isAuthorizedState: Bool {
        authorizationStateProvider?.isAuthorized ?? false
    }
    
    public init(
        backgroundColor: UIColor,
        items: [Item],
        authorizationStateProvider: ApplicationScreenAuthorizationProvider? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.items = items
        self.authorizationStateProvider = authorizationStateProvider
        
        super.init(nibName: nil, bundle: nil)
        
        authorizationStateProvider?.onAuthorizedStateChange { _ in
            DispatchQueue.main.async { [weak self] in
                self?.resetControllers()
            }
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backgroundColor
        resetControllers()
    }
    
    @MainActor
    private func resetControllers() {
        let controllers = items.enumerated()
            .map { index, item in
                let viewController = item
                    .applicationScreen(forAuthorizedState: isAuthorizedState)
                    .buildController()
                let navigationController = NavigationController(rootViewController: viewController)
                navigationController.tabBarItem = UITabBarItem(
                    title: item.title,
                    image: item.image,
                    tag: index
                )
                return navigationController
            }
        
        setViewControllers(controllers, animated: false)
    }
}
