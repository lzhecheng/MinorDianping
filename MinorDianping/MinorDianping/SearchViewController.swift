//
//  SearchViewController.swift
//  MinorDianping
//
//  Created by Apple on 17/5/25.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        
        //set naviation bar color
        self.navigationController?.navigationBar.barTintColor =
            UIColor(red: 255/255, green: 250/255, blue: 250/255, alpha: 1)
        
        navigationItem.title = "查找餐厅"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: UITextField
    
    //hide keyboard when pressing somewhere outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hide keyboard when pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        searchTextField.resignFirstResponder()
        return (true)
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
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
}
