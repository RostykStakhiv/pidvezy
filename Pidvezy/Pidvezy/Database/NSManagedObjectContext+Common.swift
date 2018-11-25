

import Foundation
import CoreData

extension NSManagedObjectContext {
    func create<T : NSManagedObject>(entity: T.Type) -> T where T : ModelMapper  {
        let classname = entity.entityName
        let object = NSEntityDescription.insertNewObject(forEntityName: classname, into: self) as! T
        return object
    }
}
