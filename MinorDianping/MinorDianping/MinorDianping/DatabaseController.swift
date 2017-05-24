//
//  DatabaseController.swift
//  MinorDianping
//
//  Created by Apple on 2017/5/16.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//
import Foundation
import CoreData

class DatabaseController{
    // MARK: - Core Data stack
    
    init(filename: String){
        self.deleteAllObjectsInCoreData()
        print("Database init: Delete past database successfully")
        
        // MARK: CSV File Operations
        let csvHelper = CSVHelper()
        let file:String = csvHelper.readDataFromFile(file: filename, type: "csv")
        
        guard let contents:[[String:String]] = csvHelper.convertCSV(file: file)else {
            print("Database init: Failed to parse successfully")
            return
        }
        
        let numOfRestaurants = contents.count
        
        // MARK: - Core Data Operations
        let cityClassName:String = String(describing: City.self)
        let restaurantClassName:String = String(describing: Restaurant.self)
        let stateClassName:String = String(describing: State.self)
        
        //            let city:City = NSEntityDescription.insertNewObject(forEntityName: cityClassName, into: DatabaseController.getContext()) as! City
        //            var cityNames:Set<String> = Set()
        //            for i in 0 ..< numOfRestaurants{
        //                cityNames.insert(contents[i]["city"]!)
        //            }
        //            for cityName in cityNames{
        //                city.cityName = cityName
        //            }
        
        for i in 1 ..< numOfRestaurants{
            let restaurant:Restaurant = NSEntityDescription.insertNewObject(forEntityName: restaurantClassName, into: DatabaseController.getContext()) as! Restaurant
            restaurant.name = contents[i]["name"]
            restaurant.address = contents[i]["address"]
            restaurant.latitude = Double(contents[i]["latitude"]!)!
            restaurant.longitude = Double(contents[i]["longitude"]!)!
            //restaurant.placeID = contents[i]["placeID"]! as! Int16
            //city.addToRestaurants(restaurant)
        }
        
        DatabaseController.saveContext()
        print("Database init: Save database successfully")
    }
    
    convenience init(){
        self.init(filename: "mexico")
    }
    
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
        let container = NSPersistentContainer(name: "MinorDianping")
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
    
    func fetchOneRestaurantFromCoreData(index: Int) -> Restaurant?{
        let fetchRequest:NSFetchRequest<Restaurant> = Restaurant.restaurantFetchRequest()
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            return searchResults[index]
        }
        catch{
            print("Error: \(error)")
            
        }
        return nil
    }
    
    func fetchOneRestaurantFromCoreData<T: NSManagedObject>(index: Int) -> T?{
        let fetchRequest:NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: T.self))
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            return searchResults[index]
        }
        catch{
            print("Error: \(error)")
            
        }
        return nil
    }
    
    func fetchAllRestaurantsFromCoreData() -> [Restaurant]?{
        let fetchRequest:NSFetchRequest<Restaurant> = Restaurant.restaurantFetchRequest()
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            return searchResults
        }
        catch{
            print("Error: \(error)")
            
        }
        return nil
    }
    
    // MARK: Core Data Deletion Functions
    func deleteOneObjectInCoreData(index: Int) -> Bool{
        let fetchRequest:NSFetchRequest<Restaurant> = Restaurant.restaurantFetchRequest()
        let context = DatabaseController.getContext()
        if let results = try? context.fetch(fetchRequest){
            context.delete(results[index])
            return true
        }
        return false
    }
    
    func deleteAllObjectsInCoreData() -> Bool{
        let fetchRequest:NSFetchRequest<Restaurant> = Restaurant.restaurantFetchRequest()
        let context = DatabaseController.getContext()
        if let results = try? context.fetch(fetchRequest){
            for result in results{
                // print(result.name!)
                context.delete(result)
            }
            DatabaseController.saveContext()
            return true
        }
        return false
    }
}
