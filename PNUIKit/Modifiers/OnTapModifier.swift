import SwiftUI

public struct OnTapModifier<ButtonStyle: PrimitiveButtonStyle>: ViewModifier {
    private let isEnabled: Bool
    private let buttonStyle: ButtonStyle
    private let onTapped: () -> Void
    
    public init(
        isEnabled: Bool = true,
        buttonStyle: ButtonStyle = .plain,
        onTapped: @escaping () -> Void
    ) {
        self.isEnabled = isEnabled
        self.buttonStyle = buttonStyle
        self.onTapped = onTapped
    }
    
    public func body(content: Content) -> some View {
        Button(action: onTapped) {
            content
        }
        .buttonStyle(buttonStyle)
        .allowsHitTesting(isEnabled)
    }
}

extension View {
    @ViewBuilder
    public func onTapped<ButtonStyle: PrimitiveButtonStyle>(
        isEnabled: Bool = true,
        buttonStyle: ButtonStyle = .plain,
        _ onTapped: @escaping () -> Void
    ) -> some View {
        self.modifier(
            OnTapModifier(
                isEnabled: isEnabled,
                buttonStyle: buttonStyle,
                onTapped: onTapped
            )
        )
    }
}
