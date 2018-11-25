//
//  Route+CoreDataClass.swift
//  Pidvezy
//
//  Created by admin on 11/23/18.
//  Copyright © 2018 Pidvezy. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Route)
public class Route: NSManagedObject, ModelMapper {
    
    static var entityName: String {
        get {
            return "Route"
        }
    }
    
    static var idKey: String {
        get {
            return "routeId"
        }
    }
    
    static func fetchRequest(stringId: String) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest:NSFetchRequest<Route> = Route.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(idKey) LIKE %@", stringId)
        return fetchRequest as! NSFetchRequest<NSFetchRequestResult>
    }
    
    func parse(node: [String: Any]) {
        name = node["name"] as? String
        type = node["type"] as? String
        
        routeId = node["id"] as? String
        regularity = node["regularity"] as? String
        regularDays = node["regular_days"] as? [Int]
        
        let dateFormatter = DateFormatter()
        
        if let dateString = node["time"] as? String {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            if let date = dateFormatter.date(from: dateString) {
                routeDate = date as NSDate
            }
        }
        
        var routePoints = [GoogleAddressModel]()
        
        if let startAddress = node["addr_s"] as? String,
            let startCoords = node["loc_s"] as? [Double],
            startCoords.count == 2,
            let startPoint = GoogleAddressModel(address: startAddress, coordinates: startCoords) {
            routePoints.append(startPoint)
        }
        
        if let endAddress = node["addr_e"] as? String,
            let endCoords = node["loc_e"] as? [Double],
            endCoords.count == 2,
            let endPoint = GoogleAddressModel(address: endAddress, coordinates: endCoords) {
            routePoints.append(endPoint)
        }
        
        self.routePoints = routePoints
        
        if let creationDateString = node["created_on"] as? String {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            
            if let creationDate = dateFormatter.date(from: creationDateString) {
                self.creationDate = creationDate as NSDate
            }
        }
        
        polylinePoints = node["polyline_points"] as? String
    }

}
