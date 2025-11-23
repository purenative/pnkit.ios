@MainActor
final class ApplicationServicesConfiguration {
    private static var servicesConfiguration: (() -> Void)?
    
    static func bindServiceConfigurations(_ servicesConfiguration: @escaping () -> Void) {
        self.servicesConfiguration = servicesConfiguration
    }
    
    static func configureServices() {
        self.servicesConfiguration?()
        self.servicesConfiguration = nil
    }
}
