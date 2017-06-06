//
//  ShopTableViewController.swift
//  MinorDianping
//
//  Created by Apple on 17/5/19.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit
import os.log

class ShopTableViewController: UITableViewController {

    
    //MARK: Properties
    var shops = [Shop]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the sample data.
        loadSampleShops()
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
            
            //case "AddItem":
                //os_log("Adding a new meal.", log: OSLog.default, type: .debug)
                
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
        
        let photo1 = UIImage(named: "shop1")
        let photo2 = UIImage(named: "shop2")
        let photo3 = UIImage(named: "shop3")
        
        guard let shop1 = Shop(name: "KFC", photo: photo1) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let shop2 = Shop(name: "M", photo: photo2) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let shop3 = Shop(name: "Burger King", photo: photo3) else {
            fatalError("Unable to instantiate meal3")
        }
        
        shops += [shop1,shop2,shop3]
    }
    /*
    private func saveShops() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Shop.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Shops successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save shops...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadShops() -> [Shop]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Shop.ArchiveURL.path) as? [Shop]
    }
 */
    
}
