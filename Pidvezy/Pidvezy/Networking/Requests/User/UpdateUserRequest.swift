//
//  UpdateUserRequest.swift
//
//  Created by  Rostyslav_Stakhiv on 2018-11-22.
//

import Foundation

class UpdateUserRequest: Request {
    
    class UpdateUserResponse: Response {
        
        override func parseResponse(response: URLResponse?, data: Data?) throws {
            try super.parseResponse(response: response, data: data)
            
            //FIXME: Do object/core data model filling from variable json
        }
    }
    
    var user: UserProfileModel?
    
    private lazy var actualResponse = UpdateUserResponse()
    override private(set) var response: Response {
        get {
            return actualResponse
        }
        set {
            if newValue is UpdateUserResponse {
                actualResponse = newValue as! UpdateUserResponse
            } else {
                print("incorrect type of response")
            }
        }
    }
    
    override func serviceURLRequest() -> URLRequest {
        var request = super.serviceURLRequest()
        
        guard let userModel = user else {
            return request
        }
        
        request.httpMethod = "PATCH"
        request.url = URL(string: "\(Request.baseURL)users/me")
        
        let params = userModel.toJSON()
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = postData
        } catch {
        }
        
        return request
    }
}

    
