//
//  UserInfo+CoreDataClass.swift
//  MinorDianping
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation
import CoreData
#import <CommonCrypto/CommonCrypto.h>

@objc(UserInfo)
public class UserInfo: NSManagedObject {
    public func validatePassword(username: String, password: String) -> Bool{
        let mySQLOps = MySQLOps()
        mySQLOps.fetchUserInfoFromMySQL(username: username, attributeName: "salt"){
            salt in
            mySQLOps.fetchUserInfoFromMySQL(username: username, attributeName: "password"){
                pass in
                
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
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
