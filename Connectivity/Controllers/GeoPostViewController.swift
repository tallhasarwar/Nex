//
//  GeoPostViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 02/01/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class GeoPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationSelectionDelegate {

    static let storyboardID = "geoPostViewController"
    
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var bodyTextView: FloatLabelTextView!
    @IBOutlet var postBar: UIView!
    @IBOutlet weak var atLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    
    var selectedImage: UIImage?
    var selectedLocation: CLLocationCoordinate2D?
    
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

        let user = ApplicationManager.sharedInstance.user
        
        profileNameLabel.text = user.full_name
        profileImageView.sd_setImage(with: URL(string: user.image_path ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hashtagButtonPressed(_ sender: Any) {
        bodyTextView.text.append(" #")
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        showImagePickerAlert()
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        Router.showLocationSelection(from: self)
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        var params = [String: AnyObject]()
        
        params["content"] = bodyTextView.text as AnyObject
        if let location = selectedLocation {
            params["location_name"] = locationAddressLabel.text as AnyObject
            params["latitude"] = location.latitude as AnyObject
            params["longitude"] = location.longitude as AnyObject
        }
        
        SVProgressHUD.show()
        RequestManager.createPost(param: params, image: selectedImage, successBlock: { (response) in
            SVProgressHUD.showSuccess(withStatus: "Post created successfully")
            self.navigationController?.dismiss(animated: true, completion: nil)
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
        
        
        
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Location Selection Delegate methods
    
    func didSelectLocation(location: CLLocationCoordinate2D) {
        self.selectedLocation = location
        
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
            imagePicker.navigationBar.barTintColor = UIColor.blue
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
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
            
            imagePicker.navigationBar.barTintColor = UIColor.blue
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Gallery ", message: "No Camera was detected on this device", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        selectedImage = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = pickedImage.resizeImageWith(newSize: CGSize(width: 200, height: 200))
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = image.resizeImageWith(newSize: CGSize(width: 200, height: 200))
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
