public protocol ApplicationScreenAuthorizationProvider {
    var isAuthorized: Bool { get }
    
    func onAuthorizedStateChange(_ handler: @escaping (Bool) -> Void)
}
