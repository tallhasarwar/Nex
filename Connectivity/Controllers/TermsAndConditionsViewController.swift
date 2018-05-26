//
//  TermsAndConditionsViewController.swift
//  Connectivity
//
//  Created by Moeez Zahid on 27/02/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: BaseViewController, UIWebViewDelegate {

    static let storyboardID = "termsAndConditionsViewController"
    
    @IBOutlet weak var webView: UIWebView!
    var fromLogin = false
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //https://connectin.tech/terms-and-conditions/
        self.navigationItem.title = "Terms"
        if let pageUrl = URL(string: "https://thenexnetwork.com/eula/")
        {
            let urlRequest = URLRequest(url: pageUrl)
            self.webView.loadRequest(urlRequest)
            self.webView.delegate = self
            activityIndicator = UtilityManager.activityIndicatorForView(view: webView)
            activityIndicator.startAnimating()
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
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    

}
