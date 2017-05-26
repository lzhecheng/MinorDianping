//
//  CityDatabaseController.swift
//  MinorDianping
//
//  Created by Apple on 2017/5/25.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation
import CoreData

class CityDatabaseController: DatabaseController{
    class func fetchOneCityFromCoreData(name: String) -> City?{
        let fetchRequest = NSFetchRequest<City>(entityName: "City");
        do{
            let cities = try DatabaseController.getContext().fetch(fetchRequest)
            for city in cities{
                if city.cityName == name{
                    return city
                }
            }
        }catch{
            print("Error: \(error)")
        }
        return nil
    }
}
