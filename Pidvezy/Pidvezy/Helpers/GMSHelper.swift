

import UIKit
import CoreLocation
import GoogleMaps

class GMSHelper: NSObject {
    
    class func mapBoundsForCoordinates(_ coords: [GoogleAddressModel]) -> GMSCoordinateBounds {
        var bounds: GMSCoordinateBounds = GMSCoordinateBounds()
        
        for addressModel in coords {
            bounds = bounds.includingCoordinate(addressModel.location!.coordinate)
        }
        
        return bounds
    }
    
    class func coordinateStringFromLocation(_ loc: CLLocation) -> String {
        let coords = loc.coordinate
        return "\(coords.latitude),\(coords.longitude)"
    }
    
    class func waypointsStringFromLocations(_ locations: [CLLocation]) -> String {
        var waypointStr: String = String()
        for loc in locations {
            if loc != locations.last {
                let str = self.coordinateStringFromLocation(loc) + "|"
                waypointStr.append(str)
            } else {
                waypointStr.append(self.coordinateStringFromLocation(loc))
            }
        }
        
        return waypointStr
    }
}
