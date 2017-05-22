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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // MARK: - Core Data operation
        let cityClassName:String = String(describing: City.self)
        let restaurantClassName:String = String(describing: Restaurant.self)
        
        let restaurant:Restaurant = NSEntityDescription.insertNewObject(forEntityName: restaurantClassName, into: DatabaseController.getContext()) as! Restaurant
        restaurant.location = "Xianlin"
        restaurant.name = "KFC"
        
        let city:City = NSEntityDescription.insertNewObject(forEntityName: cityClassName, into: DatabaseController.getContext()) as! City
        city.cityName = "Nanjing"
        city.addToRestaurants(restaurant)
        

        DatabaseController.saveContext()
        
        let fetchRequest:NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            print("number of results: \(searchResults.count)")
            
            for result in searchResults as [Restaurant]{
                print("\(result.name!) is in \(result.location!) of \(result.city!.cityName!).")
            }
            
        }
        catch{
            print("Error: \(error)")
        }
        
        DatabaseController.getContext().delete(city)
        DatabaseController.getContext().delete(restaurant)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

