//
//  SignInViewController.swift
//  MinorDianping
//
//  Created by Apple on 2017/6/11.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit
import Foundation

class SignInViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    // user name and pwd
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userNameTextField.delegate = self
        self.pwdTextField.delegate = self
        
        // make passcode secure
        pwdTextField.isSecureTextEntry = true
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        scrollView.setContentOffset(CGPoint(x: 0,y: 250), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0,y: -70), animated: true)
    }
    
    // try to sign up
    @IBAction func signUp(_ sender: UIButton) {
        // get user name and password
        let userName = userNameTextField.text!
        let pwd = pwdTextField.text!

        let mySQLOps = MySQLOps()

        // check if user exists
        mySQLOps.registerNewUser(username: userName, password: pwd){
            success in
            
            let user = CurrentUser()
            
            if success {
                user.changeUserName(name: self.userNameTextField.text!)
                
                let title = "注册成功！"
                let message = "欢迎来到小众点评，" + user.getUserName()
                DispatchQueue.main.async {
                    self.alert(title: title, message: message, succeed: true)
                }
            } else {
                let title = "注册失败！"
                let message = "用户名已被使用"
                
                DispatchQueue.main.async {
                    self.alert(title: title, message: message, succeed: false)
                }
            }
        }
    }
    
    // try to sign in
    @IBAction func signIn(_ sender: UIButton) {
        
        // get user name and password
        let userName = userNameTextField.text!
        let pwd = pwdTextField.text!
        
        // chech if user name and password are correct
        let userDBCon = UserInfoDatabaseController()
        userDBCon.validatePassword(username: userName, password: pwd){
            success in
            
            let user = CurrentUser()
            
            if success == true {
                user.changeUserName(name: self.userNameTextField.text!)

                let title = "登录成功!"
                let message = "欢迎回来，" + user.getUserName()
                DispatchQueue.main.async {
                    self.alert(title: title, message: message, succeed: true)
                }

            } else {
                let title = "登录错误"
                let message = "用户名或密码错误"
                self.alert(title: title, message: message, succeed: false)
            }
        }
    }

    // Alert message
    func alert(title: String, message: String, succeed: Bool){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
