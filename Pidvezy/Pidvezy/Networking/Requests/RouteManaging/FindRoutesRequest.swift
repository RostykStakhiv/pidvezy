//
//  FindRoutesRequest.swift
//
//  Created by  Rostyslav_Stakhiv on 2018-11-22.
//

import Foundation
import CoreData

class FindRoutesRequest: PaginableRequest {
    
    class FindRoutesResponse: PaginableResponse {
        
        private(set) var routes = [Route]()
        override func parseItems(dataArray:[Dictionary<String, Any>]) {
            DispatchQueue.main.async {
                self.routes = DataModel.shared.parseRoutes(data: dataArray)
            }
        }
        
        override var items: [NSManagedObject] {
            get {
                return routes
            }
        }
    }
    
    var routeModel: RouteInfoModel?
    
    private lazy var actualResponse = FindRoutesResponse()
    override private(set) var response: Response {
        get {
            return actualResponse
        }
        set {
            if newValue is FindRoutesResponse {
                actualResponse = newValue as! FindRoutesResponse
            } else {
                print("incorrect type of response")
            }
        }
    }
    
    override func serviceURLRequest() -> URLRequest {
        var request = super.serviceURLRequest()
        
        guard let route = routeModel else {
            return request
        }
        
        request.httpMethod = "GET"
        request.url = URL(string: "\(Request.baseURL)search/")
        
        let params = route.toSearchJSON()
        do {
            let postData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = postData
        } catch {
        }
        
        return request
    }
}

    
