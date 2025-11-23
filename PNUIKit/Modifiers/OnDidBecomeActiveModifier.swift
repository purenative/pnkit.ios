import SwiftUI

public struct OnDidBecomeActiveModifier: ViewModifier {
    @State
    private var isAppeared: Bool = false
    @State
    private var initialSkipped = false
    
    let skipIfNotAppeared: Bool
    let initial: Bool
    let perform: () -> Void
    
    public init(
        skipIfNotAppeared: Bool,
        initial: Bool,
        perform: @escaping () -> Void
    ) {
        self.skipIfNotAppeared = skipIfNotAppeared
        self.initial = initial
        self.perform = perform
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear(perform: {
                isAppeared = true
            })
            .onDisappear(perform: {
                isAppeared = false
            })
            .onReceive(
                NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification),
                perform: { _ in
                    if isAppeared || !skipIfNotAppeared {
                        if !initial && !initialSkipped {
                            initialSkipped = true
                        } else {
                            perform()
                        }
                    }
                }
            )
    }
}

extension View {
    public func onDidBecomeActive(
        skipIfNotAppeared: Bool = true,
        initial: Bool = false,
        _ perform: @escaping () -> Void
    ) -> some View {
        modifier(
            OnDidBecomeActiveModifier(
                skipIfNotAppeared: skipIfNotAppeared,
                initial: initial,
                perform: perform
            )
        )
    }
}
