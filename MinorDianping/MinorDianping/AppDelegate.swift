//
//  AppDelegate.swift
//  MinorDianping
//
//  Created by Apple on 2017/4/24.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if(!UserDefaults.standard.bool(forKey: "launched")){
            UserDefaults.standard.set(true, forKey: "launched")
            UserDefaults.standard.set(true, forKey: "first")
            let WHETHER_CLEAR = true
            let WHETHER_INIT = true
            let restaurantDBCon = RestaurantDatabaseController()
            if(WHETHER_CLEAR){
                guard restaurantDBCon.deleteAllObjectsInCoreData(type: Restaurant.self) else{
                    print("Database init: Failed to delete past database")
                    return false
                }
            }
            if(WHETHER_INIT){
                // MARK: CSV File Operations
                let csvHelper = CSVHelper()
                let file:String = csvHelper.readDataFromFile(file: "mexico", type: "csv")
                
                guard let contents:[[String:String]] = csvHelper.convertCSV(file: file)else {
                    print("Database init: Failed to parse successfully")
                    return false
                }
                
                let numOfRestaurants = contents.count
                
                // MARK: - Core Data Operations
                
                for i in 1 ..< numOfRestaurants{
                    _ = restaurantDBCon.createNewRestaurant(name: contents[i]["name"]!, address: contents[i]["address"]!, cityName: contents[i]["city"]!, latitude: Double(contents[i]["latitude"]!)!, longitude: Double(contents[i]["longitude"]!)!, is_save: false)
                }
                DatabaseController.saveContext()
                print("Database init: Save database successfully")
            }
        }else{
            UserDefaults.standard.set(false, forKey: "first")
            print("unfirst")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        DatabaseController.saveContext()
    }

 
}

