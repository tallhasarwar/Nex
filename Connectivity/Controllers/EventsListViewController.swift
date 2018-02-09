//
//  EventsListViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 02/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class EventsListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

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
        fetchData()
    }
    
    func fetchData() {
        if isLocationBased {
            var params = [String: AnyObject]()
            if let coords = coordinates {
                params["latitude"] = coords.latitude as AnyObject
                params["longitude"] = coords.longitude as AnyObject
            }
            
            params["page"] = 0 as AnyObject
            
            SVProgressHUD.show()
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
            RequestManager.getAllEvents(param: ["page":0], successBlock: { (response) in
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
    
    
    @IBAction func newButtonPressed(_ sender: Any) {
        Router.showCreateEventController(from: self)
    }
    
}
