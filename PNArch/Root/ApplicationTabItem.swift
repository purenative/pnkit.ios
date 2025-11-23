import class UIKit.UIImage

public protocol ApplicationTabItem {
    var title: String { get }
    var image: UIImage? { get }
    
    func applicationScreen(forAuthorizedState: Bool) -> ApplicationScreen
}
