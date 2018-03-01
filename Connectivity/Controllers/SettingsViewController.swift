//
//  SettingsViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 2/26/18.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let storyboardID = "settingsViewController"

    @IBOutlet weak var tableView: UITableView!
    
    let items = [["image":"terms-icon","title":"Terms and Conditions"], ["image":"delete-user-icon","title":"Delete Account"]] as [[String: String]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoreTableViewCell.identifier) as! MoreTableViewCell
        
        
        cell.detailImageView.image = UIImage(named: items[indexPath.row]["image"]!)
        cell.mainLabel.text = items[indexPath.row]["title"]
        cell.detailImageView.contentMode = .center
        
        if indexPath.row == 1 {
            cell.mainLabel.textColor = UIColor(hex: "D0011B")
        }
        else{
            cell.mainLabel.textColor = Styles.sharedStyles.primaryColor
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            //Router.showProfileViewController(user: ApplicationManager.sharedInstance.user, from: self)
            Router.showTermsAndConditions(from: self)
        case 1:
            UIAlertController.showAlert(in: self, withTitle: "Confirm", message: "Are you sure you want to delete your user? Once deleted this cannot be reverted.", cancelButtonTitle: "No", destructiveButtonTitle: nil, otherButtonTitles: ["Yes"], tap: { (alertController, alertAction, buttonIndex) in
                if alertAction.title == "Yes" {
                    self.deleteUser()
                }
            })
        
        default:
            break
        }
    }
    
    func deleteUser() {
        SVProgressHUD.show()
        RequestManager.deleteUser(param: [:], successBlock: { (response) in
            SVProgressHUD.dismiss()
            FBSDKLoginManager().logOut()
            Router.logout()
        }) { (error) in
            UtilityManager.showErrorMessage(body: error, in: self)
        }
    }

}
