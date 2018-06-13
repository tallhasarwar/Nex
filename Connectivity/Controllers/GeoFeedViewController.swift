//
//  GeoFeedViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 31/12/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class GeoFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersDelegate, EasyTipViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    static let storyboardID = "geoFeedViewController"
    var postTableID = "postTableID"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var whiteView: UIView!
    
    var postArray = [Post]()
    var pageNumber = 1
    
    var isNextPageAvailable = false
    var defaultLocation: CLLocationCoordinate2D?
    var locationManager = CLLocationManager()
    var filterValue: String?
    var selectedFilterValue: String?
    let refreshControl = UIRefreshControl()
    var isLoading = false
    
    var userOptionsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Geo Feed"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //        tableView.rowHeight = UITableViewAutomaticDimension
        //        tableView.estimatedRowHeight = 80
        
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(setupLocation), for: UIControlEvents.valueChanged)
        
        SVProgressHUD.show()
        whiteView.isHidden = false
        self.setupLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchFreshData), name: NSNotification.Name(rawValue: "selfPostAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkForNotificationCount), name: NSNotification.Name(rawValue: "checkForPushNotificationCount"), object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.setupLocation), name: NSNotification.Name(rawValue: "refreshLocation"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - API calls
    
    func didChangeFilters(hashtags: String?, originalHashtags: String?) {
        filterValue = hashtags
        selectedFilterValue = originalHashtags
        fetchFreshData()
    }
    
    
    @objc func fetchFreshData() {
        isNextPageAvailable = true
        pageNumber = 1
        fetchData()
    }
    
    func fetchData() {
        
        if isLoading {
            return
        }
        isLoading = true
        tableView.isScrollEnabled = false
        
        var count = 0
        if pageNumber != 1 {
            count = self.postArray.count - 1
        }
        
        
        //http://localhost:3000/connectIn/api/v1/posts_feed?myPosts=yes&s_tags=ab,twist&latitude=31.447504395437022&longitude=74.36513375490904&page=0&raduis=500
        
        guard let location = defaultLocation else {
            return
        }
        
        if !isNextPageAvailable {
            return
        }
        
        var params = [String: AnyObject]()
        
        if UserDefaults.standard.bool(forKey: UserDefaultKey.ownPostsFilter) {
            params["myPosts"] = "yes" as AnyObject
        }
        else{
            params["myPosts"] = "no" as AnyObject
        }
        
        
        params["latitude"] = location.latitude as AnyObject
        params["longitude"] = location.longitude as AnyObject
        let value = UserDefaults.standard.value(forKey: UserDefaultKey.geoFeedRadius)
        if let radiusValue = value as? Float {
            params["radius"] = radiusValue  as AnyObject
        }
        else{
            params["radius"] = 30 as AnyObject
        }
        
        params["page"] = pageNumber as AnyObject
        
        if let filters = filterValue {
            params["s_tags"] = filters as AnyObject
        }
        
        print("Hitting for page \(self.pageNumber) and total posts \(self.postArray.count)")
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40))
        let loader = UtilityManager.activityIndicatorForView(view: view)
        loader.startAnimating()
        tableView.tableFooterView = view
        
        RequestManager.getPosts(param: params, successBlock: { (response) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.whiteView.isHidden = true
                self.tableView.tableFooterView = nil
                self.refreshControl.endRefreshing()
                print(response)
                
                
                if self.pageNumber == 1 {
                    self.postArray.removeAll()
                }
                
                if response.count >= 15 {
                    self.isNextPageAvailable = true
                    self.pageNumber += 1
                }
                else {
                    self.isNextPageAvailable = false
                }
                print("Hitted for page \(self.pageNumber) and total posts \(self.postArray.count) and total received posts are \(response.count)")
                for object in response {
                    self.postArray.append(Post(dictionary: object))
                }
                self.isLoading = false
                
                self.tableView.isScrollEnabled = true
                
                self.tableView.reloadData()
                
                if count < self.postArray.count && count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: count, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
                }
                
            }
            
            
        }) { (error) in
            UtilityManager.showErrorMessage(body: error, in: self)
            Router.logout()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForNotificationCount()
    }
    
    @objc func checkForNotificationCount() {
        RequestManager.getUser(successBlock: { (response) in
            let user = User(dictionary: response)
            if let notificationCount = user.unread_notification_count, notificationCount > 0 {
                if let tabbarItem = self.tabBarController?.tabBar.items![3] {
                    tabbarItem.badgeValue = "\(notificationCount)"
                }
            }
        }, failureBlock: { (error) in
            //            UtilityManager.showErrorMessage(body: error, in: self)
        })
    }
    
    //MARK: - tableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView==self.tableView {
            return postArray.count
        }
        else {
            return userOptionsArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            
            let cell : GeoFeedBasicTableViewCell!
            
            let post = postArray[indexPath.row]
            
            //        if let images = post.postImages {
            //            cell = tableView.dequeueReusableCell(withIdentifier: "geoFeedImageTableViewCell") as! GeoFeedBasicTableViewCell
            //            let calculatedHeight = Float(self.tableView.frame.size.width) / (images.medium.aspect ?? 1.0)
            //            cell.postImageHeightConstraint.constant = CGFloat(calculatedHeight)
            //
            //            cell.postImageView.sd_setImage(with: URL(string: images.medium.url), placeholderImage: UIImage(named: "placeholder-banner"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], completed: { (image, error, cacheType, url) in
            //
            //            })
            //            cell.imageOverlayButton.tag = indexPath.row
            //            cell.imageOverlayButton.addTarget(self, action: #selector(GeoFeedViewController.openImage(_:)), for: .touchUpInside)
            //
            //        }
            //        else{
            //            cell = tableView.dequeueReusableCell(withIdentifier: GeoFeedBasicTableViewCell.identifier) as! GeoFeedBasicTableViewCell
            //        }
            
            
            
            cell = tableView.dequeueReusableCell(withIdentifier: "geoFeedImageTableViewCell") as! GeoFeedBasicTableViewCell
            let likeCount = post.likeCount ?? 0
            let commentCount = post.commentCount ?? 0
            
            var likeCommentCount = ""
            
//            if likeCount > 0 || commentCount > 0 {
                likeCommentCount.append("\(likeCount) ")
                likeCommentCount.append(likeCount == 1 ? "Like  •  " : "Likes  •  ")
                likeCommentCount.append("\(commentCount) ")
                likeCommentCount.append(commentCount == 1 ? "Comment        " : "Comments        ")
                
//            }
            if let images = post.postImages {
                let calculatedHeight = Float(self.tableView.frame.size.width) / (images.medium.aspect ?? 1.0)
                cell.postImageHeightConstraint.constant = CGFloat(calculatedHeight)
                
                cell.postImageView.sd_setImage(with: URL(string: images.medium.url), placeholderImage: UIImage(named: "placeholder-banner"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], completed: { (image, error, cacheType, url) in
                    
                })
                cell.imageOverlayButton.tag = indexPath.row
                cell.imageOverlayButton.addTarget(self, action: #selector(GeoFeedViewController.openImage(_:)), for: .touchUpInside)
                
            }
            else{
                cell.postImageHeightConstraint.constant = CGFloat(0)
            }
            
            //        geoFeedImageTableViewCell
            
            cell.bodyLabel.text = post.content
            if post.location_name != nil && post.location_name?.count ?? 0 > 0 {
                cell.atLabel.isHidden = false
                cell.atLabel.text = "at"
                cell.locationButton.isHidden = false
                cell.locationButton.setTitle(post.location_name, for: .normal)
                cell.radiusLabelCheckinConstraint.isActive = false
            }
            else{
                cell.atLabel.isHidden = true
                cell.locationButton.isHidden = true
                cell.atLabel.text = nil
                cell.radiusLabelCheckinConstraint.isActive = true
                cell.layoutSubviews()
                cell.radiusLabel.layoutIfNeeded()
                
            }
            
            if let radius = post.distance {
                cell.radiusLabel.text = "(\(radius) away)"
            }
            else {
                cell.radiusLabel.text = ""
            }
            
            cell.profileNameButton.setTitle(post.full_name, for: .normal)
            cell.profileNameButton.addTarget(self, action: #selector(self.showProfile(_:)), for: .touchUpInside)
            cell.profileNameButton.tag = indexPath.row
            cell.profileImageView.sd_setImage(with: URL(string: post.profileImages.small.url), placeholderImage: UIImage(named: "placeholder-image"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], completed: nil)
            cell.timeLabel.text = UtilityManager.timeAgoSinceDate(date: post.created_at!, numericDates: true)
            
            
            
            //        cell.optionsButton.isHidden = false
            //        cell.trailingSpaceToOptionsButton.constant = 0
            //        cell.optionsButton.tag = indexPath.row
            //        cell.optionsButton.addTarget(self, action: #selector(self.showDeletionPopup(_:)), for: .touchUpInside)
            
            //        if post.user_id == ApplicationManager.sharedInstance.user.user_id {
            cell.optionsButton.isHidden = false
            cell.trailingSpaceToOptionsButton.constant = 0
            cell.optionsButton.tag = indexPath.row
            cell.optionsButton.addTarget(self, action: #selector(self.showOptionsPopup(_:)), for: .touchUpInside)
            //        }
            //        else{
            //            cell.optionsButton.isHidden = true
            //            cell.trailingSpaceToOptionsButton.constant = -22
            //        }
            
            
            if let tipView = post.easyTipView {
                post.isOptionsPopUpShowing = false
                tipView.delegate = nil
                tipView.dismiss()
            }
           
            
            cell.likeButton.isSelected = post.isSelfLiked ?? false
            
            cell.likeCommentLabel.text = likeCommentCount
            
            cell.likeButton.tag = indexPath.row
            cell.likeButton.addTarget(self, action: #selector(self.likePostButtonPressed(_:)), for: .touchUpInside)
            
            cell.commentButton.tag = indexPath.row
            cell.commentButton.addTarget(self, action: #selector(self.commentPostButtonPressed(_:)), for: .touchUpInside)
            
            cell.likeCommentButton.tag = indexPath.row
            cell.likeCommentButton.addTarget(self, action: #selector(self.likeCommentButtonPressed(_:)), for: .touchUpInside)
            
            
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PopOverTableViewCell.identifier) as! PopOverTableViewCell
            cell.titleLabel.text = self.userOptionsArray[(indexPath as NSIndexPath).row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row <= postArray.count-1 {
            let post = postArray[indexPath.row]
            
            if let popView = post.optionsPopover {
                post.isOptionsPopUpShowing = false
                popView.dismiss()
                
            }
            
            if let tipView = post.easyTipView {
                post.isOptionsPopUpShowing = false
                tipView.delegate = nil
                tipView.dismiss()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isNextPageAvailable == true {
            if indexPath.row + 1 == postArray.count {
                fetchData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        removeToolTip(indexPath: indexPath.row)
        
        if tableView == self.tableView {
            return
        }
        else {
            let post = postArray[tableView.tag]
            let params = ["post_id":post.id ?? "0"]
            
            if let popover = post.optionsPopover {
                popover.dismiss()
            }
            
            if post.user_id == ApplicationManager.sharedInstance.user.user_id {
                if post.content == "Has joined The Nex Network." {
                    return
                }
                else {
                    switch (indexPath.row)
                    {
                    case 0:
                        Router.editGeoPost(from: self,postObject: post)
                        
                    case 1:
                        if post.user_id == ApplicationManager.sharedInstance.user.user_id {
                            UIAlertController.showAlert(in: self, withTitle: "Confirm", message: "Are you sure you want to delete this post?", cancelButtonTitle: "No", destructiveButtonTitle: nil, otherButtonTitles: ["Yes"], tap: { (alertController, alertAction, buttonIndex) in
                                if alertAction.title == "Yes" {
                                    SVProgressHUD.show()
                                    RequestManager.deletePosts(param: params, successBlock: { (response) in
                                        self.fetchFreshData()
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
            }
            else {
                
                UIAlertController.showAlert(in: self, withTitle: "Confirm", message: "Are you sure you want to report this post?", cancelButtonTitle: "No", destructiveButtonTitle: nil, otherButtonTitles: ["Yes"], tap: { (alertController, alertAction, buttonIndex) in
                    if alertAction.title == "Yes" {
                        SVProgressHUD.show()
                        RequestManager.reportPosts(param: params, successBlock: { (response) in
                            self.fetchFreshData()
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
            
            
            let post = postArray[indexPath.row]
            var totalHeight : CGFloat = 130
            if let images = post.postImages {
                totalHeight += CGFloat(Float(self.tableView.frame.size.width) / (images.medium.aspect ?? 1.0))
            }
            if let content = post.content {
                totalHeight += (content as NSString).boundingRect(with: CGSize(width: self.view.frame.size.width - 27, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont(font: .Standard, size: 15.0)!], context: nil).size.height + 5
            }
//            if post.likeCount! > 0 || post.commentCount! > 0 {
                totalHeight += 19
//            }
//            else{
//                totalHeight += 5
//            }
            
            return totalHeight
        }
        else {
            return (CGFloat)(40)
        }
    }
    
    @objc func openImage(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath (row: sender.tag, section: 0)) as! GeoFeedBasicTableViewCell
        removeToolTip(indexPath: sender.tag)
        let image = LightboxImage(image: cell.postImageView.image!, text: cell.bodyLabel.text!, videoURL: nil)
        
        let controller = LightboxController(images: [image], startIndex: 0)
        
        controller.footerView.pageLabel.isHidden = true
        controller.footerView.separatorView.isHidden = true
        
        // Use dynamic background.
        controller.dynamicBackground = true
        
        // Present your controller.
        present(controller, animated: true, completion: nil)
        
    }
    
    @objc func showProfile(_ sender: UIButton) {
        let userID = postArray[sender.tag].user_id
        removeToolTip(indexPath: sender.tag)
        let user = User()
        user.user_id = userID
        Router.showProfileViewController(user: user, from: self)
    }
    
    @objc func likePostButtonPressed(_ sender: UIButton) {
        let post = postArray[sender.tag]
        
        var params = [String: AnyObject]()
        params["post_id"] = post.id as AnyObject
        params["user_id"] = ApplicationManager.sharedInstance.user.user_id as AnyObject
        params["post_action"] = !sender.isSelected ? "like" as AnyObject : "dislike" as AnyObject
        
        sender.isEnabled = false
        RequestManager.likePost(param: params, successBlock: { (response) in
            //            sender.isSelected = !sender.isSelected
            sender.isEnabled = true
            self.postArray[sender.tag].isSelfLiked = !sender.isSelected
            self.postArray[sender.tag].likeCount = response["postCount"] as? Int ?? 0
            self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: UITableViewRowAnimation.left)
        }) { (error) in
            
        }
        
    }
    
    @objc func commentPostButtonPressed(_ sender: UIButton) {
        let post = postArray[sender.tag]
        Router.showPostDetails(post: post, commentActive: true, from: self)
    }
    
    @objc func likeCommentButtonPressed(_ sender: UIButton) {
        let post = postArray[sender.tag]
        Router.showPostDetails(post: post, commentActive: false, from: self)
    }
    
    func removeToolTip(indexPath: Int) {
        for index in max(0,indexPath - 4) ... min(postArray.count-1,indexPath + 4) {
            if let tipView = postArray[index].easyTipView {
                postArray[index].isOptionsPopUpShowing = false
                tipView.delegate = nil
                tipView.dismiss()
            }
        }
    }
    
    @objc func showOptionsPopup(_ sender: UIButton) {
        
        var optionsHeight = 0
        let post = postArray[sender.tag]
        
        if post.user_id == ApplicationManager.sharedInstance.user.user_id {
            
            userOptionsArray = ["Edit", "Delete"]
            optionsHeight = userOptionsArray.count*35
        }
        else {
            userOptionsArray = ["Report"]
            optionsHeight = 30
        }
        
        var popover: Popover!
        
        let popoverOptions: [PopoverOption] = [
            .type(.auto),
            .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
        ]
        
        let optionsTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 160, height: optionsHeight))
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.isScrollEnabled = false
        optionsTableView.tag=sender.tag
        optionsTableView.accessibilityIdentifier = postTableID
        optionsTableView.register(UINib(nibName: "PopOverTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: PopOverTableViewCell.identifier)
        popover = Popover(options: popoverOptions)
        popover.show(optionsTableView, fromView: sender)
        
        post.optionsPopover = popover
        post.isOptionsPopUpShowing = true
        
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        
        
        if let buttonView = tipView.presentingView
        {
            self.postArray[buttonView.tag].isOptionsPopUpShowing = false
            let post = self.postArray[buttonView.tag]
            
            let params = ["post_id":post.id ?? "0"]
            
            if self.postArray[buttonView.tag].user_id == ApplicationManager.sharedInstance.user.user_id {
                
            }
                
                //            if self.postArray[buttonView.tag].user_id == ApplicationManager.sharedInstance.user.user_id {
                //                UIAlertController.showAlert(in: self, withTitle: "Confirm", message: "Are you sure you want to delete this post?", cancelButtonTitle: "No", destructiveButtonTitle: nil, otherButtonTitles: ["Yes"], tap: { (alertController, alertAction, buttonIndex) in
                //                    if alertAction.title == "Yes" {
                //                        SVProgressHUD.show()
                //                        RequestManager.deletePosts(param: params, successBlock: { (response) in
                //                            self.fetchFreshData()
                //                        }) { (error) in
                //                            UtilityManager.showErrorMessage(body: error, in: self)
                //                        }
                //                    }
                //                })
                //            }
            else{
                UIAlertController.showAlert(in: self, withTitle: "Confirm", message: "Are you sure you want to report this post?", cancelButtonTitle: "No", destructiveButtonTitle: nil, otherButtonTitles: ["Yes"], tap: { (alertController, alertAction, buttonIndex) in
                    if alertAction.title == "Yes" {
                        SVProgressHUD.show()
                        RequestManager.reportPosts(param: params, successBlock: { (response) in
                            self.fetchFreshData()
                        }) { (error) in
                            UtilityManager.showErrorMessage(body: error, in: self)
                        }
                    }
                })
            }
            
            
            
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        Router.showFilterScreen(from: self, filterText: self.selectedFilterValue)
    }
    
    @IBAction func createPostButtonPressed(_ sender: Any) {
        Router.showGeoPost(from: self)
        
    }
    
    
    
    //MARK: - - EmptyDataSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No posts found nearby"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes = [NSAttributedStringKey.font: UIFont(font: .Medium, size: 17.0) as Any,
                          NSAttributedStringKey.foregroundColor: UIColor(red: 170.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0),
                          NSAttributedStringKey.paragraphStyle: paragraphStyle] as [NSAttributedStringKey: Any]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Try reloading at a different location or widen your search"
        
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
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        
        SVProgressHUD.show()
        self.setupLocation()
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        SVProgressHUD.show()
        self.setupLocation()
    }
    
}

// Delegates to handle events for the location manager.
extension GeoFeedViewController: CLLocationManagerDelegate {
    
    @objc func setupLocation() {
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
    }
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        defaultLocation = location.coordinate
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        self.isNextPageAvailable = true
        self.fetchFreshData()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        // Display the map using the default location.
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
        locationManager.stopUpdatingLocation()
    }
}
