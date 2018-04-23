//
//  ProfileViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 24/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    static let storyboardID = "profileViewController"
    
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var connectButton: DesignableButton!
    @IBOutlet weak var acceptanceView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var connectionLabel: UILabel!
    
    var publicProfile: Bool = false
    var user = User()
    var connectionStatus = "none"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        tableView.separatorStyle = .none
        
        title = "Profile"
        self.tabBarItem.title = ""
        
        publicProfile = ApplicationManager.sharedInstance.user.user_id != user.user_id
        
        if publicProfile == true {
            self.navigationItem.rightBarButtonItem = nil
            headerView.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: 305 )
            messageView.isHidden = false
            guard let id = user.user_id else { return }
            RequestManager.getOtherProfile(userID: id, successBlock: { (response) in
                self.user = User(dictionary: response["user"] as! [String: AnyObject])
                self.connectionStatus = response["userConnectionStatus"] as! String
                self.updateConnectionUI()
                self.loadUI()
            }, failureBlock: { (error) in
                UtilityManager.showErrorMessage(body: error, in: self)
            })
        }
        else{
            headerView.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: 230)
            connectButton.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUI()
        
        if publicProfile != true {
            RequestManager.getUser(successBlock: { (response) in
                SVProgressHUD.dismiss()
                let user = User(dictionary: response)
                ApplicationManager.sharedInstance.user = user
                self.user = user
                self.loadUI()
            }, failureBlock: { (error) in
                UtilityManager.showErrorMessage(body: error, in: self)
            })
        }
        
        
    }
    
    func loadUI() {
        profileNameLabel.text = user.full_name
        jobTitleLabel.text = user.headline
        taglineLabel.text = user.tagline
        profileImageView.sd_setImage(with: URL(string: user.profileImages.medium.url), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        tableView.reloadData()
    }
    
    func updateConnectionUI() {
        connectionLabel.isHidden = true

        if connectionStatus == "SENT" {
            headerView.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: 320)
            self.connectButton.isHidden = false
            self.acceptanceView.isHidden = true
            self.connectButton.setTitle("Request Pending", for: UIControlState.normal)
            self.connectButton.isEnabled = false
            self.connectButton.alpha = 0.8
        }
        else if connectionStatus == "PENDING" {
            headerView.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: 320)
            self.connectButton.isHidden = true
            self.acceptanceView.isHidden = false
        }
        else if connectionStatus == "ACCEPTED" {
            headerView.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: 290)
            self.connectButton.isHidden = true
            self.acceptanceView.isHidden = true
            self.connectionLabel.isHidden = false
        }
        else{
            self.connectButton.isHidden = false
            self.acceptanceView.isHidden = true
            headerView.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: 320)
        }
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == -1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImagesTableViewCell.identifier) as! ProfileImagesTableViewCell
            return cell
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDetailTableViewCell.identifier) as! ProfileDetailTableViewCell
            
            switch indexPath.row {
            case 0:
                cell.headingLabel.text = "Works at"
                cell.descriptionLabel.text = user.works_at ?? "N/A"
                cell.descriptionTextView.text = user.works_at ?? "N/A"
            case 1:
                cell.headingLabel.text = "Lives in"
                cell.descriptionLabel.text = user.lives_in ?? "N/A"
                cell.descriptionTextView.text = user.lives_in ?? "N/A"
            case 2:
                cell.headingLabel.text = "Worked at"
                cell.descriptionLabel.text = user.worked_at ?? "N/A"
                cell.descriptionTextView.text = user.worked_at ?? "N/A"
            case 3:
                cell.headingLabel.text = "School / University"
                cell.descriptionLabel.text = user.school ?? "N/A"
                cell.descriptionTextView.text = user.school ?? "N/A"
            case 4:
                cell.headingLabel.text = "Interests"
                cell.descriptionLabel.text = user.interests ?? "N/A"
                cell.descriptionTextView.text = user.interests ?? "N/A"
            case 5:
                cell.headingLabel.text = "Email address"
                cell.descriptionLabel.text = user.email ?? "N/A"
                cell.descriptionTextView.text = user.email ?? "N/A"
            case 6:
                cell.headingLabel.text = "Phone number"
                cell.descriptionLabel.text = user.contact_number ?? "N/A"
                cell.descriptionTextView.text = user.contact_number ?? "N/A"
            case 7:
                cell.headingLabel.text = "Facebook profile"
                cell.descriptionLabel.text = user.facebook_profile ?? "N/A"
                cell.descriptionTextView.text = user.facebook_profile ?? "N/A"
            case 8:
                cell.headingLabel.text = "LinkedIn profile"
                cell.descriptionLabel.text = user.linkedin_profile ?? "N/A"
                cell.descriptionTextView.text = user.linkedin_profile ?? "N/A"
            case 9:
                cell.headingLabel.text = "Google+ profile"
                cell.descriptionLabel.text = user.google_profile ?? "N/A"
                cell.descriptionTextView.text = user.google_profile ?? "N/A"
            case 10:
                cell.headingLabel.text = "Website"
                cell.descriptionLabel.text = user.website ?? "N/A"
                cell.descriptionTextView.text = user.website ?? "N/A"
            case 11:
                cell.headingLabel.text = "About Me"
                cell.descriptionLabel.text = user.about ?? "N/A"
                cell.descriptionTextView.text = user.about ?? "N/A"
                
            default:
                break
            }
            
            return cell
        }
    }

    @IBAction func connectButtonPressed(_ sender: Any) {
        let param = ["connection_to_id":user.user_id ?? ""]
        
        SVProgressHUD.show()
        RequestManager.sendRequest(param: param, successBlock: { (response) in
            
            UtilityManager.showSuccessMessage(body: "Request sent", in: self)
            self.connectionStatus = "SENT"
            self.updateConnectionUI()
        }) { (error) in
            UtilityManager.showErrorMessage(body: error, in: self)
        }
    }
    
    @IBAction func acceptButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        RequestManager.respondToConnectionRequest(userID: user.user_id!, accepted: true, successBlock: { (response) in
//            SVProgressHUD.showSuccess(withStatus: "Request Accepted")
            UtilityManager.showSuccessMessage(body: "Request accepted", in: self)
            self.connectionStatus = "SENT"
            self.updateConnectionUI()
        }) { (error) in
            UtilityManager.showErrorMessage(body: error, in: self)
        }
    }
    
    @IBAction func rejectButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        RequestManager.respondToConnectionRequest(userID: user.user_id!, accepted: false, successBlock: { (response) in
//            SVProgressHUD.showSuccess(withStatus: "Request Rejected")
            UtilityManager.showSuccessMessage(body: "Request rejected", in: self)
            self.acceptanceView.isHidden = true
        }) { (error) in
            UtilityManager.showErrorMessage(body: error, in: self)
        }
    }
    
    @IBAction func messageButtonPressed(_ sender: Any) {
        Router.showChatViewController(user: user, from: self)
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
