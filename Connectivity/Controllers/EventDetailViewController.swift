//
//  EventDetailViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 07/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class EventDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    static let storyboardID = "eventDetailViewController"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
        setupNav()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNav() {
        let editButton = UIBarButtonItem(image: UIImage(named: "edit-icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.editButtonPressed))
        navigationItem.rightBarButtonItem = editButton
    }
    
    func setupUI() {
        if let event = event {
            title = event.name
            titleLabel.text = event.location
            if let startDate = event.start_date, let endDate = event.end_date{
                timeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: startDate, format: Constant.eventDetailDateFormat) + " to " + UtilityManager.stringFromNSDateWithFormat(date: endDate, format: Constant.eventDetailDateFormat)
            }
            eventImageView.sd_setImage(with: URL(string: event.image_path ?? ""), placeholderImage: UIImage(named: "placeholder-banner"), options: SDWebImageOptions.refreshCached, completed: nil)
            
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventDetailTableViewCell.identifier) as! EventDetailTableViewCell
        
        let user = ApplicationManager.sharedInstance.user
        
        cell.nameLabel.text = user.full_name
        cell.descriptionLabel.text = user.headline
        cell.profileImageView.sd_setImage(with: URL(string: user.image_path ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = ApplicationManager.sharedInstance.user
        Router.showProfileViewController(user: user, from: self)
    }
    
    func editButtonPressed() {
        Router.showEditEventController(event: self.event!, from: self)
    }

}
