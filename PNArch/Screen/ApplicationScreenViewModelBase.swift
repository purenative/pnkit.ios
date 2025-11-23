import Foundation

@MainActor
open class ApplicationScreenViewModelBase<
    ROUTE: ApplicationScreenRoute,
    STATE: ApplicationScreenState,
    ACTION_INTERCEPTOR: ApplicationScreenActionInterceptor
>: ObservableObject {
    @Published
    public var state: STATE
    
    public let interceptor: ACTION_INTERCEPTOR
    
    open var screenTitle: String? { nil }
    
    public init(
        initialState: STATE,
        interceptor: ACTION_INTERCEPTOR
    ) {
        self.state = initialState
        self.interceptor = interceptor
        
        interceptor.onCreate()
    }
    
    public func onAppear() {
        interceptor.onAppear()
    }
    
    public func onDisappear() {
        interceptor.onDisappear()
    }
}
