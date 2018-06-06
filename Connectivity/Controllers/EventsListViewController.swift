//
//  EventsListViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 02/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class EventsListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    static let storyboardID = "eventsListViewController"
    
    @IBOutlet weak var searchField: DesignableTextField!
    @IBOutlet weak var tableView: TPKeyboardAvoidingTableView!
    
    var events = [Event]()
    var coordinates: CLLocationCoordinate2D?
    var isLocationBased : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "My Events"
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        
        
        SVProgressHUD.show()
//        fetchData()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if isLocationBased {
            title = "Nearby Events"
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData(searchString: nil)
    }
    
    func fetchData(searchString: String?) {
        if isLocationBased {
            var params = [String: AnyObject]()
            if let coords = coordinates {
                params["latitude"] = coords.latitude as AnyObject
                params["longitude"] = coords.longitude as AnyObject
            }
            
            params["page"] = 0 as AnyObject
            
            if let query = searchString {
                params["s_str"] = query as AnyObject
            }
            
            RequestManager.getNearbyEvents(param: params, successBlock: { (response) in
                SVProgressHUD.dismiss()
                self.events.removeAll()
                for object in response {
                    self.events.append(Event(dictionary: object))
                }
                self.tableView.reloadData()
            }, failureBlock: { (error) in
                SVProgressHUD.dismiss()
            })
        }
        else{
            var params = [String: AnyObject]()
            params["page"] = 0 as AnyObject
            if let query = searchString {
                params["s_str"] = query as AnyObject
            }
            
            RequestManager.getAllEvents(param: params, successBlock: { (response) in
                SVProgressHUD.dismiss()
                self.events.removeAll()
                for object in response {
                    self.events.append(Event(dictionary: object))
                }
                self.tableView.reloadData()
            }) { (error) in
                SVProgressHUD.dismiss()
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventsListTableViewCell.identifier) as! EventsListTableViewCell
        let event = events[indexPath.row]
        
        if let radius = event.distance {
            cell.radiusLabel.text = "(\(radius) away)"
        }
        else {
            cell.radiusLabel.text = ""
        }
        
        cell.nameLabel.text = event.name
        cell.addressLabel.text = event.location
        cell.eventImageView.sd_setImage(with: URL(string: event.eventImages.small.url), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        if let startDate = event.start_date, let endDate = event.end_date{
            cell.timeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: startDate, format: Constant.eventDateFormat) + " - " + UtilityManager.stringFromNSDateWithFormat(date: endDate, format: Constant.eventDateFormat)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        Router.showEventDetail(event: event, from: self)
    }
    
    //MARK: - - EmptyDataSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No events found."
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes = [NSAttributedStringKey.font: UIFont(font: .Medium, size: 17.0) as Any,
                          NSAttributedStringKey.foregroundColor: UIColor(red: 170.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0),
                          NSAttributedStringKey.paragraphStyle: paragraphStyle] as [NSAttributedStringKey: Any]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = ""
        
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
        
        let attributes = [NSAttributedStringKey.font: UIFont(font: .SemiBold, size: 14.0) as Any,
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
    
    
    @IBAction func newButtonPressed(_ sender: Any) {
        Router.showCreateEventController(from: self)
    }
    
    @IBAction func searchFieldChanged(_ sender: Any) {
        if let text = searchField.text {
            fetchData(searchString: text)
        }
    }
    
    @IBAction func cancelSearchButtonPressed(_ sender: Any) {
        searchField.resignFirstResponder()
        searchField.text = ""
        fetchData(searchString: nil)
    }
}
