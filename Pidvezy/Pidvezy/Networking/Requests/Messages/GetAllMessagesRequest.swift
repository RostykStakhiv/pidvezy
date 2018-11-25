//
//  GetAllMessagesRequest.swift
//
//  Created by  Rostyslav_Stakhiv on 2018-11-22.
//

import Foundation

class GetAllMessagesRequest: Request {
    
    class GetAllMessagesResponse: Response {
        
        override func parseResponse(response: URLResponse?, data: Data?) throws {
            try super.parseResponse(response: response, data: data)
            
            //FIXME: Do object/core data model filling from variable json
        }
    }
    
    private lazy var actualResponse = GetAllMessagesResponse()
    override private(set) var response: Response {
        get {
            return actualResponse
        }
        set {
            if newValue is GetAllMessagesResponse {
                actualResponse = newValue as! GetAllMessagesResponse
            } else {
                print("incorrect type of response")
            }
        }
    }
    
    override func serviceURLRequest() -> URLRequest {
        var request = super.serviceURLRequest()
        
        request.httpMethod = "GET"
        request.url = URL(string: "\(Request.baseURL)messages/")
        
        return request
    }
}

    
