//
//  AppDelegate.swift
//  Connectivity
//
//  Created by Danial Zahid on 16/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    

    var window: UIWindow?
    
    let notification = CWStatusBarNotification()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GMSServices.provideAPIKey(Constant.googlePlacesKey)
        GMSPlacesClient.provideAPIKey(Constant.googlePlacesKey)
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        
        
        // Check if launched from notification
        // 1
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            // 2
            //            let aps = notification["aps"] as! [String: AnyObject]
            // 3
            delay(delay: 1.0, closure: {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openedFromPush"), object: nil, userInfo: ["info":notification])
            })
            
        }
        
        self.notification.notificationStyle = .navigationBarNotification
        self.notification.notificationLabelBackgroundColor = UIColor(red: 94.0/255.0, green: 166.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError?.localizedDescription ?? "")")
        
        let bounds = UIScreen.main.bounds
        self.window = UIWindow(frame: bounds)
        if let sessionID = UserDefaults.standard.value(forKey: UserDefaultKey.sessionID) as? String {
            ApplicationManager.sharedInstance.session_id = sessionID
            let tabBarController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
            self.window?.rootViewController = tabBarController
        }
        else{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: SignInViewController.identifier) 
            self.window?.rootViewController = vc
        }
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return facebookDidHandle || googleDidHandle
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        print("Device Token:", tokenString)
        Messaging.messaging().apnsToken = deviceToken
        UserDefaults.standard.setValue(tokenString, forKey: UserDefaultKey.pushNotificationToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    func registerForPushNotifications(application: UIApplication) {
        
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        application.registerForRemoteNotifications()
        
    }
    
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [String : AnyObject]) {
        let alert = userInfo["aps"]!["alert"] as! String
        self.notification.display(withMessage: alert, forDuration: 3.0)
    
    }
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        
    }
    
    
    


}

