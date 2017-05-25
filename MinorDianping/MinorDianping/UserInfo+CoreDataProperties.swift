//
//  UserInfo+CoreDataProperties.swift
//  MinorDianping
//
//  Created by Apple on 2017/5/25.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

extension UserInfo {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo");
    }
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var city: String?
    @NSManaged public var password: String?
    @NSManaged public var taste: String?
}
