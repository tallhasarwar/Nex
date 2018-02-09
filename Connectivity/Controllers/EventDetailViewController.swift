//
//  EventDetailViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 07/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class EventDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    static let storyboardID = "eventDetailViewController"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var eventImageWrapper: UIView!
    
    var event: Event?
    let refreshControl = UIRefreshControl()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
        setupNav()
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
        
        tableView.tableFooterView = UIView()
        
        
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: UIControlEvents.valueChanged)
        tableView.refreshControl = refreshControl
        
        SVProgressHUD.show()
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        eventImageWrapper.frame = eventImageView.frame
        tableView.layoutSubviews()
        tableView.layoutIfNeeded()
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
            eventImageView.sd_setImage(with: URL(string: event.eventImages.medium.url), placeholderImage: UIImage(named: "placeholder-banner"), options: SDWebImageOptions.refreshCached, completed: nil)
            
        }
        
    }
    
    func refreshTableView() {
        fetchData()
    }
    
    
    func fetchData() {
        
        var params = [String: AnyObject]()
        params["event_id"] = event?.id as AnyObject
        params["page"] = 0 as AnyObject
        
        RequestManager.checkinEvent(param: params, successBlock: { (response) in
            self.users.removeAll()
            self.refreshControl.endRefreshing()
            for object in response {
                self.users.append(User(dictionary: object))
            }
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }) { (error) in
            UtilityManager.showErrorMessage(body: error, in: self)
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationDetailTableViewCell.eventIdentifier) as! LocationDetailTableViewCell
        let user = users[indexPath.row]
        cell.nameLabel.text = user.full_name
        cell.headlineLabel.text = user.headline
        cell.profileImageView.sd_setImage(with: URL(string: user.profileImages.small.url), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        if let tagline = user.tagline {
            cell.taglineLabel.text = "\"\(tagline)\""
        }
        else{
            cell.taglineLabel.text = nil
        }
        cell.activationTimeLabel.text = "active\n" + UtilityManager.timeAgoSinceDate(date: user.event_checkin_time!, numericDates: true)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        Router.showProfileViewController(user: user, from: self)
    }
    
    func editButtonPressed() {
        Router.showEditEventController(event: self.event!, from: self)
    }
    
    //MARK : - EmptyDataSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Recent Checkins Found"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes : [String: Any] = [NSFontAttributeName: UIFont(font: .Medium, size: 17.0) as Any,
                                          NSForegroundColorAttributeName: UIColor(red: 170.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0),
                                          NSParagraphStyleAttributeName: paragraphStyle]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Try out some other nearby events for recently checked in users"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes : [String: Any] = [NSFontAttributeName: UIFont(font: .Standard, size: 15.0) as Any,
                                          NSForegroundColorAttributeName: UIColor(red: 170.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0),
                                          NSParagraphStyleAttributeName: paragraphStyle]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = "Reload"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        var color: UIColor!
        
        if state == .normal {
            color = UIColor(red: 44.0/255.0, green: 137.0/255.0, blue: 202.0/255.0, alpha: 1.0)
        }
        if state == .highlighted {
            color = UIColor(red: 106.0/255.0, green: 187.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        }
        
        let attributes : [String: Any] = [NSFontAttributeName: UIFont(font: .SemiBold, size: 14.0) as Any,
                                          NSForegroundColorAttributeName: color,
                                          NSParagraphStyleAttributeName: paragraphStyle]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor(white: 1.0, alpha: 1.0)
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 50
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        SVProgressHUD.show()
        fetchData()
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        SVProgressHUD.show()
        fetchData()
    }

}
