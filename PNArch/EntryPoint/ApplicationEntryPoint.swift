import UIKit

@MainActor
open class ApplicationEntryPoint {
    public static func startApplication(
        _ delegateProxy: UIApplicationDelegate? = nil,
        _ servicesConfiguration: @escaping () -> Void
    ) {
        ApplicationServicesConfiguration.delegateProxy = delegateProxy
        ApplicationServicesConfiguration.bindServiceConfigurations(servicesConfiguration)
        
        UIApplicationMain(
            CommandLine.argc,
            CommandLine.unsafeArgv,
            NSStringFromClass(Application.self),
            NSStringFromClass(ApplicationDelegate.self)
        )
    }
}
