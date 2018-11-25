//
//  GetPlaceDetailsWithIdRequest.swift
//
//  Created by  Rostyslav_Stakhiv on 2018-09-23.
//

import Foundation

class GetPlaceDetailsWithIdRequest: Request {
    
    class GetPlaceDetailsWithIdResponse: Response {
        var addressModel: GoogleAddressModel?
        
        override func parseResponse(response: URLResponse?, data: Data?) throws {
            try super.parseResponse(response: response, data: data)
            
            if let jsonDictionary = json as? Dictionary<String, Any> {
                let result = jsonDictionary["result"] as! [String: Any]
                addressModel = GoogleAddressModel(dictionary: result)
            }
        }
    }
    
    var placeId: String?
    
    private lazy var actualResponse = GetPlaceDetailsWithIdResponse()
    override private(set) var response: Response {
        get {
            return actualResponse
        }
        set {
            if newValue is GetPlaceDetailsWithIdResponse {
                actualResponse = newValue as! GetPlaceDetailsWithIdResponse
            } else {
                print("incorrect type of response")
            }
        }
    }
    
    override func serviceURLRequest() -> URLRequest {
        var request = super.serviceURLRequest()
        
        guard let placeId = placeId else {
            return request
        }
        
        let params = ["placeid": placeId,
                      "key": GoogleSDKConstants.kGoogleAPIKey]
        
        request.httpMethod = "GET"
        request.url = URL(string: BaseURLs.GooglePlaceDetailsBaseURL)
        do {
            let postData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = postData
        } catch {
        }
        
        return request
    }
}
