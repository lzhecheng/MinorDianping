//
//  MySQLOps.swift
//  MinorDianping
//
//  Created by Apple on 2017/6/6.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation

public class MySQLOps{
    let URL_REGISTER_USERS:String = "http://104.199.144.39/MinorDianping/registerUser.php"
    let URL_FETCH_USERS:String = "http://104.199.144.39/MinorDianping/selectUser.php"
    let URL_UPDATE_USERS:String = "http://104.199.144.39/MinorDianping/updateUser.php"
    let URL_FETCH_RES:String = "http://104.199.144.39/MinorDianping/selectRestaurant.php"
    let URL_UPDATE_RES:String = "http://104.199.144.39/MinorDianping/updateRestaurant.php"
    let URL_REGISTER_RES:String = "http://104.199.144.39/MinorDianping/registerRestaurant.php"

    
    func registerNewUser(username: String, password: String, handler: @escaping (_ success: Bool)-> ()){
        var request = URLRequest(url: URL(string: URL_REGISTER_USERS)!)
        request.httpMethod = "POST"
        let postString = "username=\(username)&password=\(password)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            //print("response = \(String(describing: response))")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            do{
                let responseJSON = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                handler(responseJSON["status"]! as! String != "400")
            }
            catch{
                print(error)
            }
            print("REGISTER responseString = \(String(describing: responseString))")
        }
        task.resume();
    }
    
    func fetchUserInfoFromMySQL(username:String, attributeName:String, handler: @escaping (_ attributeValue: String?)-> ()){
        var request = URLRequest(url: URL(string: URL_FETCH_USERS)!)
        request.httpMethod = "POST"
        let getString = "username=\(username)&attributeName=\(attributeName)"
        request.httpBody = getString.data(using: String.Encoding.utf8)

        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            //exiting if there is some error
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            // parse the response
            do{
                // convert response to NSDictionary
                let userJSON = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                handler(userJSON[attributeName] as? String)

            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    func updateUserInfoToMySQL(username: String, attributeName: String, attributeValue: String, handler: @escaping (_ success: Bool)-> ()){
        var request = URLRequest(url: URL(string: URL_UPDATE_USERS)!)
        request.httpMethod = "POST"
        let getString = "username=\(username)&attributeName=\(attributeName)&attributeValue=\(attributeValue)"
        request.httpBody = getString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            do{
                let responseJSON = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                handler(responseJSON["status"]! as! String != "400")
            }
            catch{
                print(error)
            }
            print("UPDATE responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    
    func fetchRestaurantInfoFromMySQL(name:String, attributeName:String, handler: @escaping (_ attributeValue: String)-> ()){
        var request = URLRequest(url: URL(string: URL_FETCH_RES)!)
        request.httpMethod = "POST"
        let getString = "name=\(name)&attributeName=\(attributeName)"
        request.httpBody = getString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            //exiting if there is some error
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            // parse the response
            do{
                // convert response to NSDictionary
                let resJSON = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                if let ret = resJSON[attributeName]{
                    handler(ret as! String)
                }else{
                    handler("")
                }
                
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    func updateRestaurantToMySQL(name: String, attributeName: String, attributeValue: String, handler: @escaping (_ success: Bool)-> ()){
        var request = URLRequest(url: URL(string: URL_UPDATE_RES)!)
        request.httpMethod = "POST"
        let getString = "name=\(name)&attributeName=\(attributeName)&attributeValue=\(attributeValue)"
        request.httpBody = getString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            do{
                let responseJSON = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                handler(responseJSON["status"]! as! String != "400")
            }
            catch{
                print(error)
            }
            print("UPDATE responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    
    func registerNewRestaurant(resName: String, address: String, latitude: Double, longitude: Double, city: String, handler: @escaping (_ success: Bool)-> ()){
        var request = URLRequest(url: URL(string: URL_REGISTER_RES)!)
        request.httpMethod = "POST"
        let postString = "name=\(resName)&address=\(address)&latitude=\(latitude)&longitude=\(longitude)&city=\(city)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            //print("response = \(String(describing: response))")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            do{
                let responseJSON = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                handler(responseJSON["status"]! as! String != "400")
            }
            catch{
                print(error)
            }
            print("REGISTER responseString = \(String(describing: responseString))")
        }
        task.resume();
    }
}
