//
//  BusinessCardListViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 10/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class BusinessCardListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    static let storyboardID = "businessCardListViewController"
    
    var businesscard = BusinessCard()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.show()
        RequestManager.getBusinessCard(param: [:], successBlock: { (response) in
            SVProgressHUD.dismiss()
            self.businesscard = BusinessCard(dictionary: response)
            self.tableView.reloadData()
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
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

        cell.nameLabel.text = businesscard.name
        cell.headlineLabel.text = businesscard.title
        cell.emailLabel.text = businesscard.email
        cell.phoneLabel.text = businesscard.phone
        cell.websiteLabel.text = businesscard.web
        cell.locationLabel.text = businesscard.address
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
