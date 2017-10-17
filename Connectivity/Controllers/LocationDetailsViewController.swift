//
//  LocationDetailsViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 08/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var place : GMSPlace?
    var users = [User]()
    
    static let storyboardID = "locationDetailsViewController"

    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = place!.name
        
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: place!.placeID) { (photos, error) in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var params = [String: AnyObject]()
        params["location_id"] = place?.placeID as AnyObject
        params["location_name"] = place?.name as AnyObject
        
        RequestManager.checkinLocation(param: params, successBlock: { (response) in
            self.users.removeAll()
            for object in response {
                self.users.append(User(dictionary: object))
            }
            self.tableView.reloadData()
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
        
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                self.locationImageView.image = photo
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationDetailTableViewCell.identifier) as! LocationDetailTableViewCell
        let user = users[indexPath.row]
        cell.nameLabel.text = user.full_name
        cell.headlineLabel.text = user.headline
        cell.profileImageView.sd_setImage(with: URL(string: user.image_path ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
//        cell.profileImageView.sd_setImage(with: , completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        Router.showProfileViewController(user: user, publicProfile: true, from: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
