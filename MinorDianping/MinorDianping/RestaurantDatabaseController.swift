//
//  RestaurantDatabaseController.swift
//  MinorDianping
//
//  Created by Apple on 2017/5/25.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation
import CoreData
import UIKit

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
                _ = createNewRestaurant(name: contents[i]["name"]!, address: contents[i]["address"]!, cityName: contents[i]["city"]!, latitude: Double(contents[i]["latitude"]!)!, longitude: Double(contents[i]["longitude"]!)!, is_save: false)
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

            let userInfo:UserInfo = NSEntityDescription.insertNewObject(forEntityName: String(describing: UserInfo.self), into: DatabaseController.getContext()) as! UserInfo
            userInfo.name = name
            userInfo.latitude = latitude
            userInfo.longitude = longitude
            userInfo.password = password
            userInfo.price = price
            if(is_save){
                DatabaseController.saveContext()
            }
            return userInfo

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
    
    func fetchOneRestaurantFromCoreData(with name: String)->Restaurant?{
        let fetchRequest:NSFetchRequest<Restaurant> = NSFetchRequest(entityName: String(describing: Restaurant.self))
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            for i in 0..<searchResults.count{
                if(searchResults[i].name == name){
                    return searchResults[i]
                }
            }
        }catch{
            print("Error: \(error)")
            
        }
        return nil
    }
    
    func addEvaluation(resName: String, evaluation: Double){
        let mySQLOps = MySQLOps()
        mySQLOps.fetchRestaurantInfoFromMySQL(name: resName, attributeName: "evaluation"){
            evaluationBefore in
            mySQLOps.fetchRestaurantInfoFromMySQL(name: resName, attributeName: "evaluationNum"){
                evaluationNumBefore in
                let evaluationNumNew = Int(evaluationNumBefore)! + 1
                let evaluationNew = (Double(evaluationBefore)! * Double(evaluationNumBefore)! + evaluation) / Double(evaluationNumNew)
                mySQLOps.updateRestaurantToMySQL(name: resName, attributeName: "evaluation", attributeValue: String(evaluationNew))
                mySQLOps.updateRestaurantToMySQL(name: resName, attributeName: "evaluationNum", attributeValue: String(evaluationNumNew))
            }
        }
    }
    
    func downloadEvaluation(resName: String){
        let mySQLOps = MySQLOps()
        let restaurantDatabaseController = RestaurantDatabaseController()
        if let restaurant = restaurantDatabaseController.fetchOneRestaurantFromCoreData(with: resName){
            mySQLOps.fetchRestaurantInfoFromMySQL(name: resName, attributeName: "evaluation"){
                evaluation in
                restaurantDatabaseController.modifyAttribute(des: &restaurant.evaluation, src: Double(evaluation)!)
            }
            mySQLOps.fetchRestaurantInfoFromMySQL(name: resName, attributeName: "evaluationNum"){
                evaluationNum in
                restaurantDatabaseController.modifyAttribute(des: &restaurant.evaluationNum, src: Double(evaluationNum)!)
            }
        }
    }
    
    func insertImageToOneRestaurantInCoreData(img: UIImage){
        
    }
}

extension UIImageView {
    class public func imageFromServerURL(urlString: String, handler: @escaping (_ attributeValue: UIImage)->()) {
        
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                handler(image!)

            })
            
        }).resume()
    }
}


