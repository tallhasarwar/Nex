//
//  DZImageView.swift
//  ImageTester
//
//  Created by Danial Zahid on 1/21/16.
//  Copyright © 2016 Danial Zahid. All rights reserved.
//

import UIKit
import CameraViewController

@IBDesignable class DZImageView: UIImageView, UIImagePickerControllerDelegate, UINavigationControllerDelegate, IGRPhotoTweakViewControllerDelegate {
    
    var parentController: UIViewController?
    var imageChanged = false
    
    var lockAspect = true
    var aspectRatio: String = "1:1"

    @IBInspectable var placeholderImage: UIImage? {
        didSet {
            self.image = placeholderImage
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }*/
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(sender:)))
        self.addGestureRecognizer(singleTap)
        
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func imageViewTapped(sender: UITapGestureRecognizer){
        
        
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in

        }))
        actionSheet.addAction(UIAlertAction(title: "Upload from Camera", style: .default, handler: { (action) -> Void in
            self.selectFromCameraPressed()
        }))
        actionSheet.addAction(UIAlertAction(title: "Upload from Gallery", style: .default, handler: { (action) -> Void in
            self.selectFromGalleryPressed()
        }))
        actionSheet.popoverPresentationController?.sourceView = self.parentController?.view

        self.parentController?.present(actionSheet, animated: true, completion: nil)
    }

    func selectFromCameraPressed(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.navigationBar.barTintColor = Styles.sharedStyles.primaryColor
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.parentController?.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "No Camera detected", message: "No Camera was detected on this device", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
                
            }))
            self.parentController?.present(alert, animated: true, completion: nil)
            
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
            self.parentController?.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Gallery ", message: "No Camera was detected on this device", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
                
            }))
            self.parentController?.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.image = image
        imageChanged = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        var newImage : UIImage!
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            newImage = editedImage
        }
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newImage = originalImage
        }
        
        if let image = newImage {
            let cropController = ImageEditViewController()
            cropController.aspectRatio = aspectRatio
            cropController.lockAspectRatio = lockAspect
            cropController.image = image
            cropController.delegate = self
            let nav = UINavigationController(rootViewController: cropController)
            picker.dismiss(animated: true, completion: {
                self.parentController?.present(nav, animated: true, completion: nil)
            })
        }
        else{
            self.image = info[UIImagePickerControllerEditedImage] as? UIImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage) {
        self.image = croppedImage.resizeImageWith(newSize: CGSize(width: 200, height: 200))
        self.contentMode = .scaleAspectFill
        controller.dismiss(animated: true, completion: nil)
    }
    
    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    

}

extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
}
