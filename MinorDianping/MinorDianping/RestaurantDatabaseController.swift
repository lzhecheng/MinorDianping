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
                restaurant.placeID = contents[i]["placeID"]
                //city.addToRestaurants(restaurant)
            }
        }
        DatabaseController.saveContext()
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
    }
}
