//
//  Router.swift
//  Map Hunt
//
//  Created by Danial Zahid on 16/08/2017.
//  Copyright © 2017 Fitsmind. All rights reserved.
//

import UIKit

class Router: NSObject {
    
    static func showMainTabBar() {
        let tabBarController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
        if let window = UIApplication.shared.delegate?.window {
            UIView.transition(with: window!, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                window?.rootViewController = tabBarController
            }, completion: nil)
        }
    }
    
    static func logout() {
        ApplicationManager.sharedInstance.session_id = ""
        UserDefaults.standard.set(nil, forKey: UserDefaultKey.sessionID)
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: SignInViewController.identifier)
        if let window = UIApplication.shared.delegate?.window {
            UIView.transition(with: window!, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                window?.rootViewController = vc
            }, completion: nil)
        }
    }
    
    static func showProfileViewController(user: User, publicProfile: Bool, from controller: UIViewController) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ProfileViewController.storyboardID) as! ProfileViewController
        vc.user = user
        vc.publicProfile = publicProfile
        controller.navigationController?.show(vc, sender: nil)
    
    }
    
    static func showBusinessCard(from controller: UIViewController) {
        
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: BusinessCardListViewController.storyboardID) as! BusinessCardListViewController
        controller.navigationController?.show(vc, sender: nil)
    }
    
    static func showChatViewController(user: User, from controller: UIViewController) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ChatViewController.storyboardID) as! ChatViewController
        vc.currentUser = user
        controller.navigationController?.show(vc, sender: nil)
        
        
    }
}
