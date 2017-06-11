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

    override func viewDidLoad() {
        super.viewDidLoad()
        // set name, image, comments and evaluation
        if let restaurant = restaurant {
            let restaurantDBC = RestaurantDatabaseController()
            let target = restaurantDBC.fetchOneRestaurantFromCoreData(with: restaurant.name!)
            
            navigationItem.title = target?.name
            //photoImageView.image = UIImage()
            nameLabel.text = target?.name
            commentLabel.text = target?.comments
            ratingControl.rating = Int((target?.evaluation)!)
        
//            navigationItem.title = restaurant.name
//            nameLabel.text = restaurant.name
//            commentLabel.text = restaurant.comments
//            print(restaurant.evaluation)
//            ratingControl.rating = Int(restaurant.evaluation)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
}
