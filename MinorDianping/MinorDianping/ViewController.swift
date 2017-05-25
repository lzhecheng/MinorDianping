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
        
        let cities: [City] = restaurantDatabaseController.fetchAllObjectsFromCoreData()!
        for city in cities{
            print("City \(city.cityName!)")
        }
        
        let restaurants:[Restaurant] = restaurantDatabaseController.fetchAllObjectsFromCoreData()!
        for restaurant in restaurants{
            print("No.\(restaurant.placeID!) \(restaurant.name!) is in \(restaurant.city!.cityName!) \(restaurant.latitude), \(restaurant.longitude)")
        }
        print("Restaurant Num is \(restaurants.count)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

