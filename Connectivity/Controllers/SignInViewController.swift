//
//  SignInViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 25/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import SwiftValidator

class SignInViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {
    
    static let identifier = "signInViewController"

    @IBOutlet weak var emailField: DesignableTextField!
    @IBOutlet weak var passwordField: DesignableTextField!
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validator.registerField(emailField, rules: [RequiredRule() as Rule,EmailRule(message: "Invalid email")])
        validator.registerField(passwordField, rules: [RequiredRule() as Rule, MinLengthRule(length: 8) as Rule, MaxLengthRule(length: 20) as Rule])
        
        [emailField, passwordField].forEach { (field) in
            field?.delegate = self
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signinButtonPressed(_ sender: Any) {
        validator.validate(self)
    }
    
    
    func validationSuccessful() {
        
        var params = [String : String]()
        params["email"] = emailField.text
        params["password"] = passwordField.text
        
        SVProgressHUD.show()
        RequestManager.loginUser(param: params, successBlock: { (response) in
            SVProgressHUD.dismiss()
            let user = User(dictionary: response)
            ApplicationManager.sharedInstance.user = user
            ApplicationManager.sharedInstance.session_id = response["session_id"] as! String
            UserDefaults.standard.set(response["session_id"] as! String, forKey: UserDefaultKey.sessionID)
            Router.showMainTabBar()
        }) { (error) in
            SVProgressHUD.show(withStatus: error)
        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
                field.resignFirstResponder()
                if error.errorLabel?.isHidden == true {
                    error.errorLabel?.text = error.errorMessage // works if you added labels
                    error.errorLabel?.isHidden = false
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.white.cgColor
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
