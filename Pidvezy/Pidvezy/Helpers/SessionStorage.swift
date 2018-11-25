

import UIKit

class SessionStorage {
    
    fileprivate init() {}
    
    //MARK: Public Methods
    open class var shared: SessionStorage {
        struct Singleton {
            static let sharedInstance = SessionStorage()
        }
        return Singleton.sharedInstance
    }
    
    func save(session: Session) {
        return session.save()
    }
    
    func loadSession() -> Session? {
        
        if let appToken = UserDefaults.standard.value(forKey: Session.Keys.accessTokenKey) as? String,
            let refreshToken = UserDefaults.standard.value(forKey: Session.Keys.refreshTokenKey) as? String {
            
            return Session(accessToken: appToken, refreshToken: refreshToken)
        }
        
        return nil
    }
    
    func removeSession() {
        UserDefaults.standard.removeObject(forKey: Session.Keys.accessTokenKey)
        UserDefaults.standard.removeObject(forKey: Session.Keys.refreshTokenKey)
    }
}
