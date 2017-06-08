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
    var restaurants = [Restaurant]()
    var target: String = "#nothing"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set colors in button
        self.navigationController?.navigationBar.barTintColor =
            UIColor(red: 99/255, green: 6/255, blue: 95/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white

        // Load core data or load search results
        if target == "#nothing"{
            //loadSampleShops()
            loadCoreDataShops()
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
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ShopTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ShopTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ShopTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let restaurant = restaurants[indexPath.row]
        
        cell.nameLabel.text = restaurant.name
        cell.photoImageView.image = UIImage(named: "defaultPhoto")
        cell.ratingControl.rating = Int(restaurant.evaluation)
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //trigger which button
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

//    private func loadSampleShops() {
//        
//        //sameple shops
//        
//        //shop1: KFC
//        let photo1 = UIImage(named: "shop1")
//        let latitude1 = 32.1025600000
//        let longitude1 = 118.9261600000
//        let comment1 = "This is KFC and it's better than M"
//        
//        //shop2: M
//        let photo2 = UIImage(named: "shop2")
//        let latitude2 = 32.0942600000
//        let longitude2 = 118.9157500000
//        let comment2 = "This is M and it's better than Burger King"
//        
//        //shop3: Burger King
//        let photo3 = UIImage(named: "shop3")
//        let latitude3 = 32.0389900000
//        let longitude3 = 118.7830500000
//        let comment3 = "This is Burger King and it's better than KFC"
//        
//        guard let shop1 = Shop(name: "KFC", photo: photo1, latitude: latitude1, longitude: longitude1, comment: comment1) else {
//            fatalError("Unable to instantiate meal1")
//        }
//        
//        guard let shop2 = Shop(name: "M", photo: photo2, latitude: latitude2, longitude: longitude2, comment: comment2) else {
//            fatalError("Unable to instantiate meal2")
//        }
//        
//        guard let shop3 = Shop(name: "Burger King", photo: photo3, latitude: latitude3, longitude: longitude3, comment: comment3) else {
//            fatalError("Unable to instantiate meal3")
//        }
//        //shops += [shop1,shop2,shop3]
//        
//    }
    
    private func loadCoreDataShops(){
        //let cdPhoto = UIImage(named: "defaultPhoto")
        let databaseController = DatabaseController()
        let DBrestaurants: [Restaurant] = databaseController.fetchAllObjectsFromCoreData()!
        restaurants += DBrestaurants
    }
    
    private func loadSeachedShops() {
        //data from core data
        let search = searchBrain()
        let results = search.searchWords(words: target)
        restaurants += results
    }
}
