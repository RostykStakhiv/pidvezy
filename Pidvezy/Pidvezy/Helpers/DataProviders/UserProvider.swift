

import UIKit

class UserProvider {
    
    class func saveUserModel(userModel: User) {
        guard let uId = userModel.userId, let uFbId = userModel.userFbId else { return }
        
        let defaults = UserDefaults.standard
        defaults.set(uFbId, forKey: "fb_id")
        defaults.set(uId, forKey: "id")
    }
    
    class var currentUserFBID: String? {
        get {
            return UserDefaults.standard.value(forKey: "fb_id") as! String?
        }
    }
    
    class var currentUserID: String? {
        get {
            return UserDefaults.standard.value(forKey: "id") as! String?
        }
    }
    
    //MARK: Public Instance Methods
    func getCurrentUser(completion: ((_ user: User?, _ error: Error?) -> Void)?) {
        let getCurrentUserRequest = GetCurrentUserInfoRequest(owner: ObjectIdentifier(self))
        getCurrentUserRequest.completion = { request, error in
            if let response = request.response as? GetCurrentUserInfoRequest.GetCurrentUserInfoResponse,
                let user = response.user {
                completion?(user, nil)
                return
            }
            
            completion?(nil, error)
        }
        
        Dispatcher.shared.processRequest(request: getCurrentUserRequest)
    }
}
