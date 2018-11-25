

import UIKit
import FBSDKLoginKit
import SCLAlertView

class LoginVC: BaseVC {
    
    @IBOutlet var facebookBtn: UIButton!
    @IBOutlet var anonLoginBtn: UIButton!
    
    private var userProvider = UserProvider()

    //MARK: View Controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AuthorizationManager.shared.getAccessToken() != nil {
            InterfaceManager.sharedManager.loadMainAppFlow(withTransition: false, fromView: nil)
        }
    }
    
    //MARK: IBActions
    @IBAction func anonLoginTapped(_ sender: UIButton) {
    }
    
    @IBAction func fbLoginTapped(_ sender: UIButton) {
        AuthorizationManager.shared.loginUserWithFacebookToken { [unowned self] (error) in
            guard error == nil else { return }
            
            self.userProvider.getCurrentUser(completion: { (user, error) in
                guard error == nil, let user = user else {
                    _ = SCLAlertView().showError("", subTitle: error?.localizedDescription ?? "Something went wrong")
                    return
                }
                
                UserProvider.saveUserModel(userModel: user)
                InterfaceManager.sharedManager.loadMainAppFlow(withTransition: true, fromView: self.view)
            })
        }
    }
}
