//
//  ProfileViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 24/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let profileDetails = [ProfileDetail(title: "About", description: "This is a very long string. This is a very long string. This is a very long string. This is a very long string. This is a very long string. This is a very long string. This is a very long string. This is a very long string. This is a very long string. This is a very long string. This is a very long string. "),ProfileDetail(title: "Interests", description: "Adventure | Climbing | Cliff Jumping | Book Reading | Movies")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        tableView.separatorStyle = .none
        
        title = "Profile"
        self.tabBarItem.title = ""
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileDetails.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImagesTableViewCell.identifier) as! ProfileImagesTableViewCell
            return cell
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDetailTableViewCell.identifier) as! ProfileDetailTableViewCell
            let profileDetail = profileDetails[indexPath.row-1]
            cell.headingLabel.text = profileDetail.title
            cell.descriptionLabel.text = profileDetail.detailDescription
            return cell
        }
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
