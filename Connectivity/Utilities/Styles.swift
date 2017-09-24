//
//  Styles.swift
//  edX
//
//  Created by Danial Zahid on 25/05/2015.
//  Copyright (c) 2015 edX. All rights reserved.
//

import Foundation
import UIKit

struct ShadowStyle {
    let angle: Int //degrees
    let color: UIColor
    let opacity: CGFloat //0..1
    let distance: CGFloat
    let size: CGFloat

    var shadow: NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = color.withAlphaComponent(opacity)
        shadow.shadowOffset = CGSize(width: cos(CGFloat(angle) / 180.0 * CGFloat(Double.pi)), height: sin(CGFloat(angle) / 180.0 * CGFloat(Double.pi)))
        shadow.shadowBlurRadius = size
        return shadow
    }
}

enum Font : String {
    case Standard = "Poppins-Regular"
    case Bold = "Poppins-Bold"
    case SemiBold = "Poppins-SemiBold"
    case Light = "Poppins-Light"
}

class Styles {
    
    static let sharedStyles = Styles()
    
    public func applyGlobalAppearance() {
        //Probably want to set the tintColor of UIWindow but it didn't seem necessary right now
        
        UINavigationBar.appearance().barTintColor = UIColor.init(patternImage: UIImage(named: "login-bg")!)
        
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().tintColor = .white
        UIToolbar.appearance().tintColor = UIColor.blue
        
//        UISegmentedControl.appearance().tintColor = UIColor.blue
//        UINavigationBar.appearance().barStyle = UIBarStyle.black
        
        UINavigationBar.appearance().isTranslucent = false
        
        let attributes : [String: AnyObject] = [NSFontAttributeName: UIFont(font: Font.SemiBold, size: 15.0)!,
                          NSForegroundColorAttributeName: UIColor.white]
        
        UINavigationBar.appearance().titleTextAttributes = attributes
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
    }
    
    ///**Warning:** Not from style guide. Do not add more uses
    
    public var progressBarTintColor : UIColor {
        return UIColor(red: CGFloat(126.0/255.0), green: CGFloat(199.0/255.0), blue: CGFloat(143.0/255.0), alpha: CGFloat(1.00))
    }
    
    ///**Warning:** Not from style guide. Do not add more uses
    public var progressBarTrackTintColor : UIColor {
        return UIColor(red: CGFloat(223.0/255.0), green: CGFloat(242.0/255.0), blue: CGFloat(228.0/255.0), alpha: CGFloat(1.00))
    }


    var standardTextViewInsets : UIEdgeInsets {
        return UIEdgeInsetsMake(8, 8, 8, 8)
    }
    
    var standardFooterHeight : CGFloat {
        return 50
    }
    
    var standardVerticalMargin : CGFloat {
        return 8.0
    }
    
    var standardHorizontalMargin : CGFloat {
        return 8.0
    }
    
    var boxCornerRadius : CGFloat {
        return 8.0
    }
    
    var buttonCornerRadius : CGFloat {
        return 25.0
    }

}

extension UIView {
    func applyStandardContainerViewStyle() {
        backgroundColor = UIColor.white
        layer.cornerRadius = Styles.sharedStyles.boxCornerRadius
        layer.masksToBounds = true
    }
    
    func applyStandardContainerViewShadow() {
        layer.shadowColor = UIColor.black.cgColor;
        layer.shadowRadius = 1.0;
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 0.8;
    }
}

extension UIButton {
    func styleFilledSignUp() {
        backgroundColor = UIColor.white
        setTitleColor(UIColor(hex: "3FB0AC"), for:.normal)
        titleLabel?.font = UIFont(font: Font.Standard, size: 15.0)
        layer.cornerRadius = Styles.sharedStyles.buttonCornerRadius
    }
    
    func styleLogin() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = Styles.sharedStyles.buttonCornerRadius
        setTitleColor(.white, for:.normal)
        titleLabel?.font = UIFont(font: Font.Standard, size: 15.0)
        
    }
    
    func styleFacebook(text: String) {
        setTitle(text, for: .normal)
        setTitleColor(.white, for:.normal)
        backgroundColor = UIColor(hex: "3B5998")
        layer.cornerRadius = Styles.sharedStyles.buttonCornerRadius
        titleLabel?.font = UIFont(font: Font.Standard, size: 15.0)
    }
}

extension UITextField {
    func styleStandardField() {
        backgroundColor = .clear
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 7
    }
}

extension UIFont {
    convenience init?(font: Font, size: CGFloat) {
        self.init(name: font.rawValue, size: size)
    }
}

//Standard Search Bar styles
extension UISearchBar {
    func applyStandardStyles(withPlaceholder placeholder : String? = nil) {
        self.placeholder = placeholder
        self.showsCancelButton = false
        self.searchBarStyle = .default
        self.backgroundColor = UIColor.white
    }
}

//Convenience computed properties for margins
var StandardHorizontalMargin : CGFloat {
    return Styles.sharedStyles.standardHorizontalMargin
}

var StandardVerticalMargin : CGFloat {
    return Styles.sharedStyles.standardVerticalMargin
}
