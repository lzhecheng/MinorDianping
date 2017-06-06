//
//  MySQLOps.swift
//  MinorDianping
//
//  Created by Apple on 2017/6/6.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation

public class MySQLOps{
    let URL_REGISTER_USERS:String = "http://104.199.144.39/MinorDianping/register.php"
    let URL_FETCH_USERS:String = "http://104.199.144.39/MinorDianping/select.php"
    let URL_UPDATE_USERS:String = "http://104.199.144.39/MinorDianping/update.php"

    func registerNewUser(username: String, password: String, email: String, fullname: String){
        var request = URLRequest(url: URL(string: URL_REGISTER_USERS)!)
        request.httpMethod = "POST"
        let postString = "username=\(username)&password=\(password)&email=\(email)&fullname=\(fullname)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            //print("response = \(String(describing: response))")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("REGISTER responseString = \(String(describing: responseString))")
        }
        task.resume();
    }
    
    func fetchUserInfoFromMySQL(username:String, attributeName:String){
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
                print("SELECT \(String(describing: userJSON[attributeName]))")

            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    func updateUserInfoToMySQL(username: String, attributeName: String, attributeValue: String){
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
            print("UPDATE responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
}
