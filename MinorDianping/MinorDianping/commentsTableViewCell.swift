//
//  commentsTableViewCell.swift
//  MinorDianping
//
//  Created by Apple on 2017/6/12.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit

class commentsTableViewCell: UITableViewCell {

    @IBOutlet weak var userComment: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
