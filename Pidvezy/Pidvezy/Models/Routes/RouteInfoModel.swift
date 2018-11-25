

import UIKit
import CoreLocation

class RouteInfoModel {
    
    var routeID: String? = nil
    var userName: String? = nil
    var profession: String? = nil
    var facebookID: String? = nil
    var userID: String? = nil
    
    var type: String? = nil
    var departureTime: String? = nil
    
    var routePoints: [GoogleAddressModel] = [GoogleAddressModel]()
    var regularDays: [Int] = []
    var regularity: String? = nil
    var routeDate: String? = nil
    
    init() {}

    init(dictionary: [String: Any]) {
        self.routeID = dictionary["id"] as? String
        self.type = dictionary["type"] as? String
        self.userID = dictionary["user_id"] as? String
        
        if let userDict = dictionary["user"] as? Dictionary<String, Any> {
            if let userName = userDict["name"] as? String {
                self.userName = userName
            }
            
            if let userProf = userDict["description"] as? String {
                self.profession = userProf
            }
            
            self.facebookID = userDict["fb_id"] as? String
        }
        
        if let startAddress = dictionary["addr_s"] as? String,
            let lStartLocationCoords = dictionary["loc_s"] as? [Double] {
            
            if let startAddressModel = GoogleAddressModel(address: startAddress, coordinates: lStartLocationCoords) {
                self.routePoints.append(startAddressModel)
            }
        }
        
        if let lMediumAddresses = dictionary["addr_m"] as? [String],
            let lMediumLocations = dictionary["loc_m"] as? [[Double]] {
            
            for i in 0..<lMediumAddresses.count {
                if let mediumAddressModel = GoogleAddressModel(address: lMediumAddresses[i], coordinates: lMediumLocations[i]) {
                    self.routePoints.append(mediumAddressModel)
                }
            }
        }
        
        if let endAddress = dictionary["addr_e"] as? String,
            let lEndLocationCoords = dictionary["loc_e"] as? [Double] {
            
            if let endAddressModel = GoogleAddressModel(address: endAddress, coordinates: lEndLocationCoords) {
                self.routePoints.append(endAddressModel)
            }
        }
        
        self.regularity = dictionary["regularity"] as? String
        
        if let regDays = dictionary["regular_days"] as? [Int] {
            self.regularDays = regDays
        }
        
        if let depTimeStr = dictionary["time"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let date = dateFormatter.date(from: depTimeStr)
            
            if date != nil {
                dateFormatter.dateFormat = "HH:mm"
                self.departureTime = dateFormatter.string(from: date!)
            }
        }
    }
    
    //MARK: Public Methods
    func toSearchJSON() -> [String: Any]? {
        if let startCoords = self.routePoints.first!.location?.coordinate,
            let endCoords = self.routePoints.last!.location?.coordinate {
            
            var params = ["start": "\(startCoords.latitude),\(startCoords.longitude)" as AnyObject,
                          "finish": "\(endCoords.latitude),\(endCoords.longitude)" as AnyObject,
                          "page": "1" as AnyObject]
            
            if let departureTime = self.departureTime {
                params["time_s"] = departureTime as AnyObject
            }
            
            if let type = self.type {
                params["route_type"] = type as AnyObject
            }
            
            return params
        }
        
        return nil
    }
    
    func toFullRouteInfoJSON() -> [String: Any]? {
        var params = [String: Any]()
        
        if let userFBID = self.facebookID,
            let userID = self.userID {
            params["fb_id"] = userFBID as AnyObject
            params["user_id"] = userID as AnyObject
        }
        
        if let type = self.type {
            params["type"] = type as AnyObject
        }
        
        if let startAddressModel = self.routePoints.first,
            let endAddressModel = self.routePoints.last {
            
            let startLocCoords = startAddressModel.location!.coordinate
            let endLocCoords = endAddressModel.location!.coordinate
            
            params["addr_s"] = startAddressModel.formattedAddress as AnyObject
            params["loc_s"] = [startLocCoords.latitude, startLocCoords.longitude] as AnyObject
            
            params["addr_e"] = endAddressModel.formattedAddress as AnyObject
            params["loc_e"] = [endLocCoords.latitude, endLocCoords.longitude] as AnyObject
            
            if let departureTime = self.departureTime {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                var departureDate = dateFormatter.date(from: departureTime)
                
                let calendar = Calendar.current
                var departureDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: departureDate!)
                
                departureDateComponents.day = 1
                departureDateComponents.month = 1
                departureDateComponents.year = 1970
                
                departureDate = calendar.date(from: departureDateComponents)
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let departureString = dateFormatter.string(from: departureDate!)//.appending("Z")
                
                params["time"] = departureString as AnyObject
            }
        } else {
            return nil
        }
        
        if self.routePoints.count > 2 {
            let mediumAddresses = self.mediumAddressesArray()
            
            params["addr_m"] = mediumAddresses.0 as AnyObject
            params["loc_m"] = mediumAddresses.1 as AnyObject
        }
        
        params["regularity"] = self.regularity as AnyObject
        params["regular_days"] = self.regularDays as AnyObject
        
        if self.routeDate != nil {
            params["route_date"] = self.routeDate! as AnyObject
        }
        
        return params
    }
    
    //MARK: Private Methods
    internal func mediumAddressesArray() -> ([String], [[Double]]) {
        var addresses = [String]()
        var locations = [[Double]]()
        
        for i in 1..<self.routePoints.count - 1 {
            let addressModel = self.routePoints[i]
            let addressCoords = addressModel.location!.coordinate
            
            addresses.append(addressModel.formattedAddress!)
            locations.append([addressCoords.latitude, addressCoords.longitude])
        }
        return (addresses, locations)
    }
}

