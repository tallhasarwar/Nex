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
    
    static func showProfileViewController(user: User, from controller: UIViewController) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ProfileViewController.storyboardID) as! ProfileViewController
        vc.user = user
        controller.navigationController?.show(vc, sender: nil)
    
    }
    
    static func showBusinessCard(from controller: UIViewController) {
        
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: BusinessCardListViewController.storyboardID) as! BusinessCardListViewController
        controller.navigationController?.show(vc, sender: nil)
    }
    
    static func showBusinessCardDetails(businessCard: BusinessCard?, from controller: UIViewController) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: EditBusinessCardViewController.storyboardID) as! EditBusinessCardViewController
        if let card = businessCard {
            vc.businessCard = card
        }
        
        controller.navigationController?.show(vc, sender: nil)
    }
    
    static func showChatViewController(user: User, from controller: UIViewController) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ChatViewController.storyboardID) as! ChatViewController
        vc.currentUser = user
        controller.navigationController?.show(vc, sender: nil)
        
    }
    
    static func showEventsListController(from controller: UIViewController) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: EventsListViewController.storyboardID) as! EventsListViewController
        
        controller.navigationController?.show(vc, sender: nil)
        
    }
    
    
    static func showConnections(from controller: UIViewController) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ConnectionsListViewController.storyboardID) as! ConnectionsListViewController
        
        controller.navigationController?.show(vc, sender: nil)
        
    }
    
    static func showNearbyEventsListController(coordinates: CLLocationCoordinate2D, from controller: UIViewController) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: EventsListViewController.storyboardID) as! EventsListViewController
        vc.isLocationBased = true
        vc.coordinates = coordinates
        controller.navigationController?.show(vc, sender: nil)
        
    }
    
    static func showCreateEventController(from controller: UIViewController) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: CreateEventViewController.storyboardID) as! CreateEventViewController
        
        controller.navigationController?.show(vc, sender: nil)
        
    }
    
    static func showEditEventController(event: Event, from controller: UIViewController) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: CreateEventViewController.storyboardID) as! CreateEventViewController
        vc.event = event
        vc.isEditingMode = true
        controller.navigationController?.show(vc, sender: nil)
        
    }
    
    static func showEventDetail(event: Event, from controller: UIViewController) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: EventDetailViewController.storyboardID) as! EventDetailViewController
        vc.event = event
        controller.navigationController?.show(vc, sender: nil)
        
    }
    
    static func showLocationSelection(from controller: UIViewController) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: CheckInViewController.storyboardID) as! CheckInViewController
        if let delegateVC = controller as? LocationSelectionDelegate {
            vc.locationDelegate = delegateVC
        }
        vc.isLocationSelection = true
        controller.navigationController?.show(vc, sender: nil)
    }
    
    static func showGeoPost(from controller: UIViewController) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: GeoPostViewController.storyboardID)
        controller.navigationController?.show(vc, sender: nil)
        
    }
    
    static func showSettings(from controller: UIViewController) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: SettingsViewController.storyboardID)
        controller.navigationController?.show(vc, sender: nil)
        
    }
    
    static func showFilterScreen(from controller: UIViewController) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: FiltersViewController.storyboardID) as! UINavigationController
        if let delegateVC = controller as? FiltersDelegate {
            if let filterController = vc.viewControllers.first as? FiltersViewController {
                filterController.delegate = delegateVC
            }   
        }
        controller.navigationController?.show(vc, sender: nil)
    }

    static func showTermsAndConditions(from controller: UIViewController)
    {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: TermsAndConditionsViewController.storyboardID)
        controller.navigationController?.show(vc, sender: nil)
    }
    
    static func showTermsAndConditionsWithNav(from controller: UIViewController)
    {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: TermsAndConditionsViewController.storyboardID) as! TermsAndConditionsViewController
        let nav = UINavigationController(rootViewController: vc)
        
        vc.fromLogin = true
        
        controller.present(nav, animated: true, completion: nil)
    }
    
    
    
}
