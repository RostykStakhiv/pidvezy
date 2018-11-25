//
//  User+CoreDataClass.swift
//  Pidvezy
//
//  Created by admin on 11/23/18.
//  Copyright © 2018 Pidvezy. All rights reserved.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject, ModelMapper {
    
    static var entityName: String {
        get {
            return "User"
        }
    }
    
    static var idKey: String {
        get {
            return "userId"
        }
    }
    
    static func fetchRequest(id: Int64) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(idKey) == \(id)")
        return fetchRequest as! NSFetchRequest<NSFetchRequestResult>
    }
    
    func parse(node: [String: Any]) {
        
    }

}
