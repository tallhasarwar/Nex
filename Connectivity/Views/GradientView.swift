//
//  GradientView.swift
//  Quicklic
//
//  Created by Danial Zahid on 22/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [gradientStartColor.cgColor,gradientEndColor.cgColor]
        gradient.opacity = opacity
        if !vertical {
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0);
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0);
        }
        else{
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0);
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0);
        }
        
        self.layer.insertSublayer(gradient, at: 0)
        
        if let image = bgImage {
            let myLayer = CALayer()
            let myImage = image.cgImage
            myLayer.frame = bounds
            myLayer.contents = myImage
            self.layer.insertSublayer(myLayer, at: 0)
        }
    }
    
    @IBInspectable var gradientStartColor: UIColor = UIColor(hex: "429321")
    @IBInspectable var gradientEndColor: UIColor = UIColor(hex: "B4ED50")
    @IBInspectable var vertical : Bool = false
    @IBInspectable var bgImage: UIImage? = nil
    @IBInspectable var opacity: Float = 1.0
    

}
