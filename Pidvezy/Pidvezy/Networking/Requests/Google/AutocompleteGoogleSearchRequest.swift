//
//  AutocompleteGoogleSearchRequest.swift
//
//  Created by  Rostyslav_Stakhiv on 2018-09-23.
//

import Foundation
import GoogleMaps

class AutocompleteGoogleSearchRequest: Request {
    
    class AutocompleteGoogleSearchResponse: Response {
        var googlePredModels = [GooglePredictionModel]()
        
        override func parseResponse(response: URLResponse?, data: Data?) throws {
            try super.parseResponse(response: response, data: data)
            
            if let jsonDictionary = json as? Dictionary<String, Any> {
                let predictions = jsonDictionary["predictions"] as! [[String: Any]]
                
                for object in predictions {
                    let lGooglePredModel = GooglePredictionModel(dictionary: object)
                    googlePredModels.append(lGooglePredModel)
                }
            }
        }
    }
    
    var input: String?
    
    private lazy var actualResponse = AutocompleteGoogleSearchResponse()
    override private(set) var response: Response {
        get {
            return actualResponse
        }
        set {
            if newValue is AutocompleteGoogleSearchResponse {
                actualResponse = newValue as! AutocompleteGoogleSearchResponse
            } else {
                print("incorrect type of response")
            }
        }
    }
    
    override func serviceURLRequest() -> URLRequest {
        var request = super.serviceURLRequest()
        guard let userInput = input else {
            return request
        }
        
        let params = ["input": userInput,
                      "key": GoogleSDKConstants.kGoogleAPIKey]
        
        guard let requestURL = URLEncoder.buildEncodedURL(withUrlString: BaseURLs.GoogleAutocompleteBaseURL, params: params) else {
            return request
        }
        
        request.httpMethod = "GET"
        request.url = requestURL
        
        return request
    }
}

    
