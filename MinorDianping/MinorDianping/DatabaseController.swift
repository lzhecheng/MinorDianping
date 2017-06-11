//
//  DatabaseController.swift
//  MinorDianping
//
//  Created by Apple on 2017/5/16.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation
import CoreData

class DatabaseController: NSObject{
    // MARK: - Core Data stack
//    init(completionClosure: @escaping () -> ()) {
//        persistentContainer = NSPersistentContainer(name: "DataModel")
//        persistentContainer.loadPersistentStores() { (description, error) in
//            if let error = error {
//                fatalError("Failed to load Core Data stack: \(error)")
//            }
//            completionClosure()
//        }
//    }

    class func getContext() -> NSManagedObjectContext{
        return DatabaseController.persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MinorDianping") // 声明了core data的存放文件名
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
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    class func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: Core Data Fetch Functions
    func fetchAllObjectsFromCoreData<T: NSManagedObject>() -> [T]?{
        let fetchRequest:NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: T.self))
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            return searchResults
        }catch{
            print("Error: \(error)")
            
        }
        return nil
    }
    
    // MARK: Core Data Deletion Functions
    internal func deleteAllObjectsInCoreData<T: NSManagedObject>(type: T.Type) -> Bool{
        let fetchRequest:NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: T.self))
        let context = DatabaseController.getContext()
        if let results = try? context.fetch(fetchRequest){
            for result in results{
                context.delete(result)
            }
            DatabaseController.saveContext()
            return true
        }
        return false
    }
    

    
    // MARK: Modification Functions

    
}
