//
//  EditProfileViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 26/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: DZImageView!
    @IBOutlet weak var nameField: DesignableTextField!
    @IBOutlet weak var headlineField: DesignableTextField!
    @IBOutlet weak var aboutMeTextView: DesignableTextView!
    @IBOutlet weak var interestsField: DesignableTextField!
    @IBOutlet weak var schoolField: DesignableTextField!
    @IBOutlet weak var worksAtField: DesignableTextField!
    @IBOutlet weak var livesInField: DesignableTextField!
    @IBOutlet weak var emailField: DesignableTextField!
    @IBOutlet weak var phoneNumberField: DesignableTextField!
    @IBOutlet weak var facebookProfileField: DesignableTextField!
    @IBOutlet weak var linkedInProfileField: DesignableTextField!
    @IBOutlet weak var googleField: DesignableTextField!
    @IBOutlet weak var websiteField: DesignableTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupNavigation()
    }
    
    func setupUI() {
        let user = ApplicationManager.sharedInstance.user
        
        nameField.text = user.full_name
        headlineField.text = user.headline
        aboutMeTextView.text = user.about
        interestsField.text = user.interests
        schoolField.text = user.school
        worksAtField.text = user.worked_at
        livesInField.text = user.lives_in
        emailField.text = user.email
        phoneNumberField.text = user.contact_number
        facebookProfileField.text = user.facebook_profile
        linkedInProfileField.text = user.linkedin_profile
        googleField.text = user.google_profile
        websiteField.text = user.website
        
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
        var params = [String : String]()
       
        params["session_id"] = ApplicationManager.sharedInstance.session_id
        params["full_name"] = nameField.text
//        params["headline"] = headlineField.text
        params["about"] = aboutMeTextView.text
        params["interests"] = interestsField.text
        params["school"] = schoolField.text
        params["worked_at"] = worksAtField.text
        params["lives_in"] = livesInField.text
        params["email"] = emailField.text
        params["contact_number"] = phoneNumberField.text
        params["facebook_profile"] = facebookProfileField.text
        params["linkedin_profile"] = linkedInProfileField.text
//        params["google_profile"] = googleField.text
        params["website"] = websiteField.text
        
        SVProgressHUD.show()
        RequestManager.updateProfile(param: params, successBlock: { (response) in
            SVProgressHUD.showSuccess(withStatus: "Profile Saved")
            ApplicationManager.sharedInstance.user = User(dictionary: response)
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
