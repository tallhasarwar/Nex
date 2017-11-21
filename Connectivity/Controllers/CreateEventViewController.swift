//
//  CreateEventViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 04/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class CreateEventViewController: BaseViewController {

    static let storyboardID = "createEventViewController"
    
    @IBOutlet weak var eventImageView: DZImageView!
    @IBOutlet weak var nameLabel: DesignableTextField!
    @IBOutlet weak var locationLabel: DesignableTextField!
    @IBOutlet weak var radiusLabel: DesignableTextField!
    @IBOutlet weak var startTimeLabel: DatePickerTextField!
    @IBOutlet weak var endTimeLabel: DatePickerTextField!
    @IBOutlet weak var descriptionTextView: DesignableTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        eventImageView.parentController = self
        eventImageView.layer.cornerRadius = 0
        
        startTimeLabel.pickerView.minimumDate = NSDate() as Date
        startTimeLabel.pickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        endTimeLabel.pickerView.minimumDate = NSDate() as Date
        endTimeLabel.pickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(self.saveButtonPressed))
        navigationItem.rightBarButtonItem = button
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func saveButtonPressed() {
        var params = [String: Any]()
        params["name"] = nameLabel.text
        params["location"] = locationLabel.text
        params["raduis"] = radiusLabel.text
        params["start_date"] = UtilityManager.serverDateStringFromAppDateString(dateString: startTimeLabel.text!)
        params["end_date"] = UtilityManager.serverDateStringFromAppDateString(dateString: endTimeLabel.text!)
        params["description"] = descriptionTextView.text
        
        SVProgressHUD.show()
        RequestManager.addEvent(param: params, image: eventImageView.image!, successBlock: { (response) in
            SVProgressHUD.showSuccess(withStatus: "Event Created")
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
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
