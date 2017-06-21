//
//  UserInfoDatabaseController.swift
//  MinorDianping
//
//  Created by Apple on 2017/5/25.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation
import CoreData

//class UserInfoDatabaseController : DatabaseController{
//    public func validatePassword(username: String, password: String, handler: @escaping (_ success: Bool)-> ()){
//        let mySQLOps = MySQLOps()
//        mySQLOps.fetchUserInfoFromMySQL(username: username, attributeName: "password"){
//            pass in
//            let passToString = pass! as NSString
//            let subPass = passToString.substring(to: 40)
//            let inputPassToSha1 = password.sha1() as NSString
//            let subInputPassToSha1 = inputPassToSha1.substring(to: 40)
//            
//            handler(subPass == subInputPassToSha1)
//        }
//    }
//}


class UserInfoDatabaseController : DatabaseController{
    public func validatePassword(username: String, password: String, handler: @escaping (_ success: Bool)-> ()){
        let mySQLOps = MySQLOps()
        mySQLOps.fetchUserInfoFromMySQL(username: username, attributeName: "password"){
            pass in
            if let passUnWarpped = pass{
                let passToString = passUnWarpped as NSString
                let subPass = passToString.substring(to: 40)
                let inputPassToSha1 = password.sha1() as NSString
                let subInputPassToSha1 = inputPassToSha1.substring(to: 40)
                
                handler(subPass == subInputPassToSha1)
            }
            else{
                print("user \(username) Yeah!")
                handler(false)
            }
        }
    }
}

extension String {
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        //return Data(bytes: digest).base64EncodedString()
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}


