//
//  MoreViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 02/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let items = [["image":"business-card-icon","title":"My Business Card"], ["image":"events-icon","title":"My Events"], ["image":"settings-icon","title":"Settings"],["image":"","title":"Logout"]] as [[String: String]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "More"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoreTableViewCell.identifier) as! MoreTableViewCell
        
        if indexPath.row == 0 {
            cell.detailImageView.layer.cornerRadius = cell.detailImageView.frame.height/2
            cell.detailImageView.layer.masksToBounds = true
            cell.mainLabel.text = ApplicationManager.sharedInstance.user.full_name
            cell.descriptionLabel.text = ApplicationManager.sharedInstance.user.headline
        }
        else{
            cell.detailImageView.image = UIImage(named: items[indexPath.row-1]["image"]!)
            cell.mainLabel.text = items[indexPath.row-1]["title"]
            cell.detailImageView.contentMode = .center
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            Router.showProfileViewController(user: ApplicationManager.sharedInstance.user, publicProfile: false, from: self)
        case 1:
            Router.showBusinessCard(from: self)
        case 2:
            print("My Events")
        case 3:
            print("Settings")
        case 4:
            Router.logout()
        default:
            break
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
