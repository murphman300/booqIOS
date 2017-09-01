//
//  CoreDataManager.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-04.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation
import CoreData

fileprivate struct strings {
    static let didSeedStore : String = "didSeedPersistentStore"
}

class CoreDataManager: NSObject {
    
    static let node = CoreDataManager()
    
    fileprivate let thread = DispatchQueue(label: "Booq.Spotit.CD.Main", attributes: .concurrent)
    
    lazy var manageObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.manageObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("CDData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved Data"
        
        do {
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = dict["Failed to initialize the application's saved data"]
            dict[NSLocalizedFailureReasonErrorKey] = dict[failureReason]
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError)", "\(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1] as NSURL
    }()
    
    func createRecordForEntity(entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSManagedObject {
        
        var result: NSManagedObject? = nil
        
        //create entity description
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: managedObjectContext)
        //NSEntityDescription.insertNewObject(forEntityName: entity, into: managedObjectContext)
        if let entityDescription = entityDescription {
            
            result = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)
            
        }
        
        return result!
    }
    
    func establishEntities() {
        
    }
    
    func seedPersistentStoreWithManagedObjectContext(managedObjectContext: NSManagedObjectContext) {
        guard !UserDefaults.standard.bool(forKey: strings.didSeedStore) else { UserDefaults.standard.set(false, forKey: strings.didSeedStore)
            return
        }
        _ = createRecordForEntity(entity: "ProfilePic", inManagedObjectContext: managedObjectContext)
        _ = createRecordForEntity(entity: "ContactProfile", inManagedObjectContext: managedObjectContext)
        if saveChanges() {
            UserDefaults.standard.set(true, forKey: strings.didSeedStore)
        }
    }
    
    func omniTokenFromCore(_ completion: @escaping(String?) -> Void){
        
    }
    
    
    func saveTokenToCore(_ token: String) {
        
        UserDefaults.standard.set(true, forKey: "tosavedonlocalthings")
        
    }
    
    func saveTokenToCore(_ token: String,_ completion: @escaping (Bool) -> Void) {
        
        UserDefaults.standard.set(true, forKey: "tosavedonlocalthings")
        
    }
    
    
    func saveOptions(fromObject: [String:Any],_ completion: @escaping (Bool) -> Void) {
        
    }
    
    func saveProfilePicture() -> Bool {
        
        
        return true
    }
    
    func saveContext() {
        if managedObjectContext.hasChanges{
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror)", "\(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func destroyStore() {
        do {
            try persistentStoreCoordinator.destroyPersistentStore(at: self.applicationDocumentsDirectory.appendingPathComponent("CDData.sqlite")!, ofType: NSSQLiteStoreType, options: nil)
        } catch {
            print("Could not delete persistent store")
        }
    }
    
    func saveChanges() -> Bool {
        var result = true
        do {
            try managedObjectContext.save()
        } catch {
            result = false
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        return result
    }
    
    func saveData() {
        thread.sync {
            do {
                try managedObjectContext.save()
            } catch {
                print("appdelegateSave: Could not save all data")
            }
        }
    }
    
    func performOnThreadAsync(_ value: @escaping(()->())) {
        thread.async(execute: value)
    }
    
    func performOnThreadSync(_ value: @escaping(()->())) {
        thread.sync(execute: value)
    }
    
    func fetchSync<T: NSManagedObject>(_ request: NSFetchRequest<T>,_ completion: @escaping(([T])->())) {
        performOnThreadSync {
            do {
                let fetched = try self.managedObjectContext.fetch(request) as [T]
                completion(fetched)
            } catch {
                completion([])
            }
        }
    }
    
    func fetchAsync<T: NSManagedObject>(_ request: NSFetchRequest<T>,_ completion: @escaping(([T])->())) {
        performOnThreadAsync {
            do {
                let fetched = try self.managedObjectContext.fetch(request) as [T]
                completion(fetched)
            } catch {
                completion([])
            }
        }
    }
    
    func saveData(_ completion: @escaping() -> Void,_ failure: @escaping(_ result: String) -> Void) {
        do {
            try CoreDataManager.node.managedObjectContext.save()
            completion()
        } catch {
            failure("Failed to save")
        }
    }
}
