//
//  GeoFeedViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 31/12/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class GeoFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersDelegate, EasyTipViewDelegate {
    
    static let storyboardID = "geoFeedViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    var postArray = [Post]()
    var pageNumber = 0
    var isNextPageAvailable = false
    var defaultLocation: CLLocationCoordinate2D?
    var locationManager = CLLocationManager()
    var filterValue: String?
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Geo Feed"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //        tableView.rowHeight = UITableViewAutomaticDimension
        //        tableView.estimatedRowHeight = 80
        
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(setupLocation), for: UIControlEvents.valueChanged)
        
        SVProgressHUD.show()
        self.setupLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchFreshData), name: NSNotification.Name(rawValue: "selfPostAdded"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.setupLocation), name: NSNotification.Name(rawValue: "refreshLocation"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - API calls
    
    func didChangeFilters(hashtags: String?) {
        filterValue = hashtags
        fetchFreshData()
    }
    
    
    func fetchFreshData() {
        isNextPageAvailable = true
        pageNumber = 0
        fetchData()
    }
    
    func fetchData() {
        
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
            params["radius"] = radiusValue * 1000 as AnyObject
        }
        else{
            params["radius"] = 10000 as AnyObject
        }
        
        params["page"] = pageNumber as AnyObject
        
        if let filters = filterValue {
            params["s_tags"] = filters as AnyObject
        }
        
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40))
        let loader = UtilityManager.activityIndicatorForView(view: view)
        loader.startAnimating()
        tableView.tableFooterView = view
        
        RequestManager.getPosts(param: params, successBlock: { (response) in
            SVProgressHUD.dismiss()
            self.tableView.tableFooterView = nil
            self.refreshControl.endRefreshing()
            print(response)
            
            if self.pageNumber == 0 {
                self.postArray.removeAll()
            }
            
            if response.count >= 1 {
                self.isNextPageAvailable = true
                self.pageNumber += 1
            }
            else {
                self.isNextPageAvailable = false
            }
            
            for object in response {
                self.postArray.append(Post(dictionary: object))
            }
            self.tableView.reloadData()
            
        }) { (error) in
            UtilityManager.showErrorMessage(body: error, in: self)
        }
    }
    
    //MARK: - tableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : GeoFeedBasicTableViewCell!
        
        let post = postArray[indexPath.row]
        
        if let images = post.postImages {
            cell = tableView.dequeueReusableCell(withIdentifier: "geoFeedImageTableViewCell") as! GeoFeedBasicTableViewCell
            let calculatedHeight = Float(self.tableView.frame.size.width) / (images.medium.aspect ?? 1.0)
            cell.postImageHeightConstraint.constant = CGFloat(calculatedHeight)
            
            cell.postImageView.sd_setImage(with: URL(string: images.medium.url), placeholderImage: UIImage(named: "placeholder-banner"), options: .refreshCached, completed: { (image, error, cacheType, url) in
                
            })
            cell.imageOverlayButton.tag = indexPath.row
            cell.imageOverlayButton.addTarget(self, action: #selector(GeoFeedViewController.openImage(_:)), for: .touchUpInside)
            
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: GeoFeedBasicTableViewCell.identifier) as! GeoFeedBasicTableViewCell
        }
        
        //        geoFeedImageTableViewCell
        
        cell.bodyLabel.text = post.content
        if post.location_name != nil {
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
        cell.profileImageView.sd_setImage(with: URL(string: post.profileImages.small.url), placeholderImage: UIImage(named: "placeholder-image"), options: .refreshCached, completed: nil)
        cell.timeLabel.text = UtilityManager.timeAgoSinceDate(date: post.created_at!, numericDates: true)
        
//        if post.user_id == ApplicationManager.sharedInstance.user.user_id {
            cell.optionsButton.isHidden = false
            cell.trailingSpaceToOptionsButton.constant = 0
            cell.optionsButton.tag = indexPath.row
            cell.optionsButton.addTarget(self, action: #selector(self.showDeletionPopup(_:)), for: .touchUpInside)
//        }
//        else{
//            cell.optionsButton.isHidden = true
//            cell.trailingSpaceToOptionsButton.constant = -22
//        }
        
        if let tipView = post.easyTipView {
            post.isDeletionPopUpShowing = false
            tipView.delegate = nil
            tipView.dismiss()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isNextPageAvailable == true {
            if indexPath.row + 3 == postArray.count {
                fetchData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in max(0,indexPath.row-4) ... min(postArray.count-1,indexPath.row+4) {
            if let tipView = postArray[index].easyTipView {
                postArray[index].isDeletionPopUpShowing = false
                tipView.delegate = nil
                tipView.dismiss()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = postArray[indexPath.row]
        var totalHeight : CGFloat = 81
        if let images = post.postImages {
            
            totalHeight += CGFloat(Float(self.tableView.frame.size.width) / (images.medium.aspect ?? 1.0))
            
            
        }
        if let content = post.content {
            totalHeight += (content as NSString).boundingRect(with: CGSize(width: self.view.frame.size.width - 27, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(font: .Standard, size: 14.0)!], context: nil).size.height + 5
        }
        return totalHeight
    }
    
    func openImage(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath (row: sender.tag, section: 0)) as! GeoFeedBasicTableViewCell
        
        let image = LightboxImage(image: cell.postImageView.image!, text: cell.bodyLabel.text!, videoURL: nil)
        
        let controller = LightboxController(images: [image], startIndex: 0)
        
        controller.footerView.pageLabel.isHidden = true
        controller.footerView.separatorView.isHidden = true
        
        // Use dynamic background.
        controller.dynamicBackground = true
        
        // Present your controller.
        present(controller, animated: true, completion: nil)
        
    }
    
    func showProfile(_ sender: UIButton) {
        let userID = postArray[sender.tag].user_id
        
        let user = User()
        user.user_id = userID
        Router.showProfileViewController(user: user, from: self)
    }
    
    func showDeletionPopup(_ sender: UIButton) {
        

        if (!self.postArray[sender.tag].isDeletionPopUpShowing){
            let tipView : EasyTipView
            
            if postArray[sender.tag].user_id == ApplicationManager.sharedInstance.user.user_id {
                tipView = EasyTipView(text: "     Delete        ", delegate: self)
            }
            else{
                tipView = EasyTipView(text: "     Report        ", delegate: self)
            }
            
            tipView.show(animated: true, forView: sender, withinSuperview: sender.superview)
//            EasyTipView.show(animated: true, forView: sender, withinSuperview: sender.superview, text: "Delete", delegate: self)
            self.postArray[sender.tag].easyTipView = tipView
            self.postArray[sender.tag].isDeletionPopUpShowing = true
        }
        else{
            self.postArray[sender.tag].isDeletionPopUpShowing = false
            if let tipView = self.postArray[sender.tag].easyTipView{
                tipView.delegate = nil
                tipView.dismiss()
            }
        }
        

//        UIAlertController.showAlert(in: self, withTitle: "Confirm", message: "Are you sure you want to delete the post?", cancelButtonTitle: "OK", destructiveButtonTitle: nil, otherButtonTitles: nil) { (alert, action, index) in
//            let post = self.postArray[sender.tag]
//
//            let params = ["post_id":post.id ?? "0"]
//            SVProgressHUD.show()
//            RequestManager.deletePosts(param: params, successBlock: { (response) in
//                self.fetchFreshData()
//            }) { (error) in
//                UtilityManager.showErrorMessage(body: error, in: self)
//            }
//        }

        
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        

        if let buttonView = tipView.presentingView
        {
            self.postArray[buttonView.tag].isDeletionPopUpShowing = false
            let post = self.postArray[buttonView.tag]

            let params = ["post_id":post.id ?? "0"]
            
            if self.postArray[buttonView.tag].user_id == ApplicationManager.sharedInstance.user.user_id {
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
        Router.showFilterScreen(from: self)
    }
    
    @IBAction func createPostButtonPressed(_ sender: Any) {
        Router.showGeoPost(from: self)
        
    }
    
}

// Delegates to handle events for the location manager.
extension GeoFeedViewController: CLLocationManagerDelegate {
    
    func setupLocation() {
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
