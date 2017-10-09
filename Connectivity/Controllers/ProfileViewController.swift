//
//  ProfileViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 24/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    static let storyboardID = "profileViewController"
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileNameLabel.text = ApplicationManager.sharedInstance.user.full_name
        jobTitleLabel.text = ApplicationManager.sharedInstance.user.headline
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == -1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImagesTableViewCell.identifier) as! ProfileImagesTableViewCell
            return cell
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDetailTableViewCell.identifier) as! ProfileDetailTableViewCell
            let user = ApplicationManager.sharedInstance.user
            switch indexPath.row {
            case 0:
                cell.headingLabel.text = "About Me"
                cell.descriptionLabel.text = user.about ?? "N/A"
            case 1:
                cell.headingLabel.text = "Interests"
                cell.descriptionLabel.text = user.interests ?? "N/A"
            case 2:
                cell.headingLabel.text = "School / University"
                cell.descriptionLabel.text = user.school ?? "N/A"
            case 3:
                cell.headingLabel.text = "Works At"
                cell.descriptionLabel.text = user.worked_at ?? "N/A"
            case 4:
                cell.headingLabel.text = "Lives In"
                cell.descriptionLabel.text = user.lives_in ?? "N/A"
            case 5:
                cell.headingLabel.text = "Email Address"
                cell.descriptionLabel.text = user.email ?? "N/A"
            case 6:
                cell.headingLabel.text = "Phone Number"
                cell.descriptionLabel.text = user.contact_number ?? "N/A"
            case 7:
                cell.headingLabel.text = "Facebook Profile"
                cell.descriptionLabel.text = user.facebook_profile ?? "N/A"
            case 8:
                cell.headingLabel.text = "LinkedIn Profile"
                cell.descriptionLabel.text = user.linkedin_profile ?? "N/A"
            case 9:
                cell.headingLabel.text = "Website"
                cell.descriptionLabel.text = user.website ?? "N/A"
                
            default:
                break
            }
            
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
