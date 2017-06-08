//
//  ShopTableViewController.swift
//  MinorDianping
//
//  Created by Apple on 17/5/19.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit
import os.log
import CoreData

class ShopTableViewController: UITableViewController {
    
    //MARK: Properties
    var shops = [Shop]()
    var target: String = "#nothing"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set naviation bar color & word color & word color in button
        self.navigationController?.navigationBar.barTintColor =
            UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white

        // Load sample data or load search results
        if target == "#nothing"{
            loadSampleShops()
        }else {
            loadSeachedShops()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shops.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ShopTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ShopTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ShopTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let shop = shops[indexPath.row]
        
        cell.nameLabel.text = shop.name
        cell.photoImageView.image = shop.photo
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            case "ShopChosen":
                guard let shopDetailViewController = segue.destination as? ShopViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedShopCell = sender as? ShopTableViewCell else {
                    fatalError("Unexpected sender: \(sender)")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedShopCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedShop = shops[indexPath.row]
                shopDetailViewController.shop = selectedShop
            
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }

    private func loadSampleShops() {
        //sameple shops
        
        //shop1: KFC
        let photo1 = UIImage(named: "shop1")
        let latitude1 = 32.1025600000
        let longitude1 = 118.9261600000
        let comment1 = "This is KFC and it's better than M"
        
        //shop2: M
        let photo2 = UIImage(named: "shop2")
        let latitude2 = 32.0942600000
        let longitude2 = 118.9157500000
        let comment2 = "This is M and it's better than Burger King"
        
        //shop3: Burger King
        let photo3 = UIImage(named: "shop3")
        let latitude3 = 32.0389900000
        let longitude3 = 118.7830500000
        let comment3 = "This is Burger King and it's better than KFC"
        
        guard let shop1 = Shop(name: "KFC", photo: photo1, latitude: latitude1, longitude: longitude1, comment: comment1) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let shop2 = Shop(name: "M", photo: photo2, latitude: latitude2, longitude: longitude2, comment: comment2) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let shop3 = Shop(name: "Burger King", photo: photo3, latitude: latitude3, longitude: longitude3, comment: comment3) else {
            fatalError("Unable to instantiate meal3")
        }
        shops += [shop1,shop2,shop3]
        let mySQLOps = MySQLOps()
        
        let cdPhoto = UIImage(named: "defaultPhoto")
        let databaseController = RestaurantDatabaseController()
        databaseController.addEvaluation(resName: "Restaurant Familiar El Chino", evaluation: 3)
        let res = databaseController.fetchOneRestaurantFromCoreData(with: "Restaurant Familiar El Chino")!
        print("\(res.name!) \(res.evaluation) with \(res.evaluationNum)")
        databaseController.downloadEvaluation(resName: "Restaurant Familiar El Chino")
        print("\(res.name!) \(res.evaluation) with \(res.evaluationNum)")

//        databaseController.createNewRestaurant(name: "a", address: "b", cityName: "c", latitude: 1, longitude: 2, is_save: true)
//        databaseController.createNewCity(cityName: "Nanjing", is_save: true)
//        let users: [UserInfo] = databaseController.fetchAllObjectsFromCoreData()!
//        print("\(users[0].name!) is in \(users[0].longitude), \(users[0].latitude)")
//        let cities: [City] = databaseController.fetchAllObjectsFromCoreData()!
//        for i in 0..<cities.count{
//            print(cities[i].cityName!)
//        }

        let restaurants: [Restaurant] = databaseController.fetchAllObjectsFromCoreData()!
        databaseController.modifyAttribute(des: &restaurants[0].name, src: "cs")
        for i in 0..<restaurants.count {
            let shop = Shop(name: restaurants[i].name!, photo: cdPhoto, latitude: restaurants[i].latitude, longitude: restaurants[i].longitude, comment: "")!
            shops += [shop]
        }
    }
    
    private func loadSeachedShops() {
        //data from core data
        let search = searchBrain()
        let results = search.searchWords(words: target)
        shops += results
    }
}
