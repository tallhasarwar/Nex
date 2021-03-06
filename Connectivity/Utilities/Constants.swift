//
//  Constants.swift
//  Quicklic
//
//  Created by Danial Zahid on 30/07/2015.
//  Copyright (c) 2015 Danial Zahid. All rights reserved.
//

import UIKit

public class UserDefaultKey: NSObject {
    static let sessionID = "session"
    static let pushNotificationToken = "pushNotificationToken"
    static let geoFeedRadius = "radiusValueForFeed"
    static let ownPostsFilter = "ownPostsFilter"
    static let linkedInAuthKey = "linkedInAuthKey"
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
    
    static let applicationName = "Nex"
    static let serverDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let appDateFormat = "MM/dd/yyyy hh:mm:ss a"
    static let eventDateFormat = "MM/dd/yyyy hh:mm a"
    static let eventDetailDateFormat = "MMM dd yyyy',' hh:mm a"
    static let animationDuration : TimeInterval = 0.5
    
    static let googlePlacesKey = "AIzaSyByRuCinleTQVigifuFU0-AOqvnEFieEYo"
    
    static let mainColor = UIColor(red: 145.0/255.0, green: 20.0/255.0, blue: 217.0/255.0, alpha: 1.0)

    static let serverURL = "http://52.14.237.29:3000/connectIn/api/v1/"
//    static let serverURL = "https://api.connectin.tech/connectIn/api/v1/"
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
    static let checkinEventURL = "event_checkin"
    static let addBusinessCardURL = "add_bcard"
    static let getBusinessCardURL = "get_bcard"
    static let getPendingRequestsURL = "my_all_pending_requests"
    static let getAllNotificationsURL = "get_all_notifications"
    static let getOtherProfileURL = "getOtherUserProfile"
    static let respondToRequestURL = "accept_connection_request"
    static let getEventsURL = "get_event_list"
    static let getNearbyEventsURL = "get_nearby_event"
    static let createEventURL = "create_event"
    static let getConnectionsURL = "get_all_my_connections"
    static let markNotificationsReadURL = "mark_all_notification_read"
    static let createPostURL = "post"
    static let getPostURL = "posts_feed"
    static let deletePostURL = "delete_post"
    static let reportPostURL = "report_post"
    static let deleteUserURL = "delete_user"
    static let forgotPasswordURL = "send_forget_link"
    static let logoutURL = "signout"
    
    
    static let hashtags = ["#Photo","#CheckedIn","#Deals","#ForSale","#ForRent","#Available","#InterestedIn","#Friendship","#Event","#Job","#Vehicle","#FoodAndDrinks","#Accomodation","#Property","#Services","#Shopping","#Transport","#Education","#Sports","#Books","#Relationships","#Networking","#Updates","#News","#Advice","#Article"]
    
    
}
