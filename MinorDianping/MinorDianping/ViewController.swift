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
        
        let restaurants:[Restaurant] = databaseController.fetchAllObjectsFromCoreData()!
        print(restaurants[0].name!)
        for restaurant in restaurants{
            print("\(restaurant.name!) is in \(restaurant.latitude), \(restaurant.longitude)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

