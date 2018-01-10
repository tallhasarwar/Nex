//
//  GeoFeedViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 31/12/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class GeoFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    static let storyboardID = "geoFeedViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    var postArray = [Post]()
    var pageNumber = 0
    var isNextPageAvailable = false
    var defaultLocation: CLLocationCoordinate2D?
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Geo Feed"

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        
        SVProgressHUD.show()
        self.setupLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - API calls
    
    func fetchData() {
        
        //http://localhost:3000/connectIn/api/v1/posts_feed?myPosts=yes&s_tags=ab,twist&latitude=31.447504395437022&longitude=74.36513375490904&page=0&raduis=500
        
        guard let location = defaultLocation else {
            return
        }
        
        if !isNextPageAvailable {
            return
        }
        
        var params = [String: AnyObject]()
        
        params["myPosts"] = "no" as AnyObject
        params["latitude"] = location.latitude as AnyObject
        params["longitude"] = location.longitude as AnyObject
        params["raduis"] = 30000 as AnyObject
        params["page"] = pageNumber as AnyObject
//        params["s_tags"] = "#photo" as AnyObject
        
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40))
        let loader = UtilityManager.activityIndicatorForView(view: view)
        loader.startAnimating()
        tableView.tableFooterView = view
        
        RequestManager.getPosts(param: params, successBlock: { (response) in
            SVProgressHUD.dismiss()
            self.tableView.tableFooterView = nil
            print(response)
            
            if response.count >= 15 {
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
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    //MARK: - tableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : GeoFeedBasicTableViewCell!
        
        let post = postArray[indexPath.row]
        
        if let image = post.image_path {
            cell = tableView.dequeueReusableCell(withIdentifier: "geoFeedImageTableViewCell") as! GeoFeedBasicTableViewCell
            cell.postImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder-banner"), options: .refreshCached, completed: nil)
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: GeoFeedBasicTableViewCell.identifier) as! GeoFeedBasicTableViewCell
        }
        
//        geoFeedImageTableViewCell
        
        
        
        
        cell.bodyLabel.text = post.content
        if post.location_name != nil {
            cell.atLabel.isHidden = false
            cell.locationButton.isHidden = false
            cell.locationButton.setTitle(post.location_name, for: .normal)
        }
        else{
            cell.atLabel.isHidden = true
            cell.locationButton.isHidden = true
        }
        
        cell.profileNameButton.setTitle(post.full_name, for: .normal)
        cell.profileImageView.sd_setImage(with: URL(string: post.user_image ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: .refreshCached, completed: nil)
        cell.timeLabel.text = UtilityManager.timeAgoSinceDate(date: post.created_at!, numericDates: true)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isNextPageAvailable == true {
            if indexPath.row + 3 == postArray.count {
                fetchData()
            }
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func filterButtonPressed(_ sender: Any) {
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
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        defaultLocation = location.coordinate
        locationManager.stopUpdatingLocation()
        self.isNextPageAvailable = true
        self.fetchData()
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
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
