//
//  ShopViewController.swift
//  MinorDianping
//
//  Created by Apple on 17/5/10.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit
import os.log

class ShopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    var restaurant: Restaurant?
    var commentsList = [String]()
    var userNameList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // set name, comments and evaluation
        if let restaurant = restaurant {
            // get restaurant information from Core data
            let restaurantDBC = RestaurantDatabaseController()
            let target = restaurantDBC.fetchOneRestaurantFromCoreData(with: restaurant.name!)
            
            // name, rating
            nameLabel.text = target?.name
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
            
            if let comment = restaurant.comments {
                print(comment)
            }
            if let everythingInComments = target?.comments{
                // use <c> to split commetns
                let CommentsAndNamesList = everythingInComments.components(separatedBy: "<c>")
                
                commentsList = []
                
                // use <n> to split name and its comment
                for CommentsAndName in CommentsAndNamesList {
                    if CommentsAndName != "" {
                        let can = CommentsAndName.components(separatedBy: "<n>")
                        commentsList += [can[0]]
                        userNameList += [can[1]]
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsList.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! commentsTableViewCell
        cell.userName.text = userNameList[indexPath.row]
        cell.userComment.text = commentsList[indexPath.row]
        
        return cell
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
