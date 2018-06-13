//
//  EventDetailViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 07/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class EventDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, EventEditDelegate {

    static let storyboardID = "eventDetailViewController"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var eventImageWrapper: UIView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var organizerImageView: DesignableImageView!
    @IBOutlet weak var organizerNameLabel: UILabel!
    
    
    var event: Event?
    let refreshControl = UIRefreshControl()
    var users = [User]()
    
    var userOptionsArray = [String]()
    var eventOptionID = "eventOptionID"
    var popover: Popover!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if ApplicationManager.sharedInstance.user.user_id == event?.organizerModel.user_id {
            setupNav()
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
        
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
        
        let more = UIBarButtonItem(image: UIImage(named: "more-icon-white"), style: .plain, target: self, action: #selector(self.showEventOptionsPopup(_:)))
//        let editButton = UIBarButtonItem(image: UIImage(named: "edit-icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.editButtonPressed))
        navigationItem.rightBarButtonItem = more
    }
    
    func setupUI() {
        if let event = event {
            title = event.name
            titleLabel.text = event.location
            if let description = event.descriptionValue {
                aboutLabel.text = "About: \(description)"
            }
            organizerNameLabel.text = event.organizerModel.full_name ?? ""
            if let startDate = event.start_date, let endDate = event.end_date{
                timeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: startDate, format: Constant.eventDetailDateFormat) + " to " + UtilityManager.stringFromNSDateWithFormat(date: endDate, format: Constant.eventDetailDateFormat)
            }
            eventImageView.sd_setImage(with: URL(string: event.eventImages.medium.url), placeholderImage: UIImage(named: "placeholder-banner"), options: SDWebImageOptions.refreshCached, completed: nil)
            organizerImageView.sd_setImage(with: URL(string: event.organizerModel.profileImages.small.url), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        }
        
    }
    
    @objc func refreshTableView() {
        fetchData()
    }
    
    @IBAction func organizerButtonPressed(_ sender: Any) {
        if let user = event?.organizerModel {
            Router.showProfileViewController(user: user, from: self)
        }
        
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
        
        if tableView==self.tableView {
            return users.count
        }
        else {
            return userOptionsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationDetailTableViewCell.eventIdentifier) as! LocationDetailTableViewCell
        let user = users[indexPath.row]
        cell.nameLabel.text = user.full_name
//        if user.user_id! == ApplicationManager.sharedInstance.user.user_id {
//            cell.nameLabel.text?.append(" (Organizer)")
//        }
        cell.headlineLabel.text = user.headline
        cell.profileImageView.sd_setImage(with: URL(string: user.profileImages.small.url), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        if let tagline = user.tagline, tagline.length > 0 {
            cell.taglineLabel.text = "\(tagline)"
        }
        else{
            cell.taglineLabel.text = nil
        }
        cell.activationTimeLabel.text = "active\n" + UtilityManager.timeAgoSinceDate(date: user.event_checkin_time!, numericDates: true)
        
        return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PopOverTableViewCell.identifier) as! PopOverTableViewCell
            cell.titleLabel.text = self.userOptionsArray[(indexPath as NSIndexPath).row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView {
            let user = users[indexPath.row]
            
            Router.showProfileViewController(user: user, from: self)
        }
        else {
            
            
//            let post = postArray[tableView.tag]
            let params = ["event_id":self.event?.id ?? "0"]
            
            if (popover != nil) {
                popover.dismiss()
            }
            
//            if let popover = post.optionsPopover {
//                popover.dismiss()
//            }
            
            if event?.organizerModel.user_id == ApplicationManager.sharedInstance.user.user_id {
                
                    switch (indexPath.row)
                    {
                    case 0:
//                        Router.editGeoPost(from: self,postObject: post)
                        Router.showEditEventController(event: self.event!, from: self)
                        
                    case 1:
                        if event?.organizerModel.user_id == ApplicationManager.sharedInstance.user.user_id {
                            UIAlertController.showAlert(in: self, withTitle: "Confirm", message: "Are you sure you want to delete this event?", cancelButtonTitle: "No", destructiveButtonTitle: nil, otherButtonTitles: ["Yes"], tap: { (alertController, alertAction, buttonIndex) in
                                if alertAction.title == "Yes" {
                                    SVProgressHUD.show()
                                    RequestManager.deleteEvent(param: params, successBlock: { (response) in
                                        Router.showEventsListController(from: self)
                                    }) { (error) in
                                        UtilityManager.showErrorMessage(body: error, in: self)
                                    }
                                }
                            })
                        }
                    default:
                        return
                    }
                
            }
            else {
                
                UIAlertController.showAlert(in: self, withTitle: "Confirm", message: "Are you sure you want to report this event?", cancelButtonTitle: "No", destructiveButtonTitle: nil, otherButtonTitles: ["Yes"], tap: { (alertController, alertAction, buttonIndex) in
                    if alertAction.title == "Yes" {
                        SVProgressHUD.show()
                        RequestManager.reportEvent(param: params, successBlock: { (response) in
//                            self.fetchFreshData()
                        }) { (error) in
                            UtilityManager.showErrorMessage(body: error, in: self)
                        }
                    }
                })
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.tableView {
            return (CGFloat)(60)
        }
        else {
            return (CGFloat)(40)
        }
    }
    
    @objc func showEventOptionsPopup(_ sender: UIBarButtonItem) {
        
        var optionsHeight = 0
        //        let post = postArray[sender.tag]
        
        if event?.organizerModel.user_id == ApplicationManager.sharedInstance.user.user_id {
            
            userOptionsArray = ["Edit", "Delete"]
            optionsHeight = userOptionsArray.count*35
        }
        else {
            userOptionsArray = ["Report"]
            optionsHeight = 30
        }
        
        let popoverOptions: [PopoverOption] = [
            .type(.auto),
            .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
        ]
        
        let optionsTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: optionsHeight))
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.isScrollEnabled = false
        optionsTableView.tag=sender.tag
        optionsTableView.accessibilityIdentifier = eventOptionID
        optionsTableView.register(UINib(nibName: "PopOverTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: PopOverTableViewCell.identifier)
        popover = Popover(options: popoverOptions)
        popover.show(optionsTableView, fromView: sender.view!)
        
    }
    
    @objc func editButtonPressed() {
        Router.showEditEventController(event: self.event!, from: self)
    }
    
    func eventEdited(event: Event) {
        self.event = event
        setupUI()
    }
    
    //MARK : - EmptyDataSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Recent Checkins Found"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes = [NSAttributedStringKey.font: UIFont(font: .Medium, size: 17.0) as Any,
                                          NSAttributedStringKey.foregroundColor: UIColor(red: 170.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0),
                                          NSAttributedStringKey.paragraphStyle: paragraphStyle] as [NSAttributedStringKey: Any]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Try out some other nearby events for recently checked in users"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes = [NSAttributedStringKey.font: UIFont(font: .Standard, size: 15.0) as Any,
                                          NSAttributedStringKey.foregroundColor: UIColor(red: 170.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0),
                                          NSAttributedStringKey.paragraphStyle: paragraphStyle] as [NSAttributedStringKey: Any]
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
        
        let attributes = [NSAttributedStringKey.font: UIFont(font: .SemiBold, size: 14.0) as Any,
                                          NSAttributedStringKey.foregroundColor: color,
                                          NSAttributedStringKey.paragraphStyle: paragraphStyle] as [NSAttributedStringKey: Any]
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
