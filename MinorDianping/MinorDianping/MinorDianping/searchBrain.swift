//
//  searchBrain.swift
//  MinorDianping
//
//  Created by Apple on 17/5/25.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation
import UIKit

class searchBrain{
    var restaurantDictionary: Dictionary<String, [Int]>
    let restaurants: [Restaurant]
    
    init(){
        //init dictionary
        restaurantDictionary = Dictionary()
        
        //load database
        let databaseController = DatabaseController()
        restaurants = databaseController.fetchAllObjectsFromCoreData()!
        
        //build restaurantDictionary
        for i in 0..<restaurants.count{
            let nameSplited: [String] = restaurants[i].name!.components(separatedBy: " ")
            for divider in nameSplited{
                if var val = restaurantDictionary[divider] {
                    val += [i]
                    restaurantDictionary[divider] = val
                }else{
                    restaurantDictionary[divider] = [i]
                }
            }
        }
    }
    
    public func searchWords(words: String) -> [Shop]{
        var results = Set<Int>()
        let wordsSplited: [String] = words.components(separatedBy: " ")
        for word in wordsSplited{
            if let val = restaurantDictionary[word] {
                for each in val{
                    results.insert(each)
                }
            }
        }

        let finalResults = Array(results)
        let cdPhoto = UIImage(named: "defaultphoto_2x.png")
        var shops = [Shop]()
        for i in finalResults {
            let shop = Shop(name: restaurants[i].name!, photo: cdPhoto, latitude: restaurants[i].latitude, longitude: restaurants[i].longitude, comment: "")!
            shops += [shop]
        }
        
        return shops
    }
}
