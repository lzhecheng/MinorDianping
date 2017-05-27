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
    //restaurant dictionary & restaurants from core data
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
            let nameSplited: [String] = (restaurants[i].name?.lowercased().components(separatedBy: " "))!
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
        //get all words in the input
        let wordsSplited: [String] = words.components(separatedBy: " ")
        var allSets: [Set<Int>] = []
        //get restaurants' names of each word
        for word in wordsSplited{
            var result = Set<Int>()
            if let val = restaurantDictionary[word] {
                for each in val{
                    result.insert(each)
                }
            }
            allSets += [result]
        }
        //get the intersection of these restaurant name sets
        if allSets.count == 0 {
            return []
        }
        var finalSet = allSets[0]
        for i in 1..<allSets.count{
            finalSet = finalSet.intersection(allSets[i])
        }

        //set shops using those restaurants
        let finalResults = Array(finalSet)
        let cdPhoto = UIImage(named: "defaultPhoto")
        var shops = [Shop]()
        for i in finalResults {
            let shop = Shop(name: restaurants[i].name!, photo: cdPhoto, latitude: restaurants[i].latitude, longitude: restaurants[i].longitude, comment: "")!
            shops += [shop]
        }
        
        return shops
    }
}
