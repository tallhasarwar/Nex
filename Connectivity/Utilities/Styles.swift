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
    case Medium = "Poppins-Medium"
}

class Styles {
    
    static let sharedStyles = Styles()
    
    public func applyGlobalAppearance() {
        //Probably want to set the tintColor of UIWindow but it didn't seem necessary right now
        
//        UINavigationBar.appearance().barTintColor = UIColor.init(patternImage: UIImage(named: "login-bg")!)
        UINavigationBar.appearance().barTintColor = Styles.sharedStyles.primaryColor
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().tintColor = .white
        UIToolbar.appearance().tintColor = Styles.sharedStyles.primaryColor
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        UITextField.appearance().tintColor = .white
        
//        UISegmentedControl.appearance().tintColor = UIColor.blue
//        UINavigationBar.appearance().barStyle = UIBarStyle.black
        
//        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-30, -30), for:UIBarMetrics.default)
        
        UINavigationBar.appearance().isTranslucent = false
        
        let attributes = [NSAttributedStringKey.font: UIFont(font: Font.SemiBold, size: 15.0)!,
        NSAttributedStringKey.foregroundColor: UIColor.white] as [NSAttributedStringKey: Any]
        
        UINavigationBar.appearance().titleTextAttributes = attributes
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.gradient)
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(font: Font.SemiBold, size: 13.0)!
        preferences.drawing.foregroundColor = UIColor.darkGray
        preferences.drawing.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        preferences.drawing.borderColor = UIColor(white: 0.7, alpha: 0.7)
        preferences.drawing.borderWidth = 1.0
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
        
        /*
         * Optionally you can make these preferences global for all future EasyTipViews
         */
        EasyTipView.globalPreferences = preferences
    }
    
    ///**Warning:** Not from style guide. Do not add more uses
    
    public var progressBarTintColor : UIColor {
        return UIColor(red: CGFloat(126.0/255.0), green: CGFloat(199.0/255.0), blue: CGFloat(143.0/255.0), alpha: CGFloat(1.00))
    }
    
    ///**Warning:** Not from style guide. Do not add more uses
    public var progressBarTrackTintColor : UIColor {
        return UIColor(red: CGFloat(223.0/255.0), green: CGFloat(242.0/255.0), blue: CGFloat(228.0/255.0), alpha: CGFloat(1.00))
    }
    
    public var primaryColor: UIColor {
        return UIColor(red: 0.06, green: 0.46, blue: 0.96, alpha: 1.0)
    }
    
    public var primaryGreyColor : UIColor {
        return UIColor(white: 0.2, alpha: 1.0)
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



//Global variables
struct GlobalVariables {
    static let blue = UIColor.rbg(r: 129, g: 144, b: 255)
    static let purple = UIColor.rbg(r: 161, g: 114, b: 255)
}

//Extensions
extension UIColor{
    class func rbg(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        return color
    }
}

class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

extension UITextView {
    
    func convertHashtags() {
        
        let font = [NSAttributedStringKey.font : UIFont(font: .Standard, size: 18.0)]
        
        let attrString = NSMutableAttributedString(string: self.text, attributes: font)
        attrString.beginEditing()
//        NSRange(
//        attrString.addAttribute(N SFontAttributeName, value: , range: NSRange()
        // match all hashtags
        do {
            // Find all the hashtags in our string  (?:^|\\s|$)#[\\p{L}0-9_]*
//            let regex = try NSRegularExpression(pattern: "(?:\\s|^)(#(?:[a-zA-Z].*?|\\d+[a-zA-Z]+.*?))\\b", options: NSRegularExpression.Options.anchorsMatchLines)
            let regex = try NSRegularExpression(pattern: "(?:^|\\s|$)#[\\p{L}a-z&0-9_]*", options: NSRegularExpression.Options.anchorsMatchLines)
            let results = regex.matches(in: text,
                                        options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, text.length))
            let array = results.map { (text as NSString).substring(with: $0.range) }
            for hashtag in array {
                // get range of the hashtag in the main string
                let range = (attrString.string as NSString).range(of: hashtag)
                // add a colour to the hashtag
                attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: Styles.sharedStyles.primaryColor , range: range)
                
            }
            attrString.endEditing()
        }
        catch {
            attrString.endEditing()
        }
        self.attributedText =  attrString
    }
    
}

