//
//  ConversationListViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 30/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ConversationListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var items = [Conversation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Messages"
        tableView.delegate = self
        tableView.dataSource = self
        self.fetchData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushToUserMesssages(notification:)), name: NSNotification.Name(rawValue: "showUserMessages"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Downloads conversations
    func fetchData() {
        Conversation.showConversations { (conversations) in
            self.items = conversations
            self.items.sort{ $0.lastMessage.timestamp > $1.lastMessage.timestamp }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //Shows Chat viewcontroller with given user
    @objc func pushToUserMesssages(notification: NSNotification) {
        
        if let user = notification.userInfo?["user"] as? User {
            Router.showChatViewController(user: user, from: self)
        }
    }
    
    //MARK: Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier, for: indexPath) as! ConversationTableViewCell
        //            cell.clearCellData()
        
        let user = items[indexPath.row].user
        
        cell.nameLabel.text = user.full_name
        cell.profileImageView.sd_setImage(with: URL(string: user.image_path ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        
        switch self.items[indexPath.row].lastMessage.type {
        case .text:
            let message = self.items[indexPath.row].lastMessage.content as! String
            cell.descriptionLabel.text = message
        case .location:
            cell.descriptionLabel.text = "Location"
        default:
            cell.descriptionLabel.text = "Media"
        }
        let messageDate = Date.init(timeIntervalSince1970: TimeInterval(self.items[indexPath.row].lastMessage.timestamp/1000))
        let dataformatter = DateFormatter.init()
        dataformatter.timeStyle = .short
        let date = dataformatter.string(from: messageDate)
        cell.durationLabel.text = date
        if self.items[indexPath.row].lastMessage.owner == .sender && self.items[indexPath.row].lastMessage.isRead == false {
            cell.nameLabel.font = UIFont(font: .SemiBold, size: 14.0)
            cell.descriptionLabel.font = UIFont(font: .SemiBold, size: 12.0)
            cell.durationLabel.font = UIFont(font: .SemiBold, size: 11.0)
            cell.descriptionLabel.textColor = UIColor.darkGray
            cell.durationLabel.textColor = UIColor.darkGray
            cell.contentView.backgroundColor = UIColor(red:0.07, green:0.37, blue:0.97, alpha:0.1)
        }
        else{
            cell.nameLabel.font = UIFont(font: .SemiBold, size: 14.0)
            cell.descriptionLabel.font = UIFont(font: .Medium, size: 12.0)
            cell.durationLabel.font = UIFont(font: .Medium, size: 11.0)
            cell.descriptionLabel.textColor = UIColor(white: 0.45, alpha: 1.0)
            cell.durationLabel.textColor = UIColor(white: 0.45, alpha: 1.0)
            cell.contentView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.items.count > 0 {
            Router.showChatViewController(user: self.items[indexPath.row].user, from: self)
        }
    }
    
    
}
