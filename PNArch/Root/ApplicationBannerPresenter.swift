import UIKit

public final class ApplicationBannerPresenter: NSObject, UIGestureRecognizerDelegate {
    private let contentPadding: UIEdgeInsets
    
    private var window: UIWindow? {
        UIApplication.shared.keyWindow
    }
    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var interactionStarted = false
    
    private var bannerFrame: CGRect = .zero
    private weak var presentedBannerView: UIView?
    private var onBannerDismissed: (() -> Void)? = nil
    private var bannerPresentationAnimator: UIViewPropertyAnimator?
    private var bannerDismissalAnimator: UIViewPropertyAnimator?
    
    private var hiddenBannerFrame: CGRect {
        guard let window else { return .zero }
        var bannerFrame = self.bannerFrame
        let maxBannerFrameY = bannerFrame.minY - bannerFrame.height - contentPadding.top * 2 - window.safeAreaInsets.top
        bannerFrame.origin.y = maxBannerFrameY
        return bannerFrame
    }
    
    public init(
        contentPadding: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    ) {
        self.contentPadding = contentPadding
        
        super.init()
        
        panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePanGesture)
        )
        panGestureRecognizer.delegate = self
    }
    
    public func presentBannerView(
        _ bannerView: UIView,
        onBannerDismissed: @escaping () -> Void
    ) {
        guard let window else { return }
        
        if panGestureRecognizer.view == nil {
            window.addGestureRecognizer(panGestureRecognizer)
        }
        
        if let presentedBannerView {
            presentedBannerView.removeFromSuperview()
        }
                
        self.onBannerDismissed = onBannerDismissed
        
        presentedBannerView = bannerView
        let maxBannerSize = window.frame.size.insets(contentPadding)
        let requiredBannerSize = bannerView.sizeThatFits(maxBannerSize)
        let finalBannerFrame = CGRect(
            x: contentPadding.left, y: contentPadding.top + window.safeAreaInsets.top,
            width: requiredBannerSize.width, height: requiredBannerSize.height
        )
        var initialBannerFrame = finalBannerFrame
        initialBannerFrame.origin.y -= (requiredBannerSize.height + contentPadding.top * 2 + window.safeAreaInsets.top)
        bannerView.frame = initialBannerFrame
        window.addSubview(bannerView)
        
        bannerPresentationAnimator?.stopAnimation(true)
        bannerPresentationAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .linear, animations: { [weak bannerView] in
            bannerView?.frame = finalBannerFrame
        })
        bannerPresentationAnimator?.startAnimation()
        
        bannerFrame = finalBannerFrame
    }
    
    public func dismissCurrentBannerView() {
        let onBannerDismissed = self.onBannerDismissed
        self.onBannerDismissed = nil
        
        moveBannerTo(
            hiddenBannerFrame,
            onComplete: {
                $0.removeFromSuperview()
                onBannerDismissed?()
            }
        )
    }
    
    @objc
    private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let window, let presentedBannerView else { return }
        
        if let bannerDismissalAnimator {
            bannerDismissalAnimator.stopAnimation(true)
            self.bannerDismissalAnimator = nil
        }
        
        let translationY = recognizer.translation(in: nil).y
        
        switch recognizer.state {
        case .began:
            interactionStarted = bannerFrame.contains(recognizer.location(in: nil))
            
        case .changed:
            guard interactionStarted else { return }
            let maxBannerFrameY = bannerFrame.minY - bannerFrame.height - contentPadding.top * 2 - window.safeAreaInsets.top
            let newBannerOriginY = min(bannerFrame.origin.y, max(bannerFrame.origin.y + translationY, maxBannerFrameY))
            presentedBannerView.frame.origin.y = newBannerOriginY
            
        default:
            guard interactionStarted else { return }
            interactionStarted = false
            
            var bannerFrame = self.bannerFrame
            let isClosing = -translationY >= bannerFrame.height / 2
            
            if isClosing {
                dismissCurrentBannerView()
            } else {
                moveBannerTo(bannerFrame)
            }
        }
    }
    
    private func moveBannerTo(
        _ targetFrame: CGRect,
        onComplete: ((UIView) -> Void)? = nil
    ) {
        guard let presentedBannerView else { return }
        
        bannerDismissalAnimator = UIViewPropertyAnimator(
            duration: 0.3,
            curve: .linear,
            animations: {
                presentedBannerView.frame = targetFrame
            }
        )
        if let onComplete {
            bannerDismissalAnimator?.addCompletion({ _ in
                onComplete(presentedBannerView)
            })
        }
        bannerDismissalAnimator?.startAnimation()
    }
    
    // MARK: - UIGestureRecognizerDelegate
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}
