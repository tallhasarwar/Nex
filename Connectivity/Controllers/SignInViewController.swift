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
    @IBOutlet weak var googleButton: DesignableButton!
    @IBOutlet weak var linkedinButton: DesignableButton!
    @IBOutlet weak var errorLabel: UILabel!
    var locationManager = CLLocationManager()
    
    let validator = Validator()
    var linkedinClient : LIALinkedInHttpClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        linkedinClient = linkedInClient()
        
        validator.registerField(emailField, errorLabel: errorLabel, rules: [RequiredRule(message: "Email can't be empty") as Rule,EmailRule(message: "Invalid email")])
        validator.registerField(passwordField, errorLabel: errorLabel, rules: [RequiredRule(message: "Password can't be empty") as Rule, MinLengthRule(length: 8) as Rule, MaxLengthRule(length: 20) as Rule])
        
        [emailField, passwordField].forEach { (field) in
            field?.delegate = self
        }
        
        facebookLoginButton.layer.cornerRadius = facebookLoginButton.frame.height/2
        facebookLoginButton.layer.masksToBounds = true
        
        facebookLoginButton.isExclusiveTouch = true
        googleButton.isExclusiveTouch = true
        linkedinButton.isExclusiveTouch = true
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        self.setupLocation()
        
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
            
            UtilityManager.showErrorMessage(body: error, in: self)
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
        errorLabel.isHidden = true
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
                SVProgressHUD.dismiss()
                return
            }
            // Verify token is not empty
            if token.tokenString.isEmpty {
                print("Token is empty")
                SVProgressHUD.dismiss()
                return
            }
            // Request Fields
            let fields = "name,first_name,last_name,email,gender,picture,locale,link"
            
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
                params["facebook_profile"] = response["link"] as? String
                params["device_token"] = Messaging.messaging().fcmToken
                if let image = response["picture"] as? [String: AnyObject] {
                    if let data = image["data"] as? [String: AnyObject] {
                        params["image_path"] = data["url"] as? String
                    }
                }
                if let location = ApplicationManager.sharedInstance.defaultLocation {
                    params["latitude"] = "\(location.latitude)"
                    params["longitude"] = "\(location.longitude)"
                }
                
                RequestManager.socialLoginUser(param: params, successBlock: { (response) in
                    self.successfulLogin(response: response)
                }, failureBlock: { (error) in
                    if error == "please accept terms and condition!" {
                        Router.showEULA(params: params, fromSignup: false, from: self)
                    }
                    else{
                        UtilityManager.showErrorMessage(body: error, in: self)
                    }
                })
                
            }, failureBlock: { (error) in
                UtilityManager.showErrorMessage(body: error, in: self)
            })
        }
    }
    
    @IBAction func googleButtonPressed(sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func linkedInButtonPressed(sender: AnyObject) {
        
//        if let auth = UserDefaults.standard.value(forKey: UserDefaultKey.linkedInAuthKey) as? String {
//            linkedinLogin(authCode: auth)
//        }
//        else{
            //Get Authorization Code
            self.linkedinClient?.getAuthorizationCode({ (auth_code) -> Void in
                //Get Access Token
                SVProgressHUD.show()
                self.linkedinClient?.getAccessToken(auth_code, success: { (access_token_data) -> Void in
                    let response = access_token_data as! [String: AnyObject]
                    let access_token = response["access_token"] as! String
                    //Gest Profile Data From LinkedIn
                    UserDefaults.standard.set(access_token, forKey: UserDefaultKey.linkedInAuthKey)
                    self.linkedinLogin(authCode: access_token)
                    
                }, failure: { (err) -> Void in
                    self.showAlertView(title: "LinkedIn Login", message: (err?.localizedDescription)!)
                })
                    
                
            }, cancel: { () -> Void in
                //            self.showAlertView(title:"LinkedIn Login", message: "You cancelled the login.")
            }, failure: { (err) -> Void in
                self.showAlertView(title:"LinkedIn Login", message: (err?.localizedDescription)!)
            })
//        }
        
        
    }
    
    func linkedinLogin(authCode: String) {
        
        
            RequestManager.getUserLinkedInProfile(access_token: authCode, successBlock: { (response) -> () in
                SVProgressHUD.show(withStatus: "Logging In")
                
                
                var params = [String: String]()
                
                params["social_provider_name"] = "linkedin"
                params["full_name"] = "\(response["firstName"] as? String ?? "") \(response["lastName"] as? String ?? "")"
                params["social_id"] = response["id"] as? String
                params["email"] = response["emailAddress"] as? String
                params["headline"] = response["headline"] as? String
                params["device_token"] = Messaging.messaging().fcmToken
                params["linkedin_profile"] = response["publicProfileUrl"] as? String
                params["image_path"] = response["pictureUrl"] as? String
                if let companies = response["positions"]!["values"] as? [[String: AnyObject]] {
                    var companyNames = ""
                    for company in companies {
                        if let name = company["company"]!["name"] as? String {
                            companyNames.append(name)
                            companyNames.append(", ")
                        }
                    }
                    //                        params["worked_at"] = companies.first!["company"]!["name"] as? String
                    //                        params["works_at"] = companies.last!["company"]!["name"] as? String
                    companyNames.removeLast()
                    companyNames.removeLast()
                    params["works_at"] = companyNames
                }
                if let location = response["location"]!["name"] as? String {
                    params["lives_in"] = location
                }
                params["about"] = response["summary"] as? String
                if let location = ApplicationManager.sharedInstance.defaultLocation {
                    params["latitude"] = "\(location.latitude)"
                    params["longitude"] = "\(location.longitude)"
                }
                
                RequestManager.socialLoginUser(param: params, successBlock: { (response) in
                    self.successfulLogin(response: response)
                }, failureBlock: { (error) in
                    if error == "please accept terms and condition!" {
                        Router.showEULA(params: params, fromSignup: false, from: self)
                    }
                    else{
                        UtilityManager.showErrorMessage(body: error, in: self)
                    }
                })
                
                
            }, failureBlock: { (error) -> () in
                self.showAlertView(title:"LinkedIn Login", message: error)
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
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func successfulLogin(response: [String: AnyObject]) {
        SVProgressHUD.dismiss()
        let user = User(dictionary: response)
        ApplicationManager.sharedInstance.user = user
        ApplicationManager.sharedInstance.session_id = response["session_id"] as! String
        UserDefaults.standard.set(response["session_id"] as! String, forKey: UserDefaultKey.sessionID)
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
            params["image_path"] = user.profile.imageURL(withDimension: 200).absoluteString
            if let location = ApplicationManager.sharedInstance.defaultLocation {
                params["latitude"] = "\(location.latitude)"
                params["longitude"] = "\(location.longitude)"
            }
            
            RequestManager.socialLoginUser(param: params, successBlock: { (response) in
                self.successfulLogin(response: response)
            }, failureBlock: { (error) in
                if error == "please accept terms and condition!" {
                    Router.showEULA(params: params, fromSignup: false, from: self)
                }
                else{
                    UtilityManager.showErrorMessage(body: error, in: self)
                }
                
            })
            // ...
        } else {
            if error.localizedDescription == "The user canceled the sign-in flow." {
                return
            }
            UtilityManager.showErrorMessage(body: error.localizedDescription, in: self)
        }
    }
    
    func sign(didDisconnectWithUser user: GIDGoogleUser,
                withError error: Error) {
        // Perform any operations when the user disconnects from app here.
        // ...
        SVProgressHUD.dismiss()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " && textField == emailField {
            return false
        }
        return true
    }
    
    @IBAction func termsButtonPressed(_ sender: Any) {
        Router.showTermsAndConditionsWithNav(from: self)
    }
    
}

// Delegates to handle events for the location manager.
extension SignInViewController: CLLocationManagerDelegate {
    
    @objc func setupLocation() {
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
    }
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        ApplicationManager.sharedInstance.defaultLocation = location.coordinate
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        // Display the map using the default location.
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
        locationManager.stopUpdatingLocation()
    }
}



