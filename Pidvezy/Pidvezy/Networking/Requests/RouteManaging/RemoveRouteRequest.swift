//
//  RemoveRouteRequest.swift
//
//  Created by  Rostyslav_Stakhiv on 2018-11-22.
//

import Foundation

class RemoveRouteRequest: Request {
    
    class RemoveRouteResponse: Response {
        
        override func parseResponse(response: URLResponse?, data: Data?) throws {
            try super.parseResponse(response: response, data: data)
            
            //FIXME: Do object/core data model filling from variable json
        }
    }
    
    var routeId: String?
    
    private lazy var actualResponse = RemoveRouteResponse()
    override private(set) var response: Response {
        get {
            return actualResponse
        }
        set {
            if newValue is RemoveRouteResponse {
                actualResponse = newValue as! RemoveRouteResponse
            } else {
                print("incorrect type of response")
            }
        }
    }
    
    override func serviceURLRequest() -> URLRequest {
        var request = super.serviceURLRequest()
        
        guard let routeId = routeId else {
            return request
        }
        
        request.httpMethod = "DELETE"
        request.url = URL(string: "\(Request.baseURL)routes/\(routeId)")
        
        return request
    }
}

    
