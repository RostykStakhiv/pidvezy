

import Foundation
import CoreData

@objc protocol ModelMapper {
    
    static var entityName: String {get}
    static var idKey: String {get}
    
    func parse(node: Dictionary<String, Any>)
	@objc optional static func fetchRequest(id: Int64) -> NSFetchRequest<NSFetchRequestResult>
    @objc optional static func fetchRequest(stringId: String) -> NSFetchRequest<NSFetchRequestResult>
}
