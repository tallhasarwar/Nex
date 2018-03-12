//
//  LocationDetailsViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 08/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    var place : GooglePlace?
    var users = [User]()
    
    static let storyboardID = "locationDetailsViewController"

    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addressLabel: UILabel!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = place!.name
        addressLabel.text = place!.vicinity
        if let imageRef = place?.imageReference {
            let activityIndicator = UtilityManager.activityIndicatorForView(view: locationImageView)
            activityIndicator.startAnimating()
            locationImageView.sd_setImage(with: URL(string: imageRef), placeholderImage: UIImage(named: "placeholder-banner"), options: SDWebImageOptions.refreshCached, completed:{ (image, error, cacheType, url) in
                activityIndicator.stopAnimating()
            })
            
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
    
    @objc func refreshTableView() {
        fetchData()
    }
    
    func fetchData() {
        
        var params = [String: AnyObject]()
        params["location_id"] = place?.place_id as AnyObject
        params["location_name"] = place?.name as AnyObject
        
        RequestManager.checkinLocation(param: params, successBlock: { (response) in
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
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, constrainedTo: locationImageView.frame.size, scale: view.window?.screen.scale ?? 1) { (photo, error) in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                self.locationImageView.image = photo
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationDetailTableViewCell.identifier) as! LocationDetailTableViewCell
        let user = users[indexPath.row]
        cell.nameLabel.text = user.full_name
        cell.headlineLabel.text = user.headline
        cell.profileImageView.sd_setImage(with: URL(string: user.profileImages.small.url ), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        if let tagline = user.tagline, tagline.count > 0 {
            cell.taglineLabel.text = "\"\(tagline)\""
        }
        else{
            cell.taglineLabel.text = nil
        }
        cell.activationTimeLabel.text = "active\n" + UtilityManager.timeAgoSinceDate(date: user.checkin_time!, numericDates: true)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        Router.showProfileViewController(user: user, from: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - - EmptyDataSource Methods
    
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
        let text = "Try out some other nearby locations for recently checked in users"
        
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
        fetchData()
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        SVProgressHUD.show()
        fetchData()
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
