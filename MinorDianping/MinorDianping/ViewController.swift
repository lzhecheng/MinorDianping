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

        let restaurantDatabaseController = RestaurantDatabaseController()
        
        let cities:[City] = restaurantDatabaseController.fetchAllObjectsFromCoreData()!
        let restaurantsOfOneCity = cities[0].restaurants
        
        for restaruantOfOneCity in restaurantsOfOneCity!{
            print(restaruantOfOneCity)
        }
        
        restaurantDatabaseController.createNewRestaurant(name: "Guojiadayuan", address: "NJU", cityName: "Nanjing", latitude: 34, longitude: 68,is_save: true)
        
        let restaurants:[Restaurant] = restaurantDatabaseController.fetchAllObjectsFromCoreData()!
        restaurantDatabaseController.modifyAttribute(des: &restaurants[130].latitude, src: 25)
        restaurantDatabaseController.modifyAttribute(des: &restaurants[130].name, src: "HuangMenJi")
        
        
        for restaurant in restaurants{
            print("\(restaurant.name!) is in \(restaurant.latitude), \(restaurant.longitude)")
        }
        print("Restaurant Num is \(restaurants.count)")
        print("City Num is \(cities.count)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

