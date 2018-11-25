

import Foundation
import CoreData

class DataModel {
    static let shared = DataModel()
    
    private init() {
    }
    

    // MARK: Core Data Stack setup
    fileprivate lazy var managedObjectContext: NSManagedObjectContext = {
        
        var managedObjectContext: NSManagedObjectContext?
        if #available(iOS 10.0, *){
            
            managedObjectContext = self.persistentContainer.viewContext
        } else {
            // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
            let coordinator = self.persistentStoreCoordinator
            managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext?.persistentStoreCoordinator = coordinator
            
        }
        return managedObjectContext!
    }()
    
    fileprivate lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Pidvezy", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("Pidvezy.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            // Configure automatic migration.
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            do {
                try FileManager.default.removeItem(at: url)
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            } catch {
                // Report any error we got.
                var dict = [String: AnyObject]()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
                dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
                
                dict[NSUnderlyingErrorKey] = error as NSError
                let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
                // Replace this with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
                abort()
            }
        }
        
        return coordinator
    }()
    
    // iOS-10
    @available(iOS 10.0, *)
    fileprivate lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Pidvezy")
        
        let url = self.applicationDocumentsDirectory.appendingPathComponent("Pidvezy.sqlite")
        let description = NSPersistentStoreDescription(url: url)
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                do {
                    let url = self.applicationDocumentsDirectory.appendingPathComponent("Pidvezy.sqlite")
                    try FileManager.default.removeItem(at: url)
                    let container = NSPersistentContainer(name: "Pidvezy")
                    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                        if let error = error as NSError? {
                            // Replace this implementation with code to handle the error appropriately.
                            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                            
                            /*
                             Typical reasons for an error here include:
                             * The parent directory does not exist, cannot be created, or disallows writing.
                             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                             * The device is out of space.
                             * The store could not be migrated to the current model version.
                             Check the error message to determine what the actual problem was.
                             */
                            fatalError("Unresolved error \(error), \(error.userInfo)")
                        }
                    })
                } catch let error {
                    fatalError("Unresolved error \(error)")
                }
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    // MARK: private
    fileprivate lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    // MARK: public
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                //TODO: Handle error
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func emptyObject(name: String) -> NSManagedObject {
        let entity = NSEntityDescription.entity(forEntityName: name, in: managedObjectContext)!
        return NSManagedObject(entity:entity, insertInto:managedObjectContext)
    }
    
    
    //MARK: Private Methods
    fileprivate func recycleUniqueEntity(entity: ModelMapper.Type, id: Any) -> Any? {
        var fetchRequest: NSFetchRequest<NSFetchRequestResult>?
        
        if let int64Id = id as? Int64,
            let intIdFetchRequest = entity.fetchRequest?(id: int64Id) {
            fetchRequest = intIdFetchRequest
        } else if let stringId = id as? String {
            fetchRequest = entity.fetchRequest?(stringId: stringId)
        }
        
        guard let existingFetchRequest = fetchRequest, let fetchedEntity = fetchUniqueEntity(request: existingFetchRequest) else {
            return emptyObject(name: entity.entityName)
        }
        
        return fetchedEntity
    }
    
    private func fetchEntities(request: NSFetchRequest<NSFetchRequestResult>) -> [Any] {
        do {
            let fetchedObjects = try managedObjectContext.fetch(request)
            return fetchedObjects
        } catch {
            fatalError("Failed to fetch entites: \(error)")
        }
    }
    
    private func fetchUniqueEntity(request: NSFetchRequest<NSFetchRequestResult>) -> Any? {
        let fetchedObjects = fetchEntities(request: request)
        assert(fetchedObjects.count <= 1, "only one object can exist with specified id")
        
        if fetchedObjects.count > 1 {
            // try to recover by deleting all objects with given id
            for fetchedObject in fetchedObjects {
                managedObjectContext.delete(fetchedObject as! NSManagedObject)
            }
            
            return nil
        } else if fetchedObjects.count == 1 {
            return fetchedObjects[0]
        }
        
        return nil
    }
    
    private func remove(entity: ModelMapper.Type){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            
            _ = try persistentStoreCoordinator.execute(deleteRequest, with: managedObjectContext)
            managedObjectContext.reset()
        } catch _ as NSError {
            // TODO: handle the error
        }
    }
}

//MARK: Parsing
extension DataModel {
    
    //MARK: User
    func parseUser(data: Dictionary<String, Any>) -> User? {
        guard let userID = data["id"] as? String, let fetchedUser = recycleUniqueEntity(entity: User.self, id: userID) as? User else {
            return nil
        }
        
        fetchedUser.parse(node: data)
        
        if let routesIds = data["routes"] as? [String] {
            var routesSet = Set<Route>()
            for routeId in routesIds {
                if let fetchedRoute = recycleUniqueEntity(entity: Route.self, id: routeId) as? Route {
                    routesSet.insert(fetchedRoute)
                }
            }
            
            fetchedUser.routes = routesSet as NSSet
        }
        return fetchedUser
    }
    
    //MARK: Routes
    func parseRoute(data: Dictionary<String, Any>) -> Route? {
        guard let routeId = data["id"] as? String, let fetchedRoute = recycleUniqueEntity(entity: Route.self, id: routeId) as? Route else {
            return nil
        }
        
        fetchedRoute.parse(node: data)
        
        if let routeAuthorId = data["user_id"],
            let userData = data["user"] as? Dictionary<String, Any>,
            let fetchedUser = recycleUniqueEntity(entity: User.self, id: routeAuthorId) as? User {
            fetchedUser.parse(node: userData)
            fetchedRoute.creator = fetchedUser
        }
        
        return fetchedRoute
    }
    
    func parseRoutes(data: [Dictionary<String, Any>]) -> [Route] {
        var routes = [Route]()
        
        for routeNode in data {
            if let parsedRoute = parseRoute(data: routeNode) {
                routes.append(parsedRoute)
            }
        }
        
        return routes
    }
}

//MARK: Fetching
extension DataModel {
}

// MARK: - Public methods
extension DataModel {
	func clearCoreDataStore() {
		let model: NSManagedObjectModel?

		if #available(iOS 10.0, *) {
			model = persistentContainer.managedObjectModel
		} else {
			model = managedObjectContext.persistentStoreCoordinator?.managedObjectModel
		}

		guard let checkModel = model else { return }

		let entities = checkModel.entities
		for entity in entities {
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
			let deleteReqest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
			do {
				try managedObjectContext.execute(deleteReqest)
			} catch {
				print(error)
			}
		}

		managedObjectContext.reset()
	}
}
