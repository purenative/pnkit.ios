import UIKit

@MainActor
open class ApplicationEntryPoint {
    public static func startApplication(_ servicesConfiguration: @escaping () -> Void) {
        ApplicationServicesConfiguration.bindServiceConfigurations(servicesConfiguration)
        
        UIApplicationMain(
            CommandLine.argc,
            CommandLine.unsafeArgv,
            NSStringFromClass(Application.self),
            NSStringFromClass(ApplicationDelegate.self)
        )
    }
}
