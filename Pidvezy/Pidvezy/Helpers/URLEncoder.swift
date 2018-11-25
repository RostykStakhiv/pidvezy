//
//  URLEncoder.swift
//  Pidvezy
//
//  Created by admin on 11/25/18.
//  Copyright © 2018 Pidvezy. All rights reserved.
//

import UIKit

class URLEncoder {
    class func buildEncodedURL(withUrlString urlStr: String, params: Dictionary<String, String>) -> URL? {
        if var urlComponents = URLComponents(string: urlStr) {
            urlComponents.queryItems = params.map({ (key, value) in
                URLQueryItem(name: key, value: value)
            })
            
            urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            return urlComponents.url
        }
        
        return nil
    }
}
