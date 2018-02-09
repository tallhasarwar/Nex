//
//  ForgotPasswordViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 22/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import SwiftValidator

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate, ValidationDelegate {

    @IBOutlet weak var emailField: FloatLabelTextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validator.registerField(emailField, rules: [RequiredRule() as Rule,EmailRule(message: "Invalid email")])
        
        emailField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
         validator.validate(self)
    }
    
    func validationSuccessful() {
        SVProgressHUD.show()
        RequestManager.forgotPassword(email: emailField.text!, successBlock: { (response) in
            SVProgressHUD.dismiss()
            UIAlertController.showAlert(in: self, withTitle: "Email Sent", message: "An email with instructions to reset password has been sent", cancelButtonTitle: "OK", destructiveButtonTitle: nil, otherButtonTitles: nil, tap: { (alert, action, index) in
                self.dismiss(animated: true, completion: nil)
            })
            
        }) { (error) in
            UtilityManager.showErrorMessage(body: error, in: self)
            
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " && textField == emailField {
            return false
        }
        return true
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
