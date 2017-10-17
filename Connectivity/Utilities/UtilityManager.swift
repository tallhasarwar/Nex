//
//  UtilityManager.swift
//  MyDocChat
//
//  Created by Danial Zahid on 29/05/15.
//  Copyright (c) 2015 DanialZahid. All rights reserved.
//

import UIKit


class UtilityManager: NSObject {
    
    static func stringFromNSDateWithFormat(date: NSDate, format : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date as Date)
        
    }
    
    static func dateFromStringWithFormat(date: String, format: String) -> NSDate{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: date)! as NSDate
    }
    
    //MARK: - Other Methods
    
    static func activityIndicatorForView(view: UIView) -> UIActivityIndicatorView{
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.color = UIColor.darkGray
        activityIndicator.center = view.center
        
        view.addSubview(activityIndicator)
        
        return activityIndicator
    }
    
    static func uniqueKeyWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0 ..< len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
    
    static func delay(delay: Double, closure: @escaping () -> ()) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
}
