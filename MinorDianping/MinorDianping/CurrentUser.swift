//
//  CurrentUser.swift
//  MinorDianping
//
//  Created by Apple on 2017/6/12.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation

class CurrentUser{
    static var userName = "游客"
    
//    init() {
//        CurrentUser.userName = "游客"
//    }
    
    func getUserName() -> String{
        return CurrentUser.userName
    }
    
    func changeUserName(name: String) {
        CurrentUser.userName = name
    }
}
