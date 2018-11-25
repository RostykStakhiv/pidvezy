//
//  EditRouteRequest.swift
//
//  Created by  Rostyslav_Stakhiv on 2018-11-22.
//

import Foundation

class EditRouteRequest: Request {
    
    class EditRouteResponse: Response {
        
        override func parseResponse(response: URLResponse?, data: Data?) throws {
            try super.parseResponse(response: response, data: data)
            
            //FIXME: Do object/core data model filling from variable json
        }
    }
    
    var route: RouteInfoModel?
    
    private lazy var actualResponse = EditRouteResponse()
    override private(set) var response: Response {
        get {
            return actualResponse
        }
        set {
            if newValue is EditRouteResponse {
                actualResponse = newValue as! EditRouteResponse
            } else {
                print("incorrect type of response")
            }
        }
    }
    
    override func serviceURLRequest() -> URLRequest {
        var request = super.serviceURLRequest()
        
        guard let route = route, let routeId = route.routeID, var params = route.toFullRouteInfoJSON(), let userID = UserProvider.currentUserID, let userFBID = UserProvider.currentUserFBID else {
            return request
        }
        
        request.httpMethod = "PATCH"
        request.url = URL(string: "\(Request.baseURL)routes/\(routeId)")
        
        params["user_id"] = userID as AnyObject
        params["fb_id"] = userFBID as AnyObject
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = postData
        } catch {
        }
        
        return request
    }
}

    
