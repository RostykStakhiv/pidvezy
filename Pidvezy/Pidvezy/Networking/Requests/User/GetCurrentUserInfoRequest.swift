//
//  GetCurrentUserInfoRequest.swift
//
//  Created by  Rostyslav_Stakhiv on 2018-11-22.
//

import Foundation

class GetCurrentUserInfoRequest: Request {
    
    class GetCurrentUserInfoResponse: Response {
        
        var user: User?
        
        override func parseResponse(response: URLResponse?, data: Data?) throws {
            try super.parseResponse(response: response, data: data)
            
            if let jsonDictionary = json as? Dictionary<String, Any> {
                DispatchQueue.main.async {
                    self.user = DataModel.shared.parseUser(data: jsonDictionary)
                }
            }
        }
    }
    
    private lazy var actualResponse = GetCurrentUserInfoResponse()
    override private(set) var response: Response {
        get {
            return actualResponse
        }
        set {
            if newValue is GetCurrentUserInfoResponse {
                actualResponse = newValue as! GetCurrentUserInfoResponse
            } else {
                print("incorrect type of response")
            }
        }
    }
    
    override func serviceURLRequest() -> URLRequest {
        var request = super.serviceURLRequest()
        
        request.httpMethod = "GET"
        request.url = URL(string: "\(Request.baseURL)users/me)")
        
        return request
    }
}

    
