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
        // set name, comments and evaluation
        if let restaurant = restaurant {
            let restaurantDBC = RestaurantDatabaseController()
            let target = restaurantDBC.fetchOneRestaurantFromCoreData(with: restaurant.name!)
            
            nameLabel.text = target?.name
            commentLabel.text = target?.comments
            ratingControl.rating = Int((target?.evaluation)!)
            
            // display image
            let mySQLOps = MySQLOps()
            mySQLOps.fetchRestaurantInfoFromMySQL(name: "Restaurant Familiar El Chino", attributeName: "imagePath"){
                imagePath in
                UIImageView.imageFromServerURL(urlString: imagePath){
                    image in
                    self.photoImageView.image = image
                }
            }
        }
        
        // multiline display
        commentLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        commentLabel.numberOfLines = 0
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
