//
//  RecommendationEngine.swift
//  MinorDianping
//
//  Created by Apple on 2017/6/13.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation

class RecommendationEngine{
    var restaurants: [Restaurant]
    var user: UserInfo
    init(restaurants: [Restaurant], user: UserInfo){
        self.restaurants = restaurants
        self.user = user
    }
    
    private func evaluate(){
        for i in 0 ..< restaurants.count{
            restaurants[i].point = restaurants[i]
        }
    }
}
