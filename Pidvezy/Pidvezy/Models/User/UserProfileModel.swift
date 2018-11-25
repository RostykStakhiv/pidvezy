

import UIKit

class UserProfileModel {

    var name: String?
    var email: String?
    var phoneNumber: String?
    var fbID: String?
    var userID: String?
    
    var homeAddress: GoogleAddressModel?
    var workAddress: GoogleAddressModel?
    
    init(){}
    
    init(dict: [String: AnyObject]) {
        self.name = dict["name"] as! String?
        self.fbID = dict["fb_id"] as! String?
        self.userID = dict["id"] as! String?
        self.email = dict["email"] as! String?
        self.phoneNumber = dict["phone"] as! String?
        
        self.homeAddress = GoogleAddressModel(address: dict["home_addr"] as? String, coordinates: dict["home_coords"] as? [Double])
        self.workAddress = GoogleAddressModel(address: dict["work_addr"] as? String, coordinates: dict["work_coords"] as? [Double])
    }
    
    func toJSON() -> [String: AnyObject] {
        var json = [String: AnyObject]()
        
        if let mail = self.email {
            json["email"] = mail as AnyObject
        }
        
        if let phone = self.phoneNumber {
            json["phone"] = phone as AnyObject
        }
        
        if let homeAddr = self.homeAddress {
            json["home_coords"] = homeAddress?.toAPIJSON() as AnyObject
            if homeAddr.formattedAddress != nil {
                json["home_addr"] = homeAddr.formattedAddress as AnyObject
            }
        }
        
        if let workAddr = self.workAddress {
            json["work_coords"] = workAddr.toAPIJSON() as AnyObject
            if workAddr.formattedAddress != nil {
                json["work_addr"] = workAddr.formattedAddress as AnyObject
            }
        }
        
        return json
    }
}
