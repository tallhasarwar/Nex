//
//  EULAViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 5/3/18.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class EULAViewController: UIViewController, UIWebViewDelegate {

    static let storyboardID = "EULAViewController"
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var agreementButton: UIButton!
    
    var activityIndicator = UIActivityIndicatorView()
    var signupParams = [String: String]()
    var fromSignup = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let pageUrl = URL(string: "https://geonex.network/terms-and-conditions/")
        {
            let urlRequest = URLRequest(url: pageUrl)
            self.webView.loadRequest(urlRequest)
            self.webView.delegate = self
            activityIndicator = UtilityManager.activityIndicatorForView(view: webView)
            activityIndicator.startAnimating()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.dismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func acceptButtonPressed(_ sender: Any) {
        
        if agreementButton.isSelected == false {
            return
        }
        
        if fromSignup == true {
            SVProgressHUD.show()
            
            RequestManager.signUpUser(param: signupParams, successBlock: { (response) in
                SVProgressHUD.dismiss()
                ApplicationManager.sharedInstance.user = User(dictionary: response)
                ApplicationManager.sharedInstance.session_id = response["session_id"] as! String
                UserDefaults.standard.set(response["session_id"] as! String, forKey: UserDefaultKey.sessionID)
                Router.showMainTabBar()
            }) { (error) in
                let errorTemp = "Email already in use"
                UtilityManager.showErrorMessage(body: errorTemp, in: self)
                print(error)
            }
        }
        else{
            var params = [String: AnyObject]()
            params = signupParams as [String : AnyObject]
            params["terms_accepted"] = true as AnyObject
            RequestManager.socialLoginUser(param: params, successBlock: { (response) in
                self.successfulLogin(response: response)
            }, failureBlock: { (error) in
                if error == "please accept terms and condition!" {
                    Router.showEULA(params: self.signupParams, fromSignup: false, from: self)
                }
                else{
                    UtilityManager.showErrorMessage(body: error, in: self)
                }
            })
        }
    }
    
    @IBAction func rejectButtonpressed(_ sender: Any) {
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    func successfulLogin(response: [String: AnyObject]) {
        SVProgressHUD.dismiss()
        let user = User(dictionary: response)
        ApplicationManager.sharedInstance.user = user
        ApplicationManager.sharedInstance.session_id = response["session_id"] as! String
        UserDefaults.standard.set(response["session_id"] as! String, forKey: UserDefaultKey.sessionID)
        Router.showMainTabBar()
    }
    
    @IBAction func agreementButtonPressed(_ sender: Any) {
        self.agreementButton.isSelected = !agreementButton.isSelected
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
