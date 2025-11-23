import SwiftUI

public struct Loader: View {
    @State
    private var isAnimating: Bool = false
    
    private let radius: CGFloat
    private let borderWidth: CGFloat
    private let foregroundColor: Color
    private let backgroundColor: Color?
    
    public init(
        radius: CGFloat,
        borderWidth: CGFloat,
        foregroundColor: Color,
        backgroundColor: Color? = nil
    ) {
        self.radius = radius
        self.borderWidth = borderWidth
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        ZStack {
            if let backgroundColor {
                Circle()
                    .stroke(
                        backgroundColor,
                        style: StrokeStyle(lineWidth: borderWidth, lineCap: .round)
                    )
                    .frame(width: radius * 2, height: radius * 2)
            }
            
            Circle()
                .trim(from: 0, to: 0.6)
                .stroke(
                    foregroundColor,
                    style: StrokeStyle(lineWidth: borderWidth, lineCap: .round)
                )
                .frame(width: radius * 2, height: radius * 2)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
        }
    }
}
