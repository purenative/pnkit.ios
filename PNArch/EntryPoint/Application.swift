import UIKit

public class Application: UIApplication {
    public let navigator = ApplicationNavigator()
    
    public override class var shared: Application {
        UIApplication.shared as! Application
    }
}
