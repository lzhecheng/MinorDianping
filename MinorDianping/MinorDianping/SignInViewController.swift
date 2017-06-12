//
//  SignInViewController.swift
//  MinorDianping
//
//  Created by Apple on 2017/6/11.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {

    // user name and pwd
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    let user = CurrentUser()
    let mySQLOps = MySQLOps()
    var userName: String?
    
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
    
    // try to sign up
    @IBAction func signUp(_ sender: UIButton) {
        if ifUserExist() {
            alert(title: "注册错误", message: "用户名已存在", succeed: false)
        } else {
            let message = "欢迎使用小众点评，" + userNameTextField.text!
            alert(title: "注册成功", message: message, succeed: true)
            user.changeUserName(name: userNameTextField.text!)
        }
    }
    
    // try to sign in
    @IBAction func signIn(_ sender: UIButton) {
        if signInOk() {
            let title = "登录成功"
            let message = "欢迎回来，" + userNameTextField.text!
            alert(title: title, message: message, succeed: true)
            user.changeUserName(name: userNameTextField.text!)
        } else {
            let title = "登录错误"
            let message = "用户名或密码错误"
            alert(title: title, message: message, succeed: false)
        }
    }
    
    // check if user exists
    func ifUserExist() ->Bool{
        // get user name and password
        let userName = userNameTextField.text!
        let pwd = pwdTextField.text!
        
        // check if user exists
        var ifExist = false
        
        mySQLOps.fetchUserInfoFromMySQL(username: userName, attributeName: "username"){
            ret in
            if let username = ret{
                if userName != username {
                    ifExist = false
                }
                print(username)
            }
        }
        
        
        
        
        mySQLOps.registerNewUser(username: userName, password: pwd){
            success in
            ifExist = !success
            print(success)
        }
        
        return ifExist
    }
    
    func signInOk() -> Bool{
        // get user name and password
        let userName = userNameTextField.text!
        let pwd = pwdTextField.text!
        
        // chech if user name and password are correct
        var ifCorrect = true
        mySQLOps.fetchUserInfoFromMySQL(username: userName, attributeName: "username"){
            ret in
            if let username = ret {
                print(username)
            }
        }
        mySQLOps.fetchUserInfoFromMySQL(username: userName, attributeName: "password"){
            ret in
            if let Spwd = ret {
                print(Spwd)
            }
        }
//        if !ifCorrect {
//            return false
//        }
        
//        mySQLOps.fetchUserInfoFromMySQL(username: userName, attributeName: "password"){
//            ret in
//            print(ret)
//            if let SQLpwd = ret{
//                if SQLpwd != pwd {
//                    ifCorrect = false
//                }
//            } else {
//                ifCorrect = false
//            }
//        }
//        if !ifCorrect {
//            return false
//        }
//        
        return true
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
