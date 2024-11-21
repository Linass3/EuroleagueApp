import CoreData
import Alamofire

class PreviewDataStack {
    static let shared = PreviewDataStack()
    
     private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EuroleagueAppDataModel")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
                
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var mockContext: NSManagedObjectContext {
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }
}
