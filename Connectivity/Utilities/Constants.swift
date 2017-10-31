//
//  Constants.swift
//  Quicklic
//
//  Created by Danial Zahid on 30/07/2015.
//  Copyright (c) 2015 Danial Zahid. All rights reserved.
//

import UIKit

public class UserDefaultKey: NSObject {
    static let sessionID = "session_id"
    static let pushNotificationToken = "pushNotificationToken"
}

enum PhotoSource {
    case library
    case camera
}

enum ShowExtraView {
    case contacts
    case profile
    case preview
    case map
}

public class Constant: NSObject {

    static let facebookURL = "https://graph.facebook.com/me"
    
    static let applicationName = "Connectivity"
    static let serverDateFormat = "yyyy-MM-dd"
    static let appDateFormat = "MM/dd/yyyy hh:mm:ss"
    static let animationDuration : TimeInterval = 0.5
    
    static let mainColor = UIColor(red: 145.0/255.0, green: 20.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    
    static let serverURL = "http://52.14.237.29:3000/connectIn/api/v1/"
//    static let serverURL = "http://192.168.8.102:3000/connectIn/api/v1/"
    
    static let googleNearbyURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    //MARK: - Response Keys
    
    static let messageKey = "message"
    static let responseKey = "responce"
    static let statusKey = "status"
    
    static let registrationURL = "signup"
    static let loginURL = "signin"
    static let updateProfileURL = "updateProfile"
    static let socialLoginURL = "social_login"
    static let getProfileURL = "getProfile"
    static let checkinLocationURL = "checkin_location"
    static let addBusinessCardURL = "add_bcard"
    static let getBusinessCardURL = "get_bcard"
    static let getPendingRequestsURL = "my_all_pending_requests"
    static let getAllNotificationsURL = "get_all_notifications"
    static let getOtherProfileURL = "getOtherUserProfile"
    static let respondToRequestURL = "accept_connection_request"
    
    
}
