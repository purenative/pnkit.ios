import UIKit

public class Application: UIApplication {
    public let navigator = AppNavigator()
    
    public override class var shared: Application {
        UIApplication.shared as! Application
    }
}
