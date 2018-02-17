//
//  BusinessCardListViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 10/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class BusinessCardListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    static let storyboardID = "businessCardListViewController"
    
    var businesscard: BusinessCard?
    var isEditShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        tableView.tableFooterView = UIView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func fetchData() {
        SVProgressHUD.show()
        RequestManager.getBusinessCard(param: [:], successBlock: { (response) in
            SVProgressHUD.dismiss()
            self.businesscard = BusinessCard(dictionary: response)
            self.tableView.reloadData()
        }) { (error) in
            SVProgressHUD.dismiss()
            if !self.isEditShown {
                self.isEditShown = true
                Router.showBusinessCardDetails(businessCard: nil, from: self)
                
            }
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesscard == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessCardTableViewCell.identifier) as! BusinessCardTableViewCell

        if let card = businesscard {
            cell.nameLabel.text = card.name
            cell.headlineLabel.text = card.title
            cell.emailLabel.text = card.email
            cell.phoneLabel.text = card.phone
            cell.websiteLabel.text = card.web
            cell.locationLabel.text = card.address
            cell.profileImageView.sd_setImage(with: URL(string: card.profileImages.medium.url), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        let card = businesscard
        Router.showBusinessCardDetails(businessCard: card, from: self)
        
        
    }
    
    //MARK : - EmptyDataSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Business Card Found"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes : [String: Any] = [NSFontAttributeName: UIFont(font: .Medium, size: 17.0) as Any,
                          NSForegroundColorAttributeName: UIColor(red: 170.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0),
                          NSParagraphStyleAttributeName: paragraphStyle]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Get started by adding a business card from the top right"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes : [String: Any] = [NSFontAttributeName: UIFont(font: .Standard, size: 15.0) as Any,
                                          NSForegroundColorAttributeName: UIColor(red: 170.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0),
                                          NSParagraphStyleAttributeName: paragraphStyle]
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
        
        let attributes : [String: Any] = [NSFontAttributeName: UIFont(font: .SemiBold, size: 14.0) as Any,
                                          NSForegroundColorAttributeName: color,
                                          NSParagraphStyleAttributeName: paragraphStyle]
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
        fetchData()
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
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
