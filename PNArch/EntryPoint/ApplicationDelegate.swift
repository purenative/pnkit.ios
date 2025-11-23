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
}
