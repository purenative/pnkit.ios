import UIKit

@MainActor
final class ApplicationServicesConfiguration {
    private static var servicesConfiguration: (() -> Void)?
    static var delegateProxy: UIApplicationDelegate?
    
    static func bindServiceConfigurations(_ servicesConfiguration: @escaping () -> Void) {
        self.servicesConfiguration = servicesConfiguration
    }
    
    static func configureServices() {
        self.servicesConfiguration?()
        self.servicesConfiguration = nil
    }
    
    public static func setDelegateProxy(_ delegateProxy: UIApplicationDelegate) {
        self.delegateProxy = delegateProxy
    }
}
