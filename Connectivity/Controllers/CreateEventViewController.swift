//
//  CreateEventViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 04/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import LocationPicker

class CreateEventViewController: BaseViewController, LocationSelectionDelegate {

    static let storyboardID = "createEventViewController"
    
    var isEditingMode = false
    var event : Event?
    
    @IBOutlet weak var eventImageView: DZImageView!
    @IBOutlet weak var nameLabel: DesignableTextField!
    @IBOutlet weak var locationLabel: DesignableTextField!
    @IBOutlet weak var radiusLabel: DesignableTextField!
    @IBOutlet weak var startTimeLabel: DatePickerTextField!
    @IBOutlet weak var endTimeLabel: DatePickerTextField!
    @IBOutlet weak var descriptionTextView: DesignableTextView!
    
//    let locationPicker = LocationPickerViewController()
    var selectedLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        eventImageView.parentController = self
        eventImageView.layer.cornerRadius = 0
        
        startTimeLabel.pickerView.minimumDate = NSDate() as Date
        startTimeLabel.pickerView.datePickerMode = UIDatePickerMode.dateAndTime
        startTimeLabel.pickerView.maximumDate = nil
        
        
        endTimeLabel.pickerView.minimumDate = NSDate() as Date
        endTimeLabel.pickerView.datePickerMode = UIDatePickerMode.dateAndTime
        endTimeLabel.pickerView.maximumDate = nil
        
        
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(self.saveButtonPressed))
        navigationItem.rightBarButtonItem = button
        
        if isEditingMode {
            populateFields()
            title = "Edit Event"
        }
        else{
            title = "Create Event"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateFields() {
        if let event = self.event {
            self.nameLabel.text = event.name
            self.locationLabel.text = event.location
            self.radiusLabel.text = event.raduis
            self.descriptionTextView.text = event.description
//            event.
            
            self.selectedLocation = CLLocationCoordinate2D(latitude: Double(event.latitude ?? "0")!, longitude: Double(event.longitude ?? "0")!)
            self.startTimeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: event.start_date!, format: Constant.appDateFormat)
            self.endTimeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: event.end_date!, format: Constant.appDateFormat)
            self.eventImageView.sd_setImage(with: URL(string: event.image_path ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        }
    }
    
    
    func saveButtonPressed() {
        
        guard let location = selectedLocation else {
            SVProgressHUD.showError(withStatus: "Please select a location on the map")
            return
        }
        
        var params = [String: Any]()
        params["name"] = nameLabel.text
        params["location"] = locationLabel.text
//        params["raduis"] = radiusLabel.text
        params["start_date"] = UtilityManager.serverDateStringFromAppDateString(dateString: startTimeLabel.text!)
        params["end_date"] = UtilityManager.serverDateStringFromAppDateString(dateString: endTimeLabel.text!)
        params["description"] = descriptionTextView.text
        params["latitude"] = location.latitude
        params["longitude"] = location.longitude
        
        if isEditingMode {
            params["event_id"] = event!.id
        }

        SVProgressHUD.show()
        RequestManager.addEvent(param: params, image: eventImageView.image!, successBlock: { (response) in
            SVProgressHUD.showSuccess(withStatus: "Event Created")
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    
    func openLocation() {
        Router.showLocationSelection(from: self)
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        openLocation()
    }
    
    func didSelectLocation(location: CLLocationCoordinate2D) {
        self.selectedLocation = location
        
        var params = [String: AnyObject]()
        
        params["key"] = "AIzaSyByRuCinleTQVigifuFU0-AOqvnEFieEYo" as AnyObject
        
        
        params["latlng"] = "\(location.latitude),\(location.longitude)" as AnyObject
        
        
        SVProgressHUD.show()
        RequestManager.getAddressForCoords(param: params, successBlock: { (response) in
            print(response)
            if let address = response.first?["formatted_address"] as? String {
                self.locationLabel.text = address
            }
            SVProgressHUD.dismiss()
        }) { (error) in
            print(error)
            SVProgressHUD.dismiss()
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
