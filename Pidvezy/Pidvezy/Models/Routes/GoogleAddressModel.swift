

import UIKit
import CoreLocation


enum GoogleAddressModelType {
    case homeAddress()
    case workAddress()
}

public class GoogleAddressModel: NSObject {
    
    var formattedAddress: String? = nil
    var location: CLLocation? = nil
    
    override init() {
        self.formattedAddress = nil
        self.location = nil
    }
    
    init?(address: String?, coordinates: [Double]?) {
        if let formattedAddr = address,
            let lat = coordinates?[0],
            let lng = coordinates?[1] {
            
            self.location = CLLocation(latitude: lat, longitude: lng)
            self.formattedAddress = formattedAddr
        } else {
            return nil
        }
    }
    
    init?(dictionary: [String: Any]) {
        self.formattedAddress = dictionary["formatted_address"] as! String?
        
        let lGeomDict = dictionary["geometry"] as? [String: AnyObject]
        let lLocDict = lGeomDict?["location"] as? [String: AnyObject]
        
        if let lLat = lLocDict?["lat"] as? Double,
            let lLng = lLocDict?["lng"] as? Double {
            let loc = CLLocation(latitude: lLat, longitude: lLng)
            self.location = loc
        } else {
            return nil
        }
    }
    
    func toAPIJSON() -> [Double] {
        let coordinates: [Double] = [(self.location?.coordinate.latitude)!, (self.location?.coordinate.longitude)!]
        return coordinates
    }
    
    static func == (lhs: GoogleAddressModel, rhs: GoogleAddressModel) -> Bool {
        return
            lhs.formattedAddress == rhs.formattedAddress &&
                lhs.location == rhs.location
    }
}
