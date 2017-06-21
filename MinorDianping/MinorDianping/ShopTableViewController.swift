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
    
    @IBOutlet weak var shopTableView: UITableView!
    
    //MARK: Properties
    var restaurants = [Restaurant]()
    var target: String = "#nothing"
    var switchType: Int = 0
    let user = CurrentUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set colors of navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 99/255, green: 6/255, blue: 95/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white

        // Load core data or load search results
        if target == "#nothing"{
            loadCoreDataShops()
        }else if target == "myCollections"{
            loadMyCollection()
        }else {
            loadSearchedShops()
        }
        
        if user.getIfFormal() {
            user.setRestaurantCollection()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ShopTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ShopTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ShopTableViewCell.")
        }
        
        // Fetches the appropriate restaurant for the data source layout.
        let restaurant = restaurants[indexPath.row]
        
        //image
        let mySQLOps = MySQLOps()

        mySQLOps.fetchRestaurantInfoFromMySQL(name: restaurant.name!, attributeName: "imagePath"){
            imagePath in
            UIImageView.imageFromServerURL(urlString: imagePath){
                image in
                cell.photoImageView.image = image
            }
        }

        //set name, evaluation, other information
        cell.nameLabel.text = restaurant.name
        cell.ratingControl.rating = Int(restaurant.evaluation)
        let evaluation2digit = String(format: "%.2f", restaurant.evaluation)
        cell.otherInfo.text = "详细评分：\(evaluation2digit) 评分人数：\(Int(restaurant.evaluationNum))"   
        return cell
    }

    // MARK: - Navigation
    //update info after commenting
    @IBAction func unwindToShopTable(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CommentShopViewController, let commentRestaurant = sourceViewController.restaurant {
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                restaurants[selectedIndexPath.row] = commentRestaurant
                print(restaurants[selectedIndexPath.row].evaluation)
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
        }
    }
    
    //send info to ShopViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //which button
        switch(segue.identifier ?? "") {
            case "ShopChosen":
                guard let shopDetailViewController = segue.destination as? ShopViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedShopCell = sender as? ShopTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedShopCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedRestaurants = restaurants[indexPath.row]
                shopDetailViewController.restaurant = selectedRestaurants

            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    private func loadCoreDataShops(){
        let databaseController = RestaurantDatabaseController()
        let DBrestaurants: [Restaurant] = databaseController.fetchAllObjectsFromCoreData()!
        
        // make core data same with data from server
        let mySQLOps = MySQLOps()
        for i in 0..<DBrestaurants.count {
            mySQLOps.fetchRestaurantInfoFromMySQL(name: DBrestaurants[i].name!, attributeName: "comments") {
                success in
                if success != ""{
                    DBrestaurants[i].comments = String(success)
                }
            }
            
            mySQLOps.fetchRestaurantInfoFromMySQL(name: DBrestaurants[i].name!, attributeName: "evaluation") {
                success in
                if success != "" {
                    DBrestaurants[i].evaluation = Double(success)!
                }
            }
            
            mySQLOps.fetchRestaurantInfoFromMySQL(name: DBrestaurants[i].name!, attributeName: "evaluationNum") {
                success in
                if success != "" {
                    DBrestaurants[i].evaluationNum = Double(success)!
                }
            }
        }
        restaurants += DBrestaurants
    }
    
    private func loadSearchedShops() {
        let search = searchBrain()
        var results: [Restaurant]?
        if target != "" {
            if switchType == 1 {
                results = search.searchWords(words: target)
            } else {
                results = search.searchWords2(words: target)
            }
        } else {
            results = []
        }

        restaurants += results!
    }
    
    private func loadMyCollection() {
        let myCollections = user.getRestaurantCollection()
        let databaseController = RestaurantDatabaseController()
        let DBrestaurants: [Restaurant] = databaseController.fetchAllObjectsFromCoreData()!
        
        // put collections input restaurants
        if myCollections.count != 0 {
            for name in myCollections {
                for shop in DBrestaurants {
                    if name == shop.name {
                        restaurants += [shop]
                    }
                }
            }
        }
    }
    
    // Alert message
    func alert(title: String, message: String, succeed: Bool){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
