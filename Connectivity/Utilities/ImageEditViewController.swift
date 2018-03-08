//
//  ImageEditViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 2/8/18.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class ImageEditViewController: IGRPhotoTweakViewController {
    
    var lockAspectRatio : Bool = false
    var aspectRatio : String = "1:1"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.lockAspectRatio(lockAspectRatio)
        self.setCropAspectRect(aspect: aspectRatio)
        
        let leftButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelButtonPressed))
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneButtonPressed))
        self.navigationItem.rightBarButtonItem = rightButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func cancelButtonPressed() {
        self.dismissAction()
    }
    
    @objc func doneButtonPressed() {
        self.cropAction()
    }
    
    override open func customCanvasHeaderHeigth() -> CGFloat {
        var heigth: CGFloat = 0.0
        
        if UIDevice.current.orientation.isLandscape {
            heigth = 40.0
        } else {
            heigth = 100.0
        }
        
        return heigth
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
