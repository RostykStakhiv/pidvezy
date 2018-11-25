//
//  LoginWithFacebookRequest.swift
//
//  Created by  Rostyslav_Stakhiv on 2018-11-19.
//

import Foundation

class LoginWithFacebookRequest: Request {
    
    class LoginWithFacebookResponse: Response {
        
        var session: Session?
        
        override func parseResponse(response: URLResponse?, data: Data?) throws {
            try super.parseResponse(response: response, data: data)
            
            if let jsonDictionary = json as? Dictionary<String, Any> {
                session = Session(JSON: jsonDictionary)
            }
        }
    }
    
    var fbToken: String?
    
    private lazy var actualResponse = LoginWithFacebookResponse()
    override private(set) var response: Response {
        get {
            return actualResponse
        }
        set {
            if newValue is LoginWithFacebookResponse {
                actualResponse = newValue as! LoginWithFacebookResponse
            } else {
                print("incorrect type of response")
            }
        }
    }
    
    override func serviceURLRequest() -> URLRequest {
        var request = super.serviceURLRequest()
        
        guard let token = fbToken, let fbAppID = Bundle.main.object(forInfoDictionaryKey: "FacebookAppID") as? String else {
            return request
        }
        
        request.httpMethod = "POST"
        request.url = URL(string: "\(Request.baseURL)auth/convert-token/")
        
        let params = ["grant_type": "convert_token",
                      "client_id": fbAppID,
                      "client_secret": "d22b57a27519709123cf49d7c58852db",
                      "backend": "facebook",
                      "token": token]
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = postData
        } catch {
        }
        
        return request
    }
}

    
