//
//  Restaurant+CoreDataProperties.swift
//  MinorDianping
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var address: String?
    @NSManaged public var comments: String?
    @NSManaged public var evaluation: Double
    @NSManaged public var images: NSData?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var evaluationNum: Double
    @NSManaged public var city: City?
    @NSManaged public var users: NSSet?

}

// MARK: Generated accessors for users
extension Restaurant {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: UserInfo)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: UserInfo)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}
