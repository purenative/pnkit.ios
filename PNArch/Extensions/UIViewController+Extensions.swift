import UIKit

extension UIViewController {
    func addChildController(_ controller: UIViewController) {
        addChild(controller)
        controller.view.frame = view.frame
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    func removeFromParentController() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func layoutFillingParentController() {
        guard let parent else { return }
        view.frame = parent.view.bounds
    }
}
