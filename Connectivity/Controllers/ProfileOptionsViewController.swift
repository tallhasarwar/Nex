//
//  ProfileOptionsViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 5/7/18.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class ProfileOptionsViewController: UIViewController {
    @IBOutlet weak var buttonView: SpringView!
    @IBOutlet var parentView: SpringView!
    
    static let storyboardID = "profileOptionsViewController"
    
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        parentView.animate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        parentView.animate()
    }
    
    override func viewDidDisappear(_ animated:Bool) {
        super.viewDidDisappear(true)
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
    
    @IBAction func removeViewController(_ sender: Any) {
        
        buttonView.animate()
        perform(#selector(callExitSeague), with: nil, afterDelay: 1)
        
    }
    
    @objc func callExitSeague() {
        self.performSegue(withIdentifier: "removeViewSeagueID", sender: Any?.self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
