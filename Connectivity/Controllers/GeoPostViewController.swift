//
//  GeoPostViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 02/01/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit
import CameraViewController
import Photos

class GeoPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationSelectionDelegate, UITextViewDelegate, SuggestionTableDelegate {
    
    static let storyboardID = "geoPostViewController"
    
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var bodyTextView: FloatLabelTextView!
    @IBOutlet var postBar: UIView!
    @IBOutlet weak var atLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var postButton: DesignableButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var bodyTextViewHeightConstraint: NSLayoutConstraint!
    
    var postType : PostType = .newPost
    var postObject = Post()
    
    var selectedImage: UIImage?
    var selectedLocation: CLLocationCoordinate2D?
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    var suggestionsTable: SuggestionTable!
    
    override var inputAccessoryView: UIView? {
        get {
            self.postBar.frame.size.height = 60
            self.postBar.clipsToBounds = true
            return self.postBar
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyTextView.delegate = self
        suggestionsTable = SuggestionTable(over: bodyTextView, in: self)
        
        switch postType {
        case .newPost:
            postButton.setTitle("Post", for: UIControlState.normal)
        case .editPost:
            postButton.setTitle("Save", for: UIControlState.normal)
            
            if let postContenct = postObject.content {
                bodyTextView.text = postContenct
                self.textViewDidChange(self.bodyTextView)
            }
            
            if let images = postObject.postImages {
                previewImage.sd_setImage(with: URL(string: (images.medium.url)), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: { (image, error, cacheType, url) in
                    self.bodyTextView.layoutSubviews()
                    self.imageButton.isHidden = false
                    self.textViewDidChange(self.bodyTextView)
                })
            }
            
            if (postObject.location_name?.count) != 0 {
                self.atLabel.isHidden = false
                locationAddressLabel.isHidden = false
                locationAddressLabel.text = postObject.location_name
            }
            selectedLocation = CLLocationCoordinate2D()
            if let latitude = postObject.latitude {
                selectedLocation?.latitude = (latitude as NSString).doubleValue
            }
            if let longitude = postObject.longitude {
                selectedLocation?.longitude = (longitude as NSString).doubleValue
            }
        
        }
        
        let user = ApplicationManager.sharedInstance.user
        
        profileNameLabel.text = user.full_name
        profileImageView.sd_setImage(with: URL(string: user.profileImages.small.url), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        postButton.isEnabled = false
        
        setupLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bodyTextView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hashtagButtonPressed(_ sender: Any) {
        if bodyTextView.text.last == " " {
            bodyTextView.text.append("#")
        }
        else{
            bodyTextView.text.append(" #")
        }
        
        bodyTextView.layoutSubviews()
        self.textViewDidChange(bodyTextView)
    }
    
    @IBAction func imageButtonPressed(_ sender: Any) {
        self.cameraButtonPressed(sender)
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        showImagePickerAlert()
        
        //        let croppingParams = CroppingParameters.init(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 100, height: 100))
        //
        //        let cameraController = CameraViewController.init(croppingParameters: croppingParams, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true) { [weak self](image, asset) in
        //            if let image = image {
        //                self?.selectedImage = Toucan(image: image).resizeByClipping(CGSize(width: 700, height: 700)).image!
        //                self?.imageButton.setImage(self?.selectedImage, for: .normal)
        //            }
        //
        //            self?.dismiss(animated: true, completion: nil)
        //        }
        //        self.present(cameraController, animated: true, completion: nil)
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        Router.showLocationSelection(from: self, isEventScreen: false, isPostScreen: true)
    }
    
    
    
    @IBAction func postButtonPressed(_ sender: Any) {
        
        if postType == .editPost {
            
            guard let current = currentLocation else {
                UtilityManager.showErrorMessage(body: "Location not detected yet", in: self)
                return
                
            }
            
            if bodyTextView.text.count <= 0 {
                UtilityManager.showErrorMessage(body: "Post can't be empty", in: self)
                return
            }
            
            var params = [String: AnyObject]()
            
            params["content"] = bodyTextView.text as AnyObject
            params["post_id"] = postObject.id as AnyObject
            
            if (locationAddressLabel.text?.count)! > 0 {
                if let location = selectedLocation {
                    params["location_name"] = locationAddressLabel.text as AnyObject
                    params["checkin_latitude"] = location.latitude as AnyObject
                    params["checkin_longitude"] = location.longitude as AnyObject
                }
            }

            params["current_latitude"] = current.latitude as AnyObject
            params["current_longitude"] = current.longitude as AnyObject
            
            
            SVProgressHUD.show()
            
            selectedImage? = previewImage.image!
            RequestManager.createPost(param: params, image: selectedImage, successBlock: { (response) in
                SVProgressHUD.showSuccess(withStatus: "Post updated successfully")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selfPostAdded"), object: nil, userInfo: nil)
                self.navigationController?.dismiss(animated: true, completion: nil)
            }) { (error) in
                UtilityManager.showErrorMessage(body: error, in: self)
                
            }
        }

        else
        {
            
            guard let current = currentLocation else {
                UtilityManager.showErrorMessage(body: "Location not detected yet", in: self)
                return
                
            }
            
            if bodyTextView.text.count <= 0 {
                UtilityManager.showErrorMessage(body: "Post can't be empty", in: self)
                return
            }
            
            var params = [String: AnyObject]()
            
            params["content"] = bodyTextView.text as AnyObject
            if let location = selectedLocation {
                params["location_name"] = locationAddressLabel.text as AnyObject
                params["checkin_latitude"] = location.latitude as AnyObject
                params["checkin_longitude"] = location.longitude as AnyObject
            }
            params["current_latitude"] = current.latitude as AnyObject
            params["current_longitude"] = current.longitude as AnyObject
            
            
            
            SVProgressHUD.show()
            RequestManager.createPost(param: params, image: selectedImage, successBlock: { (response) in
                SVProgressHUD.showSuccess(withStatus: "Post created successfully")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selfPostAdded"), object: nil, userInfo: nil)
                self.navigationController?.dismiss(animated: true, completion: nil)
            }) { (error) in
                UtilityManager.showErrorMessage(body: error, in: self)
                
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Core Location Methods
    
    func setupLocation() {
        // Initialize the location manager.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        
        postButton.isEnabled = true
    }
    
    //MARK: - Location Selection Delegate methods
    
    func didSelectLocation(location: CLLocationCoordinate2D,address: String?) {
        self.selectedLocation = location
        if !self.bodyTextView.text.contains("#CheckedIn") {
            self.bodyTextView.text.append(" #CheckedIn ")
        }
        
        bodyTextView.layoutSubviews()
        self.textViewDidChange(bodyTextView)
        if let add = address {
            self.atLabel.isHidden = false
            self.locationAddressLabel.isHidden = false
            self.locationAddressLabel.text = add
        }
        else{
            var params = [String: AnyObject]()
            
            params["key"] = Constant.googlePlacesKey as AnyObject
            params["latlng"] = "\(location.latitude),\(location.longitude)" as AnyObject
            
            SVProgressHUD.show()
            RequestManager.getAddressForCoords(param: params, successBlock: { (response) in
                print(response)
                if let address = response.first?["formatted_address"] as? String {
                    self.atLabel.isHidden = false
                    self.locationAddressLabel.isHidden = false
                    self.locationAddressLabel.text = address
                    
                }
                SVProgressHUD.dismiss()
            }) { (error) in
                print(error)
                SVProgressHUD.dismiss()
            }
        }
        
        
    }
    
    //MARK: - ImagePicker methods
    
    func showImagePickerAlert(){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Upload from Camera", style: .default, handler: { (action) -> Void in
            self.selectFromCameraPressed()
        }))
        actionSheet.addAction(UIAlertAction(title: "Upload from Gallery", style: .default, handler: { (action) -> Void in
            self.selectFromGalleryPressed()
        }))
        actionSheet.popoverPresentationController?.sourceView = self.view
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func selectFromCameraPressed(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.navigationBar.barTintColor = Styles.sharedStyles.primaryColor
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "No Camera detected", message: "No Camera was detected on this device", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func selectFromGalleryPressed(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            
            imagePicker.navigationBar.barTintColor = Styles.sharedStyles.primaryColor
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Gallery ", message: "No Camera was detected on this device", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var newImage : UIImage!
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            newImage = editedImage
        }
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newImage = originalImage
        }
        
        self.selectedImage = newImage.resizeImageWith(newSize: CGSize(width: 200, height: 200))
        self.previewImage.image = newImage.resizeImageWith(newSize: CGSize(width: 200, height: 200))
        if !self.bodyTextView.text.contains("#Photo") {
            self.bodyTextView.text.append(" #Photo ")
        }
        
        bodyTextView.layoutSubviews()
        imageButton.isHidden = false
        self.textViewDidChange(bodyTextView)
        
        picker.dismiss(animated: true) {
            
        }
    }
    
    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        bodyTextViewHeightConstraint.constant = textView.contentSize.height + 15
        bodyTextView.layoutIfNeeded()
        
        if let lastWord = textView.text.components(separatedBy: .whitespacesAndNewlines).last {
            if lastWord.first == "#" {
                let list = Constant.hashtags.filter { $0.lowercased().hasPrefix(lastWord.lowercased()) }
                suggestionsTable.refreshList(listValues: list)
                self.view.bringSubview(toFront: suggestionsTable)
            }
            else{
                suggestionsTable.isHidden = true
            }
        }
        else{
            suggestionsTable.isHidden = true
        }
        textView.convertHashtags()
    }
    
    func suggestionSelected(value: String) {
        if let text = bodyTextView.text {
            var word = text.components(separatedBy: .whitespacesAndNewlines)
            word.removeLast()
            var newWord = word.joined(separator: " ")
            newWord.append(" \(value) ")
            bodyTextView.text = newWord
        }
        bodyTextView.convertHashtags()
    }
    
}

// Delegates to handle events for the location manager.
extension GeoPostViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        currentLocation = location.coordinate
        locationManager.stopUpdatingLocation()
        
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
            self.restrictUserDueToLocation()
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            self.restrictUserDueToLocation()
            
        case .notDetermined:
            print("Location status not determined.")
            self.restrictUserDueToLocation()
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    func restrictUserDueToLocation() {
        UIAlertController.showAlert(in: self, withTitle: "Location Disabled", message: "Please enable location services for \(Constant.applicationName) in Settings -> \(Constant.applicationName)", cancelButtonTitle: "OK", destructiveButtonTitle: nil, otherButtonTitles: nil) { (alert, action, index) in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.phase == UITouchPhase.began {
            self.view.endEditing(true)
        }
    }
    
}
