//
//  EditBusinessCardViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 13/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class EditBusinessCardViewController: UIViewController {
    
    static let storyboardID = "editBusinessCardViewController"

    @IBOutlet weak var profileImageView: DZImageView!
    @IBOutlet weak var nameLabel: DesignableTextField!
    @IBOutlet weak var titleLabel: DesignableTextField!
    @IBOutlet weak var emailField: DesignableTextField!
    @IBOutlet weak var phoneField: DesignableTextField!
    @IBOutlet weak var addressField: DesignableTextView!
    @IBOutlet weak var websiteField: DesignableTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
    }

    
    func setupNavigation() {
        let barButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(EditProfileViewController.saveButtonPressed(sender:)))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        var params = [String: AnyObject]()
        params["name"] = nameLabel.text as AnyObject
        params["title"] = titleLabel.text as AnyObject
        params["email"] = emailField.text as AnyObject
        params["phone"] = phoneField.text as AnyObject
        params["address"] = addressField.text as AnyObject
        params["web"] = websiteField.text as AnyObject
        
        SVProgressHUD.show()
        RequestManager.addBusinessCard(param: params, successBlock: { (response) in
            SVProgressHUD.showSuccess(withStatus: "Profile Updated")
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
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
