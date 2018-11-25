

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
//        let getCurrentUserRequest = GetCurrentUserInfoRequest(owner: ObjectIdentifier(self))
//        getCurrentUserRequest.completion = { request, error in
//            if let response = request.response as? GetCurrentUserInfoRequest.GetCurrentUserInfoResponse,
//                let user = response.user {
//                completion?(user, nil)
//                return
//            }
//
//            completion?(nil, error)
//        }
//
//        Dispatcher.shared.processRequest(request: getCurrentUserRequest)
        let userJson = ["id": "55dd6be9ece39a6cf774d6df",
            "name": "Volodymyr Spodaryk",
            "fb_id": "911580392233202",
            "email": "volodymyr.spodaryk@gmail.com",
            "phone": "+380501234567",
            "locale": "uk_UA",
            "description": "CTO в Підвезу!",
            "gender": "male",
            "registered_on": "2015-08-26T04:34:01",
            "location": "Київ, місто Київ, Україна",
            "city_addr": "Київ, місто Київ, Україна",
            "city_coords": [50.4501, 30.5234],
            "home_addr": "вул.Мельникова 42, Київ, місто Київ, Україна",
            "home_coords": [50.12345, 30.12345],
            "work_addr": "вул. Хрещатик 1, Київ, місто Київ, Україна",
            "work_coords": [50.98765, 30.98765],
            "routes": [
            "5729cbb69e74fd32dc1489d6",
            "5830b278984c37000aa779e9",
            "583d75027156f0000be2e40e"]
        ] as [String : Any]
        
        DispatchQueue.main.async {
            let parsedUser = DataModel.shared.parseUser(data: userJson)
            completion?(parsedUser, nil)
        }
    }
}
