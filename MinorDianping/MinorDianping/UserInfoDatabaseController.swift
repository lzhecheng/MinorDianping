//
//  UserInfoDatabaseController.swift
//  MinorDianping
//
//  Created by Apple on 2017/5/25.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation
import CoreData

class UserInfoDatabaseController : DatabaseController{
    func registerNewUser(username: String, password: String, email: String, fullname: String){
        var request = URLRequest(url: URL(string: "http://104.199.144.39/MinorDianping/register.php")!)
        request.httpMethod = "POST"
        let postString = "username=\(username)&password=\(password)&email=\(email)&fullname=\(fullname)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request){
                data, response, error in
                if error != nil {
                    print("error=\(error)")
                    return
                }
                print("response = \(response)")
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(responseString)")
            }
        task.resume();
    }
}
