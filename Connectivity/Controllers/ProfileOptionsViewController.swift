//
//  ProfileOptionsViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 5/7/18.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class ProfileOptionsViewController: UIViewController {

    static let storyboardID = "profileOptionsViewController"
    
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reportButtonPressed(_ sender: Any) {
        UIAlertController.showAlert(in: self, withTitle: "Confirm", message: "Are you sure you want to report this profile? Misuse of this functionality may lead to your account termination.", cancelButtonTitle: "No", destructiveButtonTitle: nil, otherButtonTitles: ["Yes"], tap: { (alertController, alertAction, buttonIndex) in
            if alertAction.title == "Yes" {
                SVProgressHUD.show()
                RequestManager.reportUser(param: ["blocked_id":self.userID], successBlock: { (response) in
                    self.dismiss(animated: false, completion: nil)
                    UtilityManager.showSuccessMessage(body: "The profile has been reported", in: self)
                }) { (error) in
                    self.dismiss(animated: false, completion: nil)
                    UtilityManager.showErrorMessage(body: error, in: self)
                    
                }
            }
        })
    }
    
    @IBAction func blockButtonPressed(_ sender: Any) {
        UIAlertController.showAlert(in: self, withTitle: "Confirm", message: "Are you sure you want to block this profile?", cancelButtonTitle: "No", destructiveButtonTitle: nil, otherButtonTitles: ["Yes"], tap: { (alertController, alertAction, buttonIndex) in
            if alertAction.title == "Yes" {
                SVProgressHUD.show()
                RequestManager.blockUser(param: ["reported_id":self.userID], successBlock: { (response) in
//                    self.dismiss(animated: false, completion: nil)
//                    UtilityManager.showSuccessMessage(body: "The profile has been blocked", in: self)
//                    UtilityManager.delay(delay: 1.0, closure: {
                        Router.showMainTabBar()
//                    })
                }) { (error) in
                    self.dismiss(animated: false, completion: nil)
                    UtilityManager.showErrorMessage(body: error, in: self)
                }
            }
        })
    }
    
    @IBAction func removeConnectionButtonPressed(_ sender: Any) {
        UIAlertController.showAlert(in: self, withTitle: "Confirm", message: "Are you sure you want to remove connection?", cancelButtonTitle: "No", destructiveButtonTitle: nil, otherButtonTitles: ["Yes"], tap: { (alertController, alertAction, buttonIndex) in
            if alertAction.title == "Yes" {
                SVProgressHUD.show()
                RequestManager.removeUser(param: ["remove_id":self.userID], successBlock: { (response) in
                    Router.showMainTabBar()
                }, failureBlock: { (error) in
                    self.dismiss(animated: false, completion: nil)
                    UtilityManager.showErrorMessage(body: error, in: self)
                })
            }
        })
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
