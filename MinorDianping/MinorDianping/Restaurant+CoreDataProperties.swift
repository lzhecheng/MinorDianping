//
//  Restaurant+CoreDataProperties.swift
//  MinorDianping
//
//  Created by Apple on 2017/5/18.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant");
    }

    @NSManaged public var name: String?
    @NSManaged public var location: String?
    @NSManaged public var city: City?

}
