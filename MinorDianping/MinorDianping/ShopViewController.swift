//
//  ShopViewController.swift
//  MinorDianping
//
//  Created by Apple on 17/5/10.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit
import os.log

class ShopViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    
    var restaurant: Restaurant?
    var restaurantIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let restaurant = restaurant {
            let databaseController = DatabaseController()
            let DBrestaurants: [Restaurant] = databaseController.fetchAllObjectsFromCoreData()!
            
            navigationItem.title = DBrestaurants[restaurantIndex!].name
            //photoImageView.image = UIImage()
            nameLabel.text = DBrestaurants[restaurantIndex!].name
            commentLabel.text = DBrestaurants[restaurantIndex!].comments
            ratingControl.rating = Int(DBrestaurants[restaurantIndex!].evaluation)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
                
            case "ShopChosen2":
                guard let MapDetailViewController = segue.destination as? MapViewController else {
                    fatalError("Unexpected destination")
                }
                
                MapDetailViewController.restaurant = restaurant
            
            case "AddComment":
                guard let commentShopViewController = segue.destination as? CommentShopViewController else {
                    fatalError("Unexpected destination")
                }
                
                commentShopViewController.restaurant = restaurant
                commentShopViewController.restaurantIndex = restaurantIndex
            
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
 
}
