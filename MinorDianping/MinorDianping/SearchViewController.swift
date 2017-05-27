//
//  SearchViewController.swift
//  MinorDianping
//
//  Created by Apple on 17/5/25.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set naviation bar color
        self.navigationController?.navigationBar.barTintColor =
            UIColor(red: 255/255, green: 250/255, blue: 250/255, alpha: 1)
        
        navigationItem.title = "Shop Searching"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "Searching":
            guard let searchDetailViewController = segue.destination as? ShopTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }

            searchDetailViewController.target = searchTextField.text!
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
}
