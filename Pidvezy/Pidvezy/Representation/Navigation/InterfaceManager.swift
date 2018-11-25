
import UIKit

let kFlipAnimationDuration = 0.4

class InterfaceManager {
    
    let window: UIWindow
    
    var mainFlowStoryboard: UIStoryboard {
        get {
            return UIStoryboard(name: kMainFlowStoryboardID, bundle: nil)
        }
    }
    
    var authFlowStoryboard: UIStoryboard {
        get {
            return UIStoryboard(name: kAuthorizationStoryboardID, bundle: nil)
        }
    }
    
    //MARK: Private Methods
    fileprivate init() {
        let lAppDelegate = UIApplication.shared.delegate as! AppDelegate
        window = lAppDelegate.window!
    }
    
    class var sharedManager: InterfaceManager {
        struct Singleton {
            static let instance = InterfaceManager()
        }
        return Singleton.instance;
    }
    
    func loadMainAppFlow(withTransition: Bool, fromView: UIView?) {
        let mainFlowStoryBoard = UIStoryboard(name: kMainFlowStoryboardID, bundle: nil)
        let initialVC = mainFlowStoryBoard.instantiateInitialViewController()
        
        if initialVC != nil {
            if withTransition && fromView != nil {
                UIView.transition(from: fromView!, to: initialVC!.view, duration: kFlipAnimationDuration, options: .transitionFlipFromLeft, completion: { (_) in
                    self.window.rootViewController = initialVC
                })
            } else {
                self.window.rootViewController = initialVC
            }
        }
    }
    
    func redirectUserToLogin() {
        AuthorizationManager.shared.invalidateSession()
        
        let lLoginVC = self.authFlowStoryboard.instantiateInitialViewController()
        self.window.rootViewController = lLoginVC
    }
}
