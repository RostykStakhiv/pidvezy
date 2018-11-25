//
//  Route+CoreDataProperties.swift
//  Pidvezy
//
//  Created by admin on 11/25/18.
//  Copyright © 2018 Pidvezy. All rights reserved.
//
//

import Foundation
import CoreData


extension Route {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Route> {
        return NSFetchRequest<Route>(entityName: "Route")
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var regularDays: [Int]?
    @NSManaged public var regularity: String?
    @NSManaged public var routeDate: NSDate?
    @NSManaged public var routeId: String?
    @NSManaged public var routePoints: [GoogleAddressModel]?
    @NSManaged public var type: String?
    @NSManaged public var polylinePoints: String?
    @NSManaged public var creator: User?

}
