//
//  SignInViewController.swift
//  MinorDianping
//
//  Created by Apple on 2017/6/11.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {

    //user name and pwd
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!

    let mySQLOps = MySQLOps()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userNameTextField.delegate = self
        self.pwdTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // hide keyboard when touch outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // press return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        pwdTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        // user attributes
        let userName = userNameTextField.text!
        let pwd = pwdTextField.text!
        let email = ""
        let fullname = ""
        
        // register a new user
        mySQLOps.registerNewUser(username: userName, password: pwd, email: email, fullname: fullname)
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        // user attribute
        let userName = userNameTextField.text!
        let pwd = pwdTextField.text!
        
//        mySQLOps.fetchUserInfoFromMySQL(username: userName, attributeName: String){
//            attributeValue in
//        }
    }
    
}
