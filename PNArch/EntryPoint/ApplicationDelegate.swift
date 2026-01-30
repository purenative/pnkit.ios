import UIKit

final class ApplicationDelegate: NSObject, UIApplicationDelegate {
    override init() {
        super.init()
        
        ApplicationServicesConfiguration.configureServices()
    }
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        config.delegateClass = ApplicationSceneDelegate.self
        return config
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        ApplicationServicesConfiguration.delegateProxy?.application?(
            application,
            didFinishLaunchingWithOptions: launchOptions
        ) ?? true
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        ApplicationServicesConfiguration.delegateProxy?.application?(
            application,
            didRegisterForRemoteNotificationsWithDeviceToken: deviceToken
        )
    }
}
