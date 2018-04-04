//
//  CreateEventViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 04/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import LocationPicker

protocol EventEditDelegate {
    func eventEdited(event: Event)
}

class CreateEventViewController: BaseViewController, LocationSelectionDelegate {

    static let storyboardID = "createEventViewController"
    
    var isEditingMode = false
    var event : Event?
    var editingDelegate : EventEditDelegate?
    
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
        
        eventImageView.aspectRatio = "16:9"
        eventImageView.lockAspect = true
        startTimeLabel.pickerView.minimumDate = NSDate() as Date
        startTimeLabel.pickerView.datePickerMode = UIDatePickerMode.dateAndTime
        startTimeLabel.pickerView.maximumDate = nil
        
        locationLabel.isEnabled = false
        locationLabel.backgroundColor = UIColor(white: 0.85, alpha: 0.7)
        
        
        endTimeLabel.pickerView.minimumDate = NSDate() as Date
        endTimeLabel.pickerView.datePickerMode = UIDatePickerMode.dateAndTime
        endTimeLabel.pickerView.maximumDate = nil

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDatePickers(notification:)), name: NSNotification.Name(rawValue: "datePickerTextFieldTextChanged"), object: nil)
        
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
    
    @objc func updateDatePickers(notification: NSNotification) {
        if let date = startTimeLabel.date {
            endTimeLabel.pickerView.minimumDate = date
        }
        if let date = endTimeLabel.date {
            startTimeLabel.pickerView.maximumDate = date
        }
    }
    
    func populateFields() {
        if let event = self.event {
            self.nameLabel.text = event.name
            self.locationLabel.text = event.location
            self.radiusLabel.text = event.raduis
            self.descriptionTextView.text = event.descriptionValue
//            event.
            
            self.selectedLocation = CLLocationCoordinate2D(latitude: Double(event.latitude ?? "0")!, longitude: Double(event.longitude ?? "0")!)
            self.startTimeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: event.start_date!, format: Constant.appDateFormat)
            self.endTimeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: event.end_date!, format: Constant.appDateFormat)
            self.eventImageView.sd_setImage(with: URL(string: event.eventImages.medium.url), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        }
    }
    
    
    @objc func saveButtonPressed() {
        
        self.view.endEditing(true)
        
        guard let location = selectedLocation else {
            
            UtilityManager.showErrorMessage(body: "Please select a location on the map", in: self)
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
            SVProgressHUD.showSuccess(withStatus: "Event Saved")
            let event = Event(dictionary: response)
            if let organizer = self.event?.organizerModel {
                event.organizerModel = organizer
                self.editingDelegate?.eventEdited(event: event)
            }
            
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            UtilityManager.showErrorMessage(body: error, in: self)
        }
    }
    
    
    func openLocation() {
        Router.showLocationSelection(from: self, isEventScreen: true, isPostScreen: false)
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        openLocation()
    }
    
    func didSelectLocation(location: CLLocationCoordinate2D, address: String?) {
        self.selectedLocation = location
        if let add = address {
            self.locationLabel.text = add
        }
        else{
            var params = [String: AnyObject]()
            
            params["key"] = Constant.googlePlacesKey as AnyObject
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
