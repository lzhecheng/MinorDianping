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
    static var ifFormalUser = false
    
//    static var nextTitle = ""
//    static var nextMessage = ""
    
    func getUserName() -> String{
        return CurrentUser.userName
    }

    func getIfFormal() -> Bool{
        return CurrentUser.ifFormalUser
    }
    
    func getRestaurantCollection() -> [String]{
        return CurrentUser.restaurantCollection
    }

//    func getAlert() -> (String, String){
//        return (CurrentUser.nextTitle, CurrentUser.nextMessage)
//    }
//    
//    func setAlert(success: Bool) {
//        if success {
//            CurrentUser.nextTitle = "注册成功！"
//            CurrentUser.nextMessage = "欢迎来到小众点评，\(CurrentUser.userName)"
//        } else {
//            CurrentUser.nextTitle = "注册失败！"
//            CurrentUser.nextMessage = "用户名已被使用"
//        }
//    }
//    func getNextTitle() ->String {
//        return CurrentUser.nextTitle
//    }
//    
//    func getNextMessage() ->String {
//        return CurrentUser.nextMessage
//    }
//    
//    func setNextTitle(title: String) {
//        CurrentUser.nextTitle = title
//    }
//    
//    func setNextMessge(message: String) {
//        CurrentUser.nextMessage = message
//    }
    
    func changeUserName(name: String) {
        // change name, set lcoal collection, set if current user is a formal one
        CurrentUser.userName = name
        CurrentUser.ifFormalUser = true
        setRestaurantCollection()
    }
    
    func setRestaurantCollection() {
        // set restaurant collection
        mySQLOps.fetchUserInfoFromMySQL(username: CurrentUser.userName, attributeName: "collection"){
            ret in
            var nameList = [String]()
            
            if let collectionInString = ret {
                nameList = collectionInString.components(separatedBy: "[n]")
            }
            
            // remove the back empty String and the front one
            nameList.remove(at: nameList.count - 1)
            nameList.remove(at: 0)
            
            CurrentUser.restaurantCollection = nameList
        }
    }
    
    func uploadRestaurantCollection() {
        var upload = "[n]"
        //print(CurrentUser.restaurantCollection.count)

        for each in CurrentUser.restaurantCollection {
            upload += each + "[n]"
        }
        
        mySQLOps.updateUserInfoToMySQL(username: CurrentUser.userName, attributeName: "collection", attributeValue: upload) {success in}
    }

    func addRestaurantCollection(name: String){
        // add the restaurant into the list
        CurrentUser.restaurantCollection += [name]
        
        uploadRestaurantCollection()
    }
    
    func removeRestaurantCollection(name: String){
        // find the restaurant and remove it
        for i in 0..<CurrentUser.restaurantCollection.count {
            if CurrentUser.restaurantCollection[i] == name {
                CurrentUser.restaurantCollection.remove(at: i)
                break
            }
        }
        
        uploadRestaurantCollection()
    }
    
    func ifRestaurantInCollection(name: String) -> Bool {
        if CurrentUser.restaurantCollection.contains(name) {
            return true
        } else {
            return false
        }
        
//        for restaurant in CurrentUser.restaurantCollection {
//            if name == restaurant {
//                return true
//            }
//        }
//        
//        return false
    }
}
