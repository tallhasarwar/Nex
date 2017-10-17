//
//  BusinessCardListViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 10/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class BusinessCardListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    static let storyboardID = "businessCardListViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessCardTableViewCell.identifier) as! BusinessCardTableViewCell
        let user = ApplicationManager.sharedInstance.user
        cell.nameLabel.text = user.full_name
        cell.headlineLabel.text = user.headline
        cell.emailLabel.text = user.email
        cell.phoneLabel.text = user.contact_number
        cell.websiteLabel.text = user.website
        cell.locationLabel.text = user.lives_in
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
