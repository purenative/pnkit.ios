import SwiftUI

public struct ShimmeringModifier: ViewModifier {
    @State
    private var currentColor: Color
    
    private let fromColor: Color
    private let toColor: Color
    private let durationMilliseconds: Int
    
    public init(
        fromColor: Color,
        toColor: Color,
        durationMilliseconds: Int = 750
    ) {
        self.fromColor = fromColor
        self.toColor = toColor
        self.durationMilliseconds = durationMilliseconds
        
        currentColor = fromColor
    }
    
    public func body(content: Content) -> some View {
        content
            .foregroundColor(currentColor)
            .onAppear(perform: {
                withAnimation(.easeInOut(duration: TimeInterval(durationMilliseconds) / 1000).repeatForever(autoreverses: true)) {
                    currentColor = toColor
                }
            })
    }
}

extension View {
    public func shimmering(
        fromColor: Color,
        toColor: Color
    ) -> some View {
        modifier(
            ShimmeringModifier(
                fromColor: fromColor,
                toColor: toColor
            )
        )
    }
}
