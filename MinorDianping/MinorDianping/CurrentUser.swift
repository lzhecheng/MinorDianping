//
//  CurrentUser.swift
//  MinorDianping
//
//  Created by Apple on 2017/6/12.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation

class CurrentUser{
    let mySQLOps = MySQLOps()
    
    static var userName = "游客"
    static var restaurantCollection = [String]()
    
    func getUserName() -> String{
        return CurrentUser.userName
    }
    
    func changeUserName(name: String) {
        CurrentUser.userName = name
        
        // set restaurant collection
        var nameList = [String]()
        mySQLOps.fetchUserInfoFromMySQL(username: CurrentUser.userName, attributeName: "collection"){
            ret in
            if let collectionInString = ret{
                nameList = collectionInString.components(separatedBy: "<n>")
            }
        }
        CurrentUser.restaurantCollection = nameList
    }
    
    func getRestaurantCollection() -> [String]{
        return CurrentUser.restaurantCollection
    }
    
    func addRestaurantCollection(name: String){
        // get collection string
        var collectionInString: String?
        mySQLOps.fetchUserInfoFromMySQL(username: CurrentUser.userName, attributeName: "collection"){
            ret in
            collectionInString = ret
        }
//        print(CurrentUser.userName)
//        print(collectionInString)
        
        if collectionInString == nil {
            collectionInString = name + "<n>"
        } else {
            collectionInString = collectionInString! + name + "<n>"
        }
        
//        print(collectionInString)
        
        mySQLOps.updateUserInfoToMySQL(username: CurrentUser.userName, attributeName: "collection", attributeValue: collectionInString!) {success in}
    }
    
    func removeRestaurantCollection(name: String){
        //get collection string
        var collectionInString: String = ""
        mySQLOps.fetchUserInfoFromMySQL(username: CurrentUser.userName, attributeName: "collection"){
            ret in
            collectionInString = ret!
        }
        
        let range = collectionInString.range(of: name + "<n>")
        collectionInString.removeSubrange(range!)
        
        mySQLOps.updateUserInfoToMySQL(username: CurrentUser.userName, attributeName: "collection", attributeValue: collectionInString) {success in}
        
    }
    
    func ifRestaurantInCollection(name: String) -> Bool {
        // get collection string
        var collectionInString = ""
        mySQLOps.fetchUserInfoFromMySQL(username: CurrentUser.userName, attributeName: "collection"){
            ret in
            collectionInString = ret!
        }
        
        if collectionInString.contains(name) {
            return true
        } else {
            return false
        }
    }
}
