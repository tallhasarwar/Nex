//
//  ConnectionsListViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 15/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ConnectionsListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    static let storyboardID = "connectionsListViewController"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: DesignableTextField!
    
    var usersArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Connections"
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
        tableView.tableFooterView = UIView()
        
        SVProgressHUD.show()
//        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData(searchString: nil)
    }
    
    func fetchData(searchString: String?) {
        
        var params = [String: AnyObject]()
        params["page"] = 0 as AnyObject
        if let text = searchString {
            params["s_str"] = text as AnyObject
        }
        RequestManager.getConnections(param: params, successBlock: { (response) in
            self.usersArray.removeAll()
            for object in response {
                self.usersArray.append(User(dictionary: object))
            }
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }) { (error) in
            SVProgressHUD.dismiss()
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConnectionListTableViewCell.identifier) as! ConnectionListTableViewCell
        let user = self.usersArray[indexPath.row]
        cell.nameLabel.text = user.full_name
        cell.headlineLabel.text = user.headline
        cell.profileImageView.sd_setImage(with: URL(string: user.profileImages.small.url), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.showProfileViewController(user: usersArray[indexPath.row], from: self)
    }
    
    //MARK : - EmptyDataSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Connections Found"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes = [NSAttributedStringKey.font: UIFont(font: .Medium, size: 17.0) as Any,
                                          NSAttributedStringKey.foregroundColor: UIColor(red: 170.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0),
                                          NSAttributedStringKey.paragraphStyle: paragraphStyle] as [NSAttributedStringKey: Any]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Add connections by sending them a connection request"
        
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
        
        let attributes  = [NSAttributedStringKey.font: UIFont(font: .SemiBold, size: 14.0) as Any,
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
        fetchData(searchString: nil)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        SVProgressHUD.show()
        fetchData(searchString: nil)
    }
    
    
    @IBAction func searchTextChanged(_ sender: Any) {
        if let text = searchBar.text {
            fetchData(searchString: text)
        }
        
    }
    
    @IBAction func cancelSearchButtonPressed(_ sender: Any) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        fetchData(searchString: nil)
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
