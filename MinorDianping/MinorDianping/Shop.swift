//
//  Shop.swift
//  MinorDianping
//
//  Created by Apple on 17/5/19.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Shop{
    
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var comment: String
    var evaluation: Double
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let comment = "comment"
        static let evaluation = "evalutation"
    }
    
    //MARK: Initialization
    init?(name: String, photo: UIImage?, comment: String, evaluation: Double) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.comment = comment
        self.evaluation = evaluation
    }
}
