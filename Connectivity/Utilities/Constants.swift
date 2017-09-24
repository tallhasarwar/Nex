//
//  Constants.swift
//  Quicklic
//
//  Created by Danial Zahid on 30/07/2015.
//  Copyright (c) 2015 Danial Zahid. All rights reserved.
//

import UIKit

public class Constant: NSObject {


    static let applicationName = "Connectivity"
    static let serverDateFormat = "yyyy-MM-dd"
    static let appDateFormat = "MM/dd/yyyy hh:mm:ss"
    static let animationDuration : TimeInterval = 0.5
    
    static let mainColor = UIColor(red: 145.0/255.0, green: 20.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    
    static let serverURL = "http://52.14.237.29:3000/connectIn/api/v1/"
    //MARK: - Response Keys
    
    static let messageKey = "message"
    static let responseKey = "responce"
    static let statusKey = "status"
    
    static let registrationURL = "signup"
    static let loginURL = "signin"
    
    
}
