//
//  LikesDetailViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 6/9/18.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class LikesDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    static let storyboardID = "likesDetailViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    var likesArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        title = likesArray.count == 1 ? "\(likesArray.count) Like" : "\(likesArray.count) Likes"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationDetailTableViewCell.likesIdentified) as! LocationDetailTableViewCell
        
        let user = self.likesArray[indexPath.row]
        
        cell.nameLabel.text = user.full_name
        cell.headlineLabel.text = user.headline
        cell.profileImageView.sd_setImage(with: URL(string: user.profileImages.small.url ), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.showProfileViewController(user: self.likesArray[indexPath.row], from: self)
    }
    

    

}
