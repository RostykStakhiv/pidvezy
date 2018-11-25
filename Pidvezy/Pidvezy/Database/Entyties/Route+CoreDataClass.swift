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
        
    }

}
