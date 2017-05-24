//
//  ViewController.swift
//  MinorDianping
//
//  Created by Apple on 2017/4/24.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    let WHETHER_INIT_DB = false
    let WHETHER_CLEAR = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let databaseController = DatabaseController()
        
        let restaurants = databaseController.fetchAllRestaurantsFromCoreData()!
        for restaurant in restaurants{
            print("\(restaurant.name!) is in \(restaurant.latitude), \(restaurant.longitude)")
        }
        
//        if(WHETHER_INIT_DB){
//            // MARK: CSV File Operations
//            let csvHelper = CSVHelper()
//            let file:String = csvHelper.readDataFromFile(file: "mexico", type: "csv")
//            
//            guard let contents:[[String:String]] = csvHelper.convertCSV(file: file)else {
//                print("Parse Successfully")
//                return
//            }
//            
//            let numOfRestaurants = contents.count
//            
//            // MARK: - Core Data Operations
//            let cityClassName:String = String(describing: City.self)
//            let restaurantClassName:String = String(describing: Restaurant.self)
//            let stateClassName:String = String(describing: State.self)
//            
////            let city:City = NSEntityDescription.insertNewObject(forEntityName: cityClassName, into: DatabaseController.getContext()) as! City
////            var cityNames:Set<String> = Set()
////            for i in 0 ..< numOfRestaurants{
////                cityNames.insert(contents[i]["city"]!)
////            }
////            for cityName in cityNames{
////                city.cityName = cityName
////            }
//            
//            for i in 1 ..< numOfRestaurants{
//                let restaurant:Restaurant = NSEntityDescription.insertNewObject(forEntityName: restaurantClassName, into: DatabaseController.getContext()) as! Restaurant
//                restaurant.name = contents[i]["name"]
//                restaurant.address = contents[i]["address"]
//                restaurant.latitude = Double(contents[i]["latitude"]!)!
//                restaurant.longitude = Double(contents[i]["longitude"]!)!
//                //restaurant.placeID = contents[i]["placeID"]! as! Int16
//                //city.addToRestaurants(restaurant)
//            }
//            
//            DatabaseController.saveContext()
//            print("Saved!")
//        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

