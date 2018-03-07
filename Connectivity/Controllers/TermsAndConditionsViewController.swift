//
//  TermsAndConditionsViewController.swift
//  Connectivity
//
//  Created by Moeez Zahid on 27/02/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: BaseViewController {

    static let storyboardID = "termsAndConditionsViewController"
    
    @IBOutlet weak var webView: UIWebView!
    var fromLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //https://connectin.tech/terms-and-conditions/
        self.navigationItem.title = "Terms"
        if let pageUrl = URL(string: "https://connectin.tech/terms-and-conditions")
        {
            let urlRequest = URLRequest(url: pageUrl)
            self.webView.loadRequest(urlRequest)
        }
        
        if fromLogin {
            let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.closeController))
            
            button.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.white], for: .normal)
            navigationItem.rightBarButtonItem = button
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func closeController() {
        self.navigationController?.dismiss(animated: true, completion: {
            
        })
    }
    

}
