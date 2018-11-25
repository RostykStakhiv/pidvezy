//
//  CreateRouteRequest.swift
//
//  Created by  Rostyslav_Stakhiv on 2018-11-19.
//

import Foundation

class CreateRouteRequest: Request {
    
    class CreateRouteResponse: Response {
        
        var route: Route?
        
        override func parseResponse(response: URLResponse?, data: Data?) throws {
            try super.parseResponse(response: response, data: data)
            
            if let jsonDict = json as? Dictionary<String, Any> {
                DispatchQueue.main.async {
                    self.route = DataModel.shared.parseRoute(data: jsonDict)
                }
            }
        }
    }
    
    var routeModel: RouteInfoModel?
    
    private lazy var actualResponse = CreateRouteResponse()
    override private(set) var response: Response {
        get {
            return actualResponse
        }
        set {
            if newValue is CreateRouteResponse {
                actualResponse = newValue as! CreateRouteResponse
            } else {
                print("incorrect type of response")
            }
        }
    }
    
    override func serviceURLRequest() -> URLRequest {
        var request = super.serviceURLRequest()
        
        guard let route = routeModel else {
            return request
        }
        
        request.httpMethod = "POST"
        request.url = URL(string: "\(Request.baseURL)routes/")
        
        let params = route.toFullRouteInfoJSON()
        do {
            let postData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = postData
        } catch {
        }
        
        return request
    }
}

    
