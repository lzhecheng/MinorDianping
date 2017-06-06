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
        let WHETHER_INIT = false
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
            
            for i in 1 ..< numOfRestaurants{
                let restaurant = createNewRestaurant(name: contents[i]["name"]!, address: contents[i]["address"]!, cityName: contents[i]["city"]!, latitude: Double(contents[i]["latitude"]!)!, longitude: Double(contents[i]["longitude"]!)!, is_save: false)
                // impprt city data
//                if let city = CityDatabaseController.fetchOneCityFromCoreData(name: contents[i]["city"]!){
//                    city.addToRestaurants(restaurant)
//                }
//                else{
//                    let city:City = NSEntityDescription.insertNewObject(forEntityName: cityClassName, into: DatabaseController.getContext()) as! City
//                    city.cityName = contents[i]["city"]!
//                    city.addToRestaurants(restaurant)
//                }
            
                // import user data
                
            }
            DatabaseController.saveContext()
            print("Database init: Save database successfully")
        }
    }
    
    convenience override init(){
        self.init(filename: "mexico")
    }

//    deinit{
//        guard self.deleteAllObjectsInCoreData(type: Restaurant.self) && self.deleteAllObjectsInCoreData(type: City.self) && self.deleteAllObjectsInCoreData(type: UserInfo.self) else{
//            print("Failed to delete database")
//            return
//        }
//    }
    
    // MARK: Attribute Modification Functions
    func createNewRestaurant(name: String, address: String, cityName: String, latitude: Double, longitude: Double, is_save: Bool) -> Restaurant{
        let restaurant:Restaurant = NSEntityDescription.insertNewObject(forEntityName: String(describing: Restaurant.self), into: DatabaseController.getContext()) as! Restaurant
        restaurant.name = name
        restaurant.address = address
        restaurant.latitude = latitude
        restaurant.longitude = longitude
        if let city = CityDatabaseController.fetchOneCityFromCoreData(name: cityName){
            city.addToRestaurants(restaurant)
        }
        else{
            let city = createNewCity(cityName: cityName, is_save: false)
            city.addToRestaurants(restaurant)
        }
        if(is_save){
            DatabaseController.saveContext()
        }
        return restaurant
    }
    
    func createNewCity(cityName: String, is_save: Bool) -> City{
        let city:City = NSEntityDescription.insertNewObject(forEntityName: String(describing: City.self), into: DatabaseController.getContext()) as! City
        city.cityName = cityName
        if(is_save){
            DatabaseController.saveContext()
        }
        return city;
    }
    
    func createNewUserInfo(latitude: Double, longitude: Double, name: String, password: String, price: Double, is_save: Bool) -> UserInfo{
        do{
            let userInfo:UserInfo = try NSEntityDescription.insertNewObject(forEntityName: String(describing: UserInfo.self), into: DatabaseController.getContext()) as! UserInfo
            userInfo.name = name
            userInfo.latitude = latitude
            userInfo.longitude = longitude
            userInfo.password = password
            userInfo.price = price
            if(is_save){
                try DatabaseController.saveContext()
            }
            return userInfo
        }catch{
            self.deleteAllObjectsInCoreData(type: Restaurant.self)
            self.deleteAllObjectsInCoreData(type: City.self)
            self.deleteAllObjectsInCoreData(type: UserInfo.self)
        }
    }
    
    func modifyAttribute<T>( des: inout T, src: T, is_save: Bool = true) {
        des = src
        if(is_save){
            DatabaseController.saveContext()
        }
    }
    
    func modifyRestaurantToCity( des: Restaurant, cityName: String, is_save: Bool = true ){
        des.city?.removeFromRestaurants(des)
        if let city = CityDatabaseController.fetchOneCityFromCoreData(name: cityName){
            city.addToRestaurants(des)
        }
        else{
            let city = createNewCity(cityName: cityName, is_save: false)
            city.addToRestaurants(des)
        }
        if(is_save){
            DatabaseController.saveContext()
        }
    }
}
