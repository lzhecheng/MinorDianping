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
    @IBOutlet weak var collection: UIBarButtonItem!
    
    var restaurant: Restaurant?
    var commentsList = [String]()
    var userNameList = [String]()
    let user = CurrentUser()
    let mySQLOps = MySQLOps()
    var collectionInString: String?
    var restaurantInCollection = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // set name, comments and evaluation
        if let restaurant = restaurant {
            // get restaurant information from Core data
            let restaurantDBC = RestaurantDatabaseController()
            let target = restaurantDBC.fetchOneRestaurantFromCoreData(with: restaurant.name!)
            
            // name
            nameLabel.text = target?.name
            
            // rating
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
            
            // display restaurant comments
            if let comment = restaurant.comments {
                print(comment)
            }
            if let everythingInComments = target?.comments{
                // use [c] to split commetns
                let CommentsAndNamesList = everythingInComments.components(separatedBy: "[c]")
                
                commentsList = []
                
                // use [n] to split name and its comment
                for CommentsAndName in CommentsAndNamesList {
                    if CommentsAndName != "" {
                        let can = CommentsAndName.components(separatedBy: "[n]")
                        commentsList += [can[0]]
                        userNameList += [can[1]]
                    }
                }
            }
        }
        
        // determine LIKE status
        if user.getIfFormal() == true {
            if user.ifRestaurantInCollection(name: (restaurant?.name)!) {
                collection.image = UIImage(named: "filledLike")
                restaurantInCollection = true
            } else {
                self.collection.image = UIImage(named: "like")
                restaurantInCollection = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
    
    
    @IBAction func collectionButton(_ sender: UIBarButtonItem) {
        if user.getIfFormal() {
            if !restaurantInCollection {
                user.addRestaurantCollection(name: (restaurant?.name)!)
                alert(title: "收藏", message: "收藏成功！", succeed: true)
                collection.image = UIImage(named: "filledLike")
            } else {
                user.removeRestaurantCollection(name: (restaurant?.name)!)
                alert(title: "取消收藏", message: "取消收藏成功!", succeed: true)
                collection.image = UIImage(named: "like")
            }
        } else {
            alert(title: "收藏失败", message: "抱歉，只有用户才可以收藏", succeed: true)
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
