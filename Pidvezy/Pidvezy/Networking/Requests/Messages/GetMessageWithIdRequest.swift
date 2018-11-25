//
//  GetMessageWithIdRequest.swift
//
//  Created by  Rostyslav_Stakhiv on 2018-11-22.
//

import Foundation

class GetMessageWithIdRequest: Request {
    
    class GetMessageWithIdResponse: Response {
        
        override func parseResponse(response: URLResponse?, data: Data?) throws {
            try super.parseResponse(response: response, data: data)
            
            //FIXME: Do object/core data model filling from variable json
        }
    }
    
    var messageId: String?
    
    private lazy var actualResponse = GetMessageWithIdResponse()
    override private(set) var response: Response {
        get {
            return actualResponse
        }
        set {
            if newValue is GetMessageWithIdResponse {
                actualResponse = newValue as! GetMessageWithIdResponse
            } else {
                print("incorrect type of response")
            }
        }
    }
    
    override func serviceURLRequest() -> URLRequest {
        var request = super.serviceURLRequest()
        
        guard let mId = messageId else {
            return request
        }
        
        request.httpMethod = "GET"
        request.url = URL(string: "\(Request.baseURL)messages/\(mId)")
        
        return request
    }
}

    
