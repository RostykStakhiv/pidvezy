//
//  LogoutRequest.swift
//
//  Created by  Rostyslav_Stakhiv on 2018-11-19.
//

import Foundation

class LogoutRequest: Request {
    
    class LogoutResponse: Response {
        
        override func parseResponse(response: URLResponse?, data: Data?) throws {
            try super.parseResponse(response: response, data: data)
            
            //FIXME: Do object/core data model filling from variable json
        }
    }
    
    var accessToken: String?
    
    private lazy var actualResponse = LogoutResponse()
    override private(set) var response: Response {
        get {
            return actualResponse
        }
        set {
            if newValue is LogoutResponse {
                actualResponse = newValue as! LogoutResponse
            } else {
                print("incorrect type of response")
            }
        }
    }
    
    override func serviceURLRequest() -> URLRequest {
        var request = super.serviceURLRequest()
        
        guard let fbAppID = Bundle.main.object(forInfoDictionaryKey: "FacebookAppID") as? String,
                let token = accessToken else {
            return request
        }
        
        request.httpMethod = "POST"
        request.url = URL(string: "\(Request.baseURL)auth/revoke-token/")
        let params = ["client_id": fbAppID,
                      "client_secret": "7baf6407e303f0ed2a4956e98401cb5f",
                      "token": token]
        do {
            let postData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = postData
        } catch {
        }
        
        return request
    }
}

    
