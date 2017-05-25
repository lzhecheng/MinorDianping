//
//  RestaurantDatabaseController.swift
//  MinorDianping
//
//  Created by Apple on 2017/5/25.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation
import CoreData

class RestaurantDatabaseController : DatabaseController{
    init(filename: String){
        super.init()
        let WHETHER_CLEAR = false
        let WHETHER_INIT = true
        if(WHETHER_CLEAR){
            guard self.deleteAllObjectsInCoreData(type: Restaurant.self) else{
                print("Database init: Failed to delete past database")
                return
            }
        }
        if(WHETHER_INIT){
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
            //let stateClassName:String = String(describing: State.self)
            
            for i in 1 ..< numOfRestaurants{
                let restaurant:Restaurant = NSEntityDescription.insertNewObject(forEntityName: restaurantClassName, into: DatabaseController.getContext()) as! Restaurant
                restaurant.name = contents[i]["name"]
                restaurant.address = contents[i]["address"]
                restaurant.latitude = Double(contents[i]["latitude"]!)!
                restaurant.longitude = Double(contents[i]["longitude"]!)!
                restaurant.placeID = contents[i]["placeID"]
                if let city = self.fetchOneCityFromCoreData(name: contents[i]["city"]!){
                    city.addToRestaurants(restaurant)
                }
                else{
                    let city:City = NSEntityDescription.insertNewObject(forEntityName: cityClassName, into: DatabaseController.getContext()) as! City
                    city.cityName = contents[i]["city"]!
                    city.addToRestaurants(restaurant)
                }
            }
            DatabaseController.saveContext()
        }
        print("Database init: Save database successfully")
    }
    
    convenience override init(){
        self.init(filename: "mexico")
    }

    deinit{
        guard self.deleteAllObjectsInCoreData(type: Restaurant.self) else{
            print("Failed to delete")
            return
        }
        guard self.deleteAllObjectsInCoreData(type: City.self) else{
            print("Failed to delete")
            return
        }
    }

    func fetchOneCityFromCoreData(name: String) -> City?{
        let fetchRequest = NSFetchRequest<City>(entityName: "City");
        do{
            let cities = try DatabaseController.getContext().fetch(fetchRequest)
            for city in cities{
                if city.cityName == name{
                    return city
                }
            }
        }catch{
            print("Error: \(error)")
        }
        return nil
    }
}
