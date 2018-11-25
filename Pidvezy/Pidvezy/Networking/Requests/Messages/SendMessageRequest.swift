//
//  SendMessageRequest.swift
//
//  Created by  Rostyslav_Stakhiv on 2018-11-22.
//

import Foundation

class SendMessageRequest: Request {
    
    class SendMessageResponse: Response {
        
        override func parseResponse(response: URLResponse?, data: Data?) throws {
            try super.parseResponse(response: response, data: data)
            
            //FIXME: Do object/core data model filling from variable json
        }
    }
    
    var roomId: String?
    var message: String?
    
    private lazy var actualResponse = SendMessageResponse()
    override private(set) var response: Response {
        get {
            return actualResponse
        }
        set {
            if newValue is SendMessageResponse {
                actualResponse = newValue as! SendMessageResponse
            } else {
                print("incorrect type of response")
            }
        }
    }
    
    override func serviceURLRequest() -> URLRequest {
        var request = super.serviceURLRequest()
        
        guard let roomId = roomId, let message = message else {
            return request
        }
        
        request.httpMethod = "POST"
        request.url = URL(string: "\(Request.baseURL)messages/")
        
        let params = ["room": roomId,
                      "msg_type": 0,
                      "message": message] as [String : Any]
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = postData
        } catch {
        }
        
        return request
    }
}

    
