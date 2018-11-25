//
//  GetMyRoutesRequest.swift
//
//  Created by  Rostyslav_Stakhiv on 2018-11-19.
//

import Foundation

class GetMyRoutesRequest: Request {
    
    class GetMyRoutesResponse: Response {
        
        var routes = [Route]()
        
        override func parseResponse(response: URLResponse?, data: Data?) throws {
            try super.parseResponse(response: response, data: data)
            
            if let jsonDict = json as? Dictionary<String, Any>,
                let results = jsonDict["results"] as? [Dictionary<String, Any>] {
                DispatchQueue.main.async {
                    self.routes = DataModel.shared.parseRoutes(data: results)
                }
            }
        }
    }
    
    private lazy var actualResponse = GetMyRoutesResponse()
    override private(set) var response: Response {
        get {
            return actualResponse
        }
        set {
            if newValue is GetMyRoutesResponse {
                actualResponse = newValue as! GetMyRoutesResponse
            } else {
                print("incorrect type of response")
            }
        }
    }
    
    override func serviceURLRequest() -> URLRequest {
        var request = super.serviceURLRequest()
        
        request.httpMethod = "GET"
        request.url = URL(string: "\(Request.baseURL)routes/me")
        
        return request
    }
}

    
