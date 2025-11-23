import UIKit

extension CGSize {
    func insets(_ insets: UIEdgeInsets) -> CGSize {
        CGSize(
            width: width - insets.left - insets.right,
            height: height - insets.top - insets.bottom
        )
    }
}
