//
//  UserInfo+CoreDataProperties.swift
//  MinorDianping
//
//  Created by Apple on 2017/5/25.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func userInfoFetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo");
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var city: String?
    @NSManaged public var password: String?
    @NSManaged public var taste: String?
    @NSManaged public var restaurants: NSSet?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}

// MARK: Generated accessors for restaurants
extension UserInfo {

    @objc(addRestaurantsObject:)
    @NSManaged public func addToRestaurants(_ value: Restaurant)

    @objc(removeRestaurantsObject:)
    @NSManaged public func removeFromRestaurants(_ value: Restaurant)

    @objc(addRestaurants:)
    @NSManaged public func addToRestaurants(_ values: NSSet)

    @objc(removeRestaurants:)
    @NSManaged public func removeFromRestaurants(_ values: NSSet)

}
