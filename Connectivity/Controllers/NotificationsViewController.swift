//
//  NotificationsViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 15/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var connectionRequests = [User]()
    var notificationsArray = [NotificationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notifications"
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData() {
        RequestManager.getPendingRequests(param: ["page":0], successBlock: { (response) in
            self.connectionRequests.removeAll()
            for user in response {
                self.connectionRequests.append(User(dictionary: user))
            }
            self.tableView.reloadData()
        }) { (error) in
            print(error)
            SVProgressHUD.dismiss()
        }
        
        RequestManager.getAllNotifications(param: ["page":0], successBlock: { (response) in
            self.notificationsArray.removeAll()
            for user in response {
                self.notificationsArray.append(NotificationModel(dictionary: user))
            }
            self.tableView.reloadData()
            
            RequestManager.markNotificationsRead(param: [:], successBlock: { (response) in
                let tabbarItem = self.tabBarController!.tabBar.items![3]
                tabbarItem.badgeValue = nil
            }) { (error) in
                print(error)
                SVProgressHUD.dismiss()
            }
        }) { (error) in
            print(error)
            SVProgressHUD.dismiss()
        }
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return connectionRequests.count
            
        }
        else {
            return notificationsArray.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Connection Requests"
        case 1:
            return "Notifications"
        default: return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ConnectionRequestTableViewCell.identifier) as! ConnectionRequestTableViewCell
            let user = connectionRequests[indexPath.row]
            cell.userID = user.user_id
            cell.nameLabel.text = user.full_name
            cell.descriptionLabel.text = user.headline
            cell.profileImageView.sd_setImage(with: URL(string: user.profileImages.small.url), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
            cell.acceptButton.addTarget(self, action: #selector(NotificationsViewController.acceptButtonPressed(_:)),
                                        for: UIControlEvents.touchUpInside)
            cell.acceptButton.tag = indexPath.row
            cell.rejectButton.addTarget(self, action: #selector(NotificationsViewController.rejectButtonPressed(_:)),
                                        for: UIControlEvents.touchUpInside)
            cell.rejectButton.tag = indexPath.row
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsTableViewCell.identifier) as! NotificationsTableViewCell
            let notification = notificationsArray[indexPath.row]
            cell.nameLabel.text = notification.full_name
            cell.descriptionLabel.text = notification.title
            cell.profileImageView.sd_setImage(with: URL(string: notification.image_path ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
            cell.durationLabel.text = UtilityManager.timeAgoSinceDate(date: notification.created_at!, numericDates: true)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            Router.showProfileViewController(user: connectionRequests[indexPath.row], from: self)
        }
        else{
            let user = User()
            user.user_id = notificationsArray[indexPath.row].id
            Router.showProfileViewController(user: user, from: self)
        }
    }
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        let user = connectionRequests[sender.tag]
        SVProgressHUD.show()
        RequestManager.respondToConnectionRequest(userID: user.user_id!, accepted: true, successBlock: { (response) in
            SVProgressHUD.dismiss()
            self.connectionRequests.remove(at: sender.tag)
            self.tableView.reloadData()
        }) { (error) in
            UtilityManager.showErrorMessage(body: error, in: self)
        }
    }
    
    @IBAction func rejectButtonPressed(_ sender: UIButton) {
        let user = connectionRequests[sender.tag]
        SVProgressHUD.show()
        RequestManager.respondToConnectionRequest(userID: user.user_id!, accepted: false, successBlock: { (response) in
            SVProgressHUD.dismiss()
            self.connectionRequests.remove(at: sender.tag)
            self.tableView.reloadData()
        }) { (error) in
            UtilityManager.showErrorMessage(body: error, in: self)
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
