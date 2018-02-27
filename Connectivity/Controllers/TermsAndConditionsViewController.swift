//
//  TermsAndConditionsViewController.swift
//  Connectivity
//
//  Created by Moeez Zahid on 27/02/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: UIViewController {

    static let storyboardID = "termsAndConditionsViewController"
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //https://connectin.tech/terms-and-conditions/
        self.navigationItem.title = "Terms and Conditions"
        if let pageUrl = URL(string: "https://connectin.tech/terms-and-conditions")
        {
            let urlRequest = URLRequest(url: pageUrl)
            self.webView.loadRequest(urlRequest)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
