

import UIKit
import FBSDKLoginKit

class AuthorizationManager {
    
    //MARK: Lifecycle
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveUnauthorizedError), name: NSNotification.Name(rawValue: "didReceiveUnauthorizedError"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private let loginManager = FBSDKLoginManager()
    
    private var session: Session? = SessionStorage.shared.loadSession() {
        didSet {
            guard self.session != nil else {
                self.loginManager.logOut()
                SessionStorage.shared.removeSession()
                return
            }
        }
    }
    
    open class var shared: AuthorizationManager {
        struct Singleton {
            static let sharedInstance = AuthorizationManager()
        }
        return Singleton.sharedInstance
    }
    
    //MARK: Authorization
    private func getFacebookTokenWithCompletion(_ completion: @escaping (_ fbToken: String?, _ error: Error?) -> Void) {
        let permissoins = ["public_profile", "email"]
        
        loginManager.logIn(withReadPermissions: permissoins, from: nil) { (result, error) in
            if (error == nil) {
                if let fbloginresult = result {
                    if(fbloginresult.isCancelled == false) {
                        let userToken = fbloginresult.token.tokenString!
                        completion(userToken, nil)
                    }
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    func loginUserWithFacebookToken(completion: @escaping (_ error: Error?) -> Void) {
        getFacebookTokenWithCompletion { (fbToken, error) in
            guard let token = fbToken else {
                completion(error)
                return
            }
            
            let loginRequest = LoginWithFacebookRequest(owner: ObjectIdentifier(self))
            loginRequest.fbToken = token
            loginRequest.completion = { request, error in
                
            }
        }
    }
    
    func logoutUser(completion: @escaping (_ error: Error?) -> Void) {
        if let token = self.session?.accessToken {
            let logoutRequest = LogoutRequest(owner: ObjectIdentifier(self))
            logoutRequest.accessToken = token
            logoutRequest.completion = { request, error in
                completion(error)
            }
            
            Dispatcher.shared.processRequest(request: logoutRequest)
        }
    }
    
    func invalidateSession() {
        self.session = nil
    }
    
    func getAccessToken() -> String? {
        return session?.accessToken
    }
    
    //MARK: Private Methods
    @objc private func refreshToken() {
        
    }
    
    @objc private func didReceiveUnauthorizedError() {
        
    }
}
