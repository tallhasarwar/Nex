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
    
    static func serverDateStringFromAppDateString(dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constant.appDateFormat
        dateFormatter.timeZone = NSTimeZone.local
        
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = Constant.serverDateFormat
        newDateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        return newDateFormatter.string(from: dateFormatter.date(from: dateString)!)
        
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
    
    
    static func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        
        let calendar = NSCalendar.current
        let unitFlags : Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        
        let now = NSDate()
        let earliest = now.earlierDate(date as Date) as Date
        let latest = (earliest == now as Date) ? date as Date : now as Date
        
//        Components(unitFlags, fromDate: earliest, toDate: latest) else { return ""}
        
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
//        let ccc = calendar.datecom
        
        
        let year = components.year ?? 0
        let month = components.month ?? 0
        let weekOfYear = components.weekOfYear ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        
        if (year >= 2) {
            return "\(year) years ago"
        } else if (year >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (month >= 2) {
            return "\(month) months ago"
        } else if (month >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (weekOfYear >= 2) {
            return "\(weekOfYear) weeks ago"
        } else if (weekOfYear >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (day >= 2) {
            return "\(day) days ago"
        } else if (day >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (hour >= 2) {
            return "\(hour) hours ago"
        } else if (hour >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (minute >= 2) {
            return "\(minute) minutes ago"
        } else if (minute >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (second >= 3) {
            return "\(second) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
}
