//
//  MainTabBarController.swift
//  Connectivity
//
//  Created by Danial Zahid on 24/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import FirebaseMessaging
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Styles.sharedStyles.applyGlobalAppearance()
        self.selectedIndex = 2
        self.delegate = self
        
        if ApplicationManager.sharedInstance.user.email == nil {
            SVProgressHUD.show()
            RequestManager.getUser(successBlock: { (response) in
                SVProgressHUD.dismiss()
                let user = User(dictionary: response)
                ApplicationManager.sharedInstance.user = user
                if let notificationCount = user.unread_notification_count, notificationCount > 0 {
                    let tabbarItem = self.tabBar.items![3]
                    tabbarItem.badgeValue = "\(notificationCount)"
                }
                
                if let token =  Messaging.messaging().fcmToken {
                    let params = ["device_token" : token]
                    RequestManager.updateProfile(param: params, image: nil, successBlock: { (response) in
                    }, failureBlock: { (error) in
                        
                    })
                }
                
                
            }, failureBlock: { (error) in
                UtilityManager.showErrorMessage(body: error, in: self)
            })
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        // - 40 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
        tabFrame.size.height = 40
        tabFrame.origin.y = self.view.frame.size.height - 40
        
        self.tabBar.frame = tabFrame
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
