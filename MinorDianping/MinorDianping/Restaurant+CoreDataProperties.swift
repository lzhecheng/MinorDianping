//
//  Restaurant+CoreDataProperties.swift
//  MinorDianping
//
//  Created by Apple on 2017/5/25.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func restaurantFetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant");
    }

    @NSManaged public var address: String?
    @NSManaged public var evaluation: Int16
    @NSManaged public var images: NSData?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var placeID: String?
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
