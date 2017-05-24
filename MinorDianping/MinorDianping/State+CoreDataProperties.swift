//
//  State+CoreDataProperties.swift
//  MinorDianping
//
//  Created by Apple on 2017/5/23.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation
import CoreData


extension State {

    @nonobjc public class func stateFetchRequest() -> NSFetchRequest<State> {
        return NSFetchRequest<State>(entityName: "State");
    }

    @NSManaged public var stateName: String?
    @NSManaged public var restaurants: NSSet?

}

// MARK: Generated accessors for restaurants
extension State {

    @objc(addRestaurantsObject:)
    @NSManaged public func addToRestaurants(_ value: Restaurant)

    @objc(removeRestaurantsObject:)
    @NSManaged public func removeFromRestaurants(_ value: Restaurant)

    @objc(addRestaurants:)
    @NSManaged public func addToRestaurants(_ values: NSSet)

    @objc(removeRestaurants:)
    @NSManaged public func removeFromRestaurants(_ values: NSSet)

}
