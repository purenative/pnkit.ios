import SwiftUI

public struct ShimmeringModifier: ViewModifier {
    @State
    private var opacity: CGFloat = 0
    
    private let contentColor: Color
    private let highlightColor: Color
    
    public init(
        contentColor: Color,
        highlightColor: Color
    ) {
        self.contentColor = contentColor
        self.highlightColor = highlightColor
    }
    
    public func body(content: Content) -> some View {
        content
            .foregroundColor(contentColor)
            .overlay(
                highlightColor.opacity(opacity)
                    .onAppear(perform: {
                        withAnimation(.easeInOut(duration: 0.75).repeatForever(autoreverses: true)) {
                            opacity = 0.4
                        }
                    })
            )
    }
}

extension View {
    public func shimmering(
        contentColor: Color,
        highlightColor: Color
    ) -> some View {
        modifier(
            ShimmeringModifier(
                contentColor: contentColor,
                highlightColor: highlightColor
            )
        )
    }
}
