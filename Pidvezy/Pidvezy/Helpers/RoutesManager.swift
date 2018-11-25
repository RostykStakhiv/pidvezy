

import UIKit

let kSearchResultsKey = "results"

class RoutesManager {
    
    class func parseRoutModelsResponse(response json: [String: Any]?) -> [RouteInfoModel] {
        var routeInfoModels: [RouteInfoModel] = []
        
        if json != nil {
            if let results = json![kSearchResultsKey] as? [[String: Any]] {
                for routeDict in results {
                    let lRouteInfoModel = RouteInfoModel(dictionary: routeDict)
                    routeInfoModels.append(lRouteInfoModel)
                }
            }
        }
        
        return routeInfoModels
    }
}
