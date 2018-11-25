//
//  User+CoreDataProperties.swift
//  Pidvezy
//
//  Created by admin on 11/23/18.
//  Copyright © 2018 Pidvezy. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userId: String?
    @NSManaged public var name: String?
    @NSManaged public var userFbId: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var locale: String?
    @NSManaged public var jobDescription: String?
    @NSManaged public var gender: String?
    @NSManaged public var registrationDate: NSDate?
    @NSManaged public var routes: NSSet?

}

// MARK: Generated accessors for routes
extension User {

    @objc(addRoutesObject:)
    @NSManaged public func addToRoutes(_ value: Route)

    @objc(removeRoutesObject:)
    @NSManaged public func removeFromRoutes(_ value: Route)

    @objc(addRoutes:)
    @NSManaged public func addToRoutes(_ values: NSSet)

    @objc(removeRoutes:)
    @NSManaged public func removeFromRoutes(_ values: NSSet)

}
