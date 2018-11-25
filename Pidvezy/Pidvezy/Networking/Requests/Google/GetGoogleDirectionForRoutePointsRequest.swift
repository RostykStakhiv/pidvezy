//
//  GetGoogleDirectionForRoutePointsRequest.swift
//
//  Created by  Rostyslav_Stakhiv on 2018-09-23.
//

import Foundation
import CoreLocation
import GoogleMaps

class GetGoogleDirectionForRoutePointsRequest: Request {
    
    class GetGoogleDirectionForRoutePointsResponse: Response {
        
        var polyline: GMSPolyline?
        
        override func parseResponse(response: URLResponse?, data: Data?) throws {
            try super.parseResponse(response: response, data: data)
            
            if let jsonDictionary = json as? Dictionary<String, Any>,
                let routes = jsonDictionary["routes"] as? [Dictionary<String, Any>] {
                
                for route in routes {
                    let routeOverviewPolyline = route["overview_polyline"] as? Dictionary<String, Any>
                    let points = routeOverviewPolyline?["points"] as? String
                    if points != nil {
                        let path = GMSPath.init(fromEncodedPath: points!)
                        polyline = GMSPolyline.init(path: path)
                    }
                }
            }
        }
    }
    
    var routePoints: [GoogleAddressModel]?
    
    private lazy var actualResponse = GetGoogleDirectionForRoutePointsResponse()
    override private(set) var response: Response {
        get {
            return actualResponse
        }
        set {
            if newValue is GetGoogleDirectionForRoutePointsResponse {
                actualResponse = newValue as! GetGoogleDirectionForRoutePointsResponse
            } else {
                print("incorrect type of response")
            }
        }
    }
    
    override func serviceURLRequest() -> URLRequest {
        var request = super.serviceURLRequest()
        
        guard let routePoints = routePoints else {
            return request
        }
        
        let originCoordsString = GMSHelper.coordinateStringFromLocation(routePoints.first!.location!)
        let destCoordsString = GMSHelper.coordinateStringFromLocation(routePoints.last!.location!)
        
        var waypoints: [CLLocation] = [CLLocation]()
        
        for addressModel in routePoints {
            if addressModel != routePoints.first && addressModel != routePoints.last {
                waypoints.append(addressModel.location!)
            }
        }
        
        let waypointsStr = GMSHelper.waypointsStringFromLocations(waypoints)
        
        let params = ["key": GoogleSDKConstants.kGoogleAPIKey,
                      "origin": originCoordsString,
                      "destination": destCoordsString,
                      "waypoints": waypointsStr]
        
        guard let requestURL = URLEncoder.buildEncodedURL(withUrlString: BaseURLs.GoogleDirectionsBaseURL, params: params) else {
            return request
        }
        
        request.httpMethod = "GET"
        request.url = requestURL
        
        return request
    }
}

    
