//
//  SignInViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 25/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import SwiftValidator
import FirebaseMessaging
import Firebase

class SignInViewController: UIViewController, ValidationDelegate, UITextFieldDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    static let identifier = "signInViewController"

    @IBOutlet weak var emailField: DesignableTextField!
    @IBOutlet weak var passwordField: DesignableTextField!
    @IBOutlet weak var facebookLoginButton: DesignableButton!
    
    let validator = Validator()
    var linkedinClient : LIALinkedInHttpClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        linkedinClient = linkedInClient()

        validator.registerField(emailField, rules: [RequiredRule() as Rule,EmailRule(message: "Invalid email")])
        validator.registerField(passwordField, rules: [RequiredRule() as Rule, MinLengthRule(length: 8) as Rule, MaxLengthRule(length: 20) as Rule])
        
        [emailField, passwordField].forEach { (field) in
            field?.delegate = self
        }
        
        facebookLoginButton.layer.cornerRadius = facebookLoginButton.frame.height/2
        facebookLoginButton.layer.masksToBounds = true
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signinButtonPressed(_ sender: Any) {
        validator.validate(self)
    }
    
    
    func validationSuccessful() {
        
        var params = [String : String]()
        params["email"] = emailField.text
        params["password"] = passwordField.text
        params["device_token"] = Messaging.messaging().fcmToken
        
        SVProgressHUD.show()
        RequestManager.loginUser(param: params, successBlock: { (response) in
            SVProgressHUD.dismiss()
            self.successfulLogin(response: response)
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
                field.resignFirstResponder()
                if error.errorLabel?.isHidden == true {
                    error.errorLabel?.text = error.errorMessage // works if you added labels
                    error.errorLabel?.isHidden = false
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.white.cgColor
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - IBActions
    
    @IBAction func facebookButtonPressed(sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        loginManager.loginBehavior = FBSDKLoginBehavior.native
        loginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, error) in
            SVProgressHUD.show()
            guard let token = result?.token else {
                return
            }
            // Verify token is not empty
            if token.tokenString.isEmpty {
                print("Token is empty")
                return
            }
            // Request Fields
            let fields = "name,first_name,last_name,email,gender"
            
            // Build URL with Access Token
            let url = Constant.facebookURL + "?fields=\(fields)&access_token=\(token.tokenString!)"
            
            //Make API call to facebook graph api to get data
            RequestManager.getUserFacebookProfile(url: url, successBlock: { (response) in
                /*{
                 email = "danialzahid94@live.com";
                 "first_name" = Danial;
                 gender = male;
                 id = 10210243338655397;
                 "last_name" = Zahid;
                 name = "Danial Zahid";
                 }*/
                print(response)
                
                var params = [String: String]()
                
                params["social_provider_name"] = "facebook"
                params["full_name"] = response["name"] as? String
                params["social_id"] = response["id"] as? String
                params["email"] = response["email"] as? String
                params["device_token"] = Messaging.messaging().fcmToken
                
                RequestManager.socialLoginUser(param: params, successBlock: { (response) in
                    self.successfulLogin(response: response)
                }, failureBlock: { (error) in
                    SVProgressHUD.showError(withStatus: error)
                })
                
                
            }, failureBlock: { (error) in
                SVProgressHUD.showError(withStatus: error)
            })
            
        }
    
    }
    
    @IBAction func googleButtonPressed(sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func linkedInButtonPressed(sender: AnyObject) {
        
        //Get Authorization Code
        self.linkedinClient?.getAuthorizationCode({ (auth_code) -> Void in
            //Get Access Token
            
            SVProgressHUD.show()
            self.linkedinClient?.getAccessToken(auth_code, success: { (access_token_data) -> Void in
                let response = access_token_data as! [String: AnyObject]
                let access_token = response["access_token"] as! String
                //Get Profile Data From LinkedIn
                RequestManager.getUserLinkedInProfile(access_token: access_token, successBlock: { (response) -> () in
                    SVProgressHUD.show(withStatus: "Logging In")
                    
                    /*{
                     emailAddress = "danialzahid94@live.com";
                     firstName = Danial;
                     headline = "Mobile Developer | Tech Consultant | Entrepreneur";
                     id = "-sqSajuMHj";
                     lastName = Zahid;
                     pictureUrl = "https://media.licdn.com/mpr/mprx/0_CzlvYuH26_xBZRDPSzLUsmADk6AoOMPYkiwRUJg23qKwOWStTAWv9fd2_GgcjoxtezWv9E6uWX8I4gSCDQNWnZw82X8E4gdYDQNngMYSFLv6-w-GTcG4jDKyulsslgY7kLrMVI6pLsv";
                     publicProfileUrl = "https://www.linkedin.com/in/danialzahid";
                     }*/
                    
                    var params = [String: String]()
                    
                    params["social_provider_name"] = "linkedin"
                    params["full_name"] = "\(response["firstName"] as? String ?? "") \(response["lastName"] as? String ?? "")"
                    params["social_id"] = response["id"] as? String
                    params["email"] = response["emailAddress"] as? String
                    params["headline"] = response["headline"] as? String
                    params["device_token"] = Messaging.messaging().fcmToken
                    params["linkedin_profile"] = response["publicProfileUrl"] as? String
                    params["image_path"] = response["pictureUrl"] as? String
                    
                    RequestManager.socialLoginUser(param: params, successBlock: { (response) in
                        self.successfulLogin(response: response)
                    }, failureBlock: { (error) in
                        SVProgressHUD.showError(withStatus: error)
                    })
                    
                    
                }, failureBlock: { (error) -> () in
                    self.showAlertView(title:"LinkedIn Login", message: error)
                })
            }, failure: { (err) -> Void in
                self.showAlertView(title: "LinkedIn Login", message: (err?.localizedDescription)!)
            })
        }, cancel: { () -> Void in
            self.showAlertView(title:"LinkedIn Login", message: "You cancelled the login.")
        }, failure: { (err) -> Void in
            self.showAlertView(title:"LinkedIn Login", message: (err?.localizedDescription)!)
        })
    }
    
    func linkedInClient() -> LIALinkedInHttpClient {
        let app : LIALinkedInApplication = LIALinkedInApplication(
            redirectURL: "http://oauthswift.herokuapp.com/callback/linkedin2",
            clientId: "78k7qd33y0ecis",
            clientSecret: "ETIPgVvjw9C2BI2p",
            state: "iuUYTFuiygfcgvJKJHGFT",
            grantedAccess: ["r_basicprofile", "r_emailaddress", "rw_company_admin"])
        return LIALinkedInHttpClient(for: app, presentingViewController: self)
    }
    
    func openURL(urlString: String) {
        if let url = NSURL(string: urlString) {
            if UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        else{
            print("can't find url")
        }
    }
    
    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func successfulLogin(response: [String: AnyObject]) {
        SVProgressHUD.dismiss()
        let user = User(dictionary: response)
        ApplicationManager.sharedInstance.user = user
        ApplicationManager.sharedInstance.session_id = response[UserDefaultKey.sessionID] as! String
        UserDefaults.standard.set(response[UserDefaultKey.sessionID] as! String, forKey: UserDefaultKey.sessionID)
        Router.showMainTabBar()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            // Perform any operations on signed in user here.
            var params = [String: String]()
            
            params["social_provider_name"] = "google"
            params["full_name"] = user.profile.name
            params["social_id"] = user.userID
            params["email"] = user.profile.email
            params["device_token"] = Messaging.messaging().fcmToken
            
            RequestManager.socialLoginUser(param: params, successBlock: { (response) in
                self.successfulLogin(response: response)
            }, failureBlock: { (error) in
                SVProgressHUD.showError(withStatus: error)
            })
            // ...
        } else {
            SVProgressHUD.showError(withStatus: error?.localizedDescription)
        }
    }
    
    func sign(didDisconnectWithUser user: GIDGoogleUser,
                withError error: Error) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}


