//
//  AccountViewController.swift
//  MinorDianping
//
//  Created by Apple on 17/5/25.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    
    let user = CurrentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set naviation bar color, word color & word color in button
        self.navigationController?.navigationBar.barTintColor =
            UIColor(red: 255/255, green: 231/255, blue: 186/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.black]
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userNameLabel.text = user.getUserName()
        print(user.getUserName())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "myCollections":
            guard let searchDetailViewController = segue.destination as? ShopTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            searchDetailViewController.target = "myCollections"
            
        case "sign": break
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
}
