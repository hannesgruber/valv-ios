//
//  SettingsViewController.swift
//  Valv
//
//  Created by Hannes Gruber on 13/08/14.
//  Copyright (c) 2014 Hannes Gruber. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginSpinner: UIActivityIndicatorView!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("settings viewdidload")
        
        updateUi()
        
    }

    @IBAction func loginButtonClicked() {
        self.view.endEditing(true)
        
        
        if LOGGED_IN {
            
            loginActivityIndicator.startAnimating()
            loginManager.logout(AUTHKEY, callback: logoutCallback)
            
        } else {
            if !usernameTextField.text.isEmpty && !passwordTextField.text.isEmpty {
                println("login clicked")
                loginActivityIndicator.startAnimating()
                loginManager.login(usernameTextField.text, password: passwordTextField.text, callback: loginCallback)
            }
        }
    }
    
    func loginCallback(success: Bool) {
        // need to do this on main thread
        dispatch_async(dispatch_get_main_queue()) {
            println("callback sucess=\(success)")
            
            self.loginActivityIndicator.stopAnimating()
            
            LOGGED_IN = success
            
            self.updateUi()
        }
        
    }
    
    func logoutCallback(success: Bool) {
        // need to do this on main thread
        dispatch_async(dispatch_get_main_queue()) {
            println("logout callback sucess=\(success)")
            
            self.loginActivityIndicator.stopAnimating()
            
            LOGGED_IN = false
            
            self.updateUi()
            self.clearTextFields()
        }
        
    }

    
    func updateUi() {
        if LOGGED_IN {
            self.loginLabel.text = "Logged in to Valv"
            self.loginButton.setTitle("Logout", forState: nil)
            self.usernameTextField.text = USERNAME
            self.usernameTextField.enabled = false
            self.passwordTextField.text = PASSWORD
            self.passwordTextField.enabled = false
        } else {
            self.loginLabel.text = "Log in to Valv"
            self.loginButton.setTitle("Login", forState: nil)
            self.usernameTextField.enabled = true
            self.passwordTextField.enabled = true
        }
    }
    
    func clearTextFields(){
        self.usernameTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    @IBAction func createAccountButtonClicked() {
        self.view.endEditing(true)
        UIApplication.sharedApplication().openURL(NSURL(string: "http://valv.se/signup"))
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
