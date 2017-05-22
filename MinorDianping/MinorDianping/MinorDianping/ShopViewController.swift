//
//  ShopViewController.swift
//  MinorDianping
//
//  Created by Apple on 17/5/10.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    var shop: Shop?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let shop = shop {
            navigationItem.title = shop.name
            photoImageView.image = shop.photo
            nameLabel.text=shop.name
            commentLabel.text = shop.comment
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
                
            case "ShopChosen2":
                guard let MapDetailViewController = segue.destination as? MapViewController else {
                    fatalError("Unexpected destination")
                }
                
                MapDetailViewController.shop = shop
            
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
 
}
