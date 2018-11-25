

import UIKit
import CoreLocation
import GoogleMaps


class GooglePlacesManager: NSObject {

    class var sharedManager: GooglePlacesManager {
        struct Singleton {
            static let instance = GooglePlacesManager()
        }
        return Singleton.instance
    }
    
    func autocompleteSearchFor(_ querry: String, sucessHandler: @escaping (([GooglePredictionModel]) -> Void), failureHandler: ((Error?) -> Void)?) {
        let googleAutocompleteRequest = AutocompleteGoogleSearchRequest(owner: ObjectIdentifier(self))
        googleAutocompleteRequest.input = querry
        googleAutocompleteRequest.completion = { request, error in
            guard error == nil else {
                failureHandler?(error)
                return
            }
            
            if let response = request.response as? AutocompleteGoogleSearchRequest.AutocompleteGoogleSearchResponse {
                sucessHandler(response.googlePredModels)
            }
        }
        
        Dispatcher.shared.processRequest(request: googleAutocompleteRequest)
    }
    
    func getPlaceDetailsForPlaceID(_ placeID: String, successHandler:@escaping ((_ addressModel: GoogleAddressModel?) -> Void)) {
        let getPlaceDetailsRequest = GetPlaceDetailsWithIdRequest(owner: ObjectIdentifier(self))
        getPlaceDetailsRequest.placeId = placeID
        getPlaceDetailsRequest.completion = { request, error in
            if let response = request.response as? GetPlaceDetailsWithIdRequest.GetPlaceDetailsWithIdResponse,
                let addressModel = response.addressModel {
                successHandler(addressModel)
            }
        }
        
        Dispatcher.shared.processRequest(request: getPlaceDetailsRequest)
    }
    
    func getGoogleDirectionForRoutePoints(_ points: [GoogleAddressModel], successHandler:@escaping ((_ polyline: GMSPolyline?) -> Void)) {
        
        var loadedPolyline: GMSPolyline?
        let getDirectionsRequest = GetGoogleDirectionForRoutePointsRequest(owner: ObjectIdentifier(self))
        getDirectionsRequest.routePoints = points
        getDirectionsRequest.completion = { request, error in
            if let response = request as? GetGoogleDirectionForRoutePointsRequest.GetGoogleDirectionForRoutePointsResponse,
                let polyline = response.polyline {
                loadedPolyline = polyline
            }
            
            successHandler(loadedPolyline)
        }
        
        Dispatcher.shared.processRequest(request: getDirectionsRequest)
    }
    
    //MARK: Private Methods
    private func coordinateStringFromLocation(_ loc: CLLocation) -> String {
        let coords = loc.coordinate
        return "\(coords.latitude),\(coords.longitude)"
    }
    
    private func waypointsStringFromLocations(_ locations: [CLLocation]) -> String {
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
