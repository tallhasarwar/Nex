//
//  EditBusinessCardViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 13/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import SwiftValidator

class EditBusinessCardViewController: BaseViewController, UITextFieldDelegate, ValidationDelegate {
    
    static let storyboardID = "editBusinessCardViewController"

    @IBOutlet weak var profileImageView: DZImageView!
    @IBOutlet weak var nameLabel: DesignableTextField!
    @IBOutlet weak var titleLabel: DesignableTextField!
    @IBOutlet weak var emailField: DesignableTextField!
    @IBOutlet weak var phoneField: DesignableTextField!
    @IBOutlet weak var addressField: DesignableTextView!
    @IBOutlet weak var websiteField: DesignableTextField!
    @IBOutlet weak var errorLabel: UILabel!
    let validator = Validator()
    
    var businessCard = BusinessCard()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        profileImageView.parentController = self
        
        nameLabel.text = businessCard.name
        titleLabel.text = businessCard.title
        emailField.text = businessCard.email
        phoneField.text = businessCard.phone
        addressField.text = businessCard.address
        websiteField.text = businessCard.web
        profileImageView.sd_setImage(with: URL(string: businessCard.profileImages.medium.url), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        
        validator.registerField(nameLabel, errorLabel: errorLabel, rules: [RequiredRule(message: "Name can't be empty") as Rule, MinLengthRule(length: 3) as Rule])
        validator.registerField(titleLabel, errorLabel: errorLabel, rules: [RequiredRule(message: "Title can't be empty") as Rule, MinLengthRule(length: 3) as Rule])
        validator.registerField(emailField, errorLabel: errorLabel, rules: [RequiredRule(message: "Email can't be empty") as Rule,EmailRule(message: "Invalid email")])
        validator.registerField(phoneField, errorLabel: errorLabel, rules: [RequiredRule(message: "Phone can't be empty") as Rule, MinLengthRule(length: 3) as Rule])
        
        [emailField,nameLabel,titleLabel,phoneField].forEach { (field) in
            field?.delegate = self
        }
        
        
    }

    
    func setupNavigation() {
        title = "Edit Business Card"
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(EditProfileViewController.saveButtonPressed(sender:)))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        validator.validate(self)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(red: 18.0/255.0, green: 94.0/255.0, blue: 247.0/255.0, alpha: 1.0).cgColor
        errorLabel.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " && textField == emailField {
            return false
        }
        return true
    }
    
    func validationSuccessful() {
        var params = [String: AnyObject]()
        params["name"] = nameLabel.text as AnyObject
        params["title"] = titleLabel.text as AnyObject
        params["email"] = emailField.text as AnyObject
        params["phone"] = phoneField.text as AnyObject
        params["address"] = addressField.text as AnyObject
        params["web"] = websiteField.text as AnyObject
        
        SVProgressHUD.show()
        RequestManager.addBusinessCard(param: params,image: profileImageView.image, successBlock: { (response) in
            //            SVProgressHUD.showSuccess(withStatus: "Profile Updated")
            SVProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            UtilityManager.showErrorMessage(body: error, in: self)
        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
                if error.errorLabel?.isHidden == true {
                    error.errorLabel?.text = error.errorMessage // works if you added labels
                    error.errorLabel?.isHidden = false
                }
            }
        }
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
