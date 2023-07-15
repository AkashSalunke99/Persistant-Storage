import CoreData

class PersistentContainer: NSPersistentContainer {
    
    init(name: String) {
        let modelURL = Bundle.main.url(forResource: "Person", withExtension: "momd")!
        super.init(name: name, managedObjectModel: NSManagedObjectModel(contentsOf: modelURL)!)
    }
    
    func saveContext() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
