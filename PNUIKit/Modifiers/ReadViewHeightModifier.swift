import SwiftUI

public struct ReadViewHeightModifier: ViewModifier {
    @Binding
    private var currentViewHeight: CGFloat
    
    public init(currentViewHeight: Binding<CGFloat>) {
        _currentViewHeight = currentViewHeight
    }
    
    public func body(content: Content) -> some View {
        content
            .onGeometryChange(
                for: CGFloat.self,
                of: \.size.height,
                action: { currentViewHeight = $0 }
            )
    }
}

extension View {
    public func writeViewHeight(
        to currentViewHeight: Binding<CGFloat>
    ) -> some View {
        modifier(
            ReadViewHeightModifier(
                currentViewHeight: currentViewHeight
            )
        )
    }
}
