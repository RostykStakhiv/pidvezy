

import UIKit

struct Session {
    var accessToken: String
    var refreshToken: String?
    
    struct Keys {
        static let accessTokenKey = "access_token"
        static let refreshTokenKey = "refresh_token"
    }
    
    init(accessToken aToken: String, refreshToken rToken: String?) {
        self.accessToken = aToken
        self.refreshToken = rToken
    }
    
    init?(JSON json: [String: Any]?) {
        if(json == nil) {
            return nil
        }
        
        if let lAccessToken = json![Keys.accessTokenKey] {
            self.accessToken = lAccessToken as! String
            self.refreshToken = json![Keys.refreshTokenKey] as! String?
        } else {
            return nil
        }
    }
    
    func save() {
        UserDefaults.standard.set(accessToken, forKey: Keys.accessTokenKey)
        UserDefaults.standard.set(refreshToken, forKey: Keys.refreshTokenKey)
    }
}

extension Session {
    func dictFromModel() -> [String: String?] {
        return [Keys.accessTokenKey: accessToken,
                Keys.refreshTokenKey: refreshToken]
    }
}
