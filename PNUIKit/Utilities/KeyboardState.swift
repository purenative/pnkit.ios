import Combine
import SwiftUI

public final class KeyboardState: ObservableObject {
    private let notificationNames = [
        UIResponder.keyboardWillShowNotification,
        UIResponder.keyboardWillHideNotification
    ]
    
    @Published
    public var height: CGFloat = 0
    
    public private(set) var animationDuration = TimeInterval.zero
    public private(set) var animationOptions = UIView.AnimationOptions(rawValue: 0)
    
    public var animation: Animation {
        switch animationOptions {
        case .curveEaseInOut: .easeInOut(duration: animationDuration)
        case .curveEaseIn: .easeIn(duration: animationDuration)
        case .curveEaseOut: .easeOut(duration: animationDuration)
        default: .linear(duration: animationDuration)
        }
    }
    
    public var isOpened: Bool {
        height > .zero
    }
    
    public init() {
        for notificationName in notificationNames {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleNotification),
                name: notificationName,
                object: nil
            )
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func handleNotification(_ notification: NSNotification) {
        switch notification.name {
        case UIResponder.keyboardWillShowNotification: guard !isOpened else { return }
        case UIResponder.keyboardWillHideNotification: guard isOpened else { return }
        default: return
        }
        
        let animationCurveRawValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0
        animationOptions = UIView.AnimationOptions(rawValue: UInt(animationCurveRawValue << 16))
        animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? .zero
        
        height = notification.name == UIResponder.keyboardWillHideNotification ? .zero : (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? .zero
    }
}
