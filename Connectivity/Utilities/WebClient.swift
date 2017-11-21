//
//  WebClient.swift
//  WeatherApp
//
//  Created by Danial Zahid on 12/26/15.
//  Copyright © 2015 Danial Zahid. All rights reserved.
//

import UIKit

let RequestManager = WebClient.sharedInstance

class WebClient: AFHTTPSessionManager {
    
    //MARK: - Shared Instance
    static let sharedInstance = WebClient(url: NSURL(string: Constant.serverURL)!, securityPolicy: AFSecurityPolicy(pinningMode: AFSSLPinningMode.publicKey))
    
    
    convenience init(url: NSURL, securityPolicy: AFSecurityPolicy){
        self.init(baseURL: url as URL)
        self.securityPolicy = securityPolicy
        
    }
    
    
    func postPath(urlString: String,
                  params: [String: AnyObject],
                  addToken: Bool = true,
                  successBlock success:@escaping (AnyObject) -> (),
                  failureBlock failure: @escaping (NSError) -> ()){
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        if let sessionID = UserDefaults.standard.value(forKey: UserDefaultKey.sessionID) as? String {
            manager.requestSerializer.setValue(sessionID, forHTTPHeaderField: "session_id")
        }
        
        manager.post((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, progress: nil, success: {
            (sessionTask, responseObject) -> () in
            print(responseObject ?? "")
            success(responseObject! as AnyObject)
        },  failure: {
            (sessionTask, error) -> () in
            print(error)
            failure(error as NSError)
            
        })
    }
    
    func multipartPost(urlString: String,
                       params: [String: AnyObject],
                       image: UIImage?,
                       imageName: String,
                       addToken: Bool = true,
                       successBlock success:@escaping (AnyObject) -> (),
                       failureBlock failure: @escaping (NSError) -> ()){
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        
        if let sessionID = UserDefaults.standard.value(forKey: UserDefaultKey.sessionID) as? String {
            manager.requestSerializer.setValue(sessionID, forHTTPHeaderField: "session_id")
        }
        
        manager.post((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, constructingBodyWith: { (data) in
            if image != nil {
                if let imageData = UIImagePNGRepresentation(image!) {
                    data.appendPart(withFileData: imageData, name: imageName, fileName: "image", mimeType: "image/jpeg")
                }
            }
            
        }, progress: { (progress) in
            
        }, success: {
            (sessionTask, responseObject) -> () in
            print(responseObject ?? "")
            success(responseObject! as AnyObject)
        },  failure: {
            (sessionTask, error) -> () in
            print(error)
            failure(error as NSError)
        })
    }
    
    
    func getPath(urlString: String,
                 params: [String: AnyObject]?,
                 addToken: Bool = true,
                 successBlock success:@escaping (AnyObject) -> (),
                 failureBlock failure: @escaping (NSError) -> ()){
        
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        if let sessionID = UserDefaults.standard.value(forKey: UserDefaultKey.sessionID) as? String , addToken == true {
            manager.requestSerializer.setValue(sessionID, forHTTPHeaderField: "session_id")
        }
        
        manager.get((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, progress: nil, success: {
            (sessionTask, responseObject) -> () in
            print(responseObject ?? "")
            success(responseObject! as AnyObject)
        }, failure: {
            (sessionTask, error) -> () in
            print(error)
            failure(error as NSError)
            
        })
    }
    
    
    
    func signUpUser(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                    failureBlock failure:@escaping (String) -> ()){
        self.postPath(urlString: Constant.registrationURL, params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [String : AnyObject])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }
                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            if error.code == 422 {
                failure("Email already in use")
            }
            else{
                failure(error.localizedDescription)
            }
            
            
        }
    }
    
    func loginUser(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                   failureBlock failure:@escaping (String) -> ()){
        self.postPath(urlString: Constant.loginURL, params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [String : AnyObject])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }
                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    func getUser(successBlock success:@escaping ([String: AnyObject]) -> (),
                 failureBlock failure:@escaping (String) -> ()){
        
        self.getPath(urlString: Constant.getProfileURL, params: [:] as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [String : AnyObject])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }
                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    func updateProfile(param: [String: Any],image: UIImage?, successBlock success:@escaping ([String: AnyObject]) -> (),
                       failureBlock failure:@escaping (String) -> ()){
        
        self.multipartPost(urlString: Constant.updateProfileURL, params: param as [String : AnyObject], image: image, imageName: "image", successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [String : AnyObject])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }
                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
        
    }
    
    func getUserLinkedInProfile(access_token: String,
                                successBlock success:@escaping ([String: AnyObject]) -> (),
                                failureBlock failure:@escaping (String) -> ()){
        
        self.getPath(urlString: "https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,email-address,headline,public-profile-url,picture-url)?oauth2_access_token=\(access_token)&format=json&secure-urls=true",
            params: nil,addToken: false, successBlock: { (response) -> () in
                success(response as! [String : AnyObject])
        }) { (error: NSError) -> () in
            failure(error.localizedDescription)
        }
    }
    
    func getUserFacebookProfile(url: String,
                                successBlock success:@escaping ([String: AnyObject]) -> (),
                                failureBlock failure:@escaping (String) -> ()) {
        self.getPath(urlString: url,
                     params: [:],addToken: false, successBlock: { (response) -> () in
                        success(response as! [String : AnyObject])
        }) { (error: NSError) -> () in
            failure(error.localizedDescription)
        }
    }
    
    func searchNearbyPlaces(location: CLLocationCoordinate2D,
                            radius: Float,
                                successBlock success:@escaping ([String: AnyObject]) -> (),
                                failureBlock failure:@escaping (String) -> ()) {
        
        let params = ["location":"\(location.latitude),\(location.longitude)","radius":radius,"key":"AIzaSyBliG3t916BMDv_HmDcgfv-N55kuvwx8Jo"] as [String : AnyObject]
        
        self.getPath(urlString: Constant.googleNearbyURL,
                     params: params,addToken: false, successBlock: { (response) -> () in
                        success(response as! [String : AnyObject])
        }) { (error: NSError) -> () in
            failure(error.localizedDescription)
        }
    }
    
    func socialLoginUser(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                         failureBlock failure:@escaping (String) -> ()){
        self.postPath(urlString: Constant.socialLoginURL, params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [String : AnyObject])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }
                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    func checkinLocation(param: [String: Any], successBlock success:@escaping ([[String: AnyObject]]) -> (),
                       failureBlock failure:@escaping (String) -> ()){
        self.postPath(urlString: Constant.checkinLocationURL, params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [[String : AnyObject]])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }
                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    func sendRequest(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                         failureBlock failure:@escaping (String) -> ()){
        self.postPath(urlString: "send_connect_request", params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [String : AnyObject])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }
                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    func getBusinessCard(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                     failureBlock failure:@escaping (String) -> ()){
        self.getPath(urlString: Constant.getBusinessCardURL, params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [String : AnyObject])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }
                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    func addBusinessCard(param: [String: Any], image: UIImage?, successBlock success:@escaping ([String: AnyObject]) -> (),
                     failureBlock failure:@escaping (String) -> ()){
        self.multipartPost(urlString: Constant.addBusinessCardURL, params: param as [String : AnyObject], image: image, imageName: "image", successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [String : AnyObject])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    func getPendingRequests(param: [String: Any], successBlock success:@escaping ([[String: AnyObject]]) -> (),
                         failureBlock failure:@escaping (String) -> ()){
        self.getPath(urlString: Constant.getPendingRequestsURL, params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [[String : AnyObject]])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    func getAllNotifications(param: [String: Any], successBlock success:@escaping ([[String: AnyObject]]) -> (),
                            failureBlock failure:@escaping (String) -> ()){
        self.getPath(urlString: Constant.getAllNotificationsURL, params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [[String : AnyObject]])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    func getOtherProfile(userID : String, successBlock success:@escaping ([String: AnyObject]) -> (),
                             failureBlock failure:@escaping (String) -> ()){
        
        let param = ["user_id":userID]
        
        self.postPath(urlString: Constant.getOtherProfileURL, params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [String : AnyObject])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    
    func respondToConnectionRequest(userID : String, accepted: Bool = true, successBlock success:@escaping ([String: AnyObject]) -> (),
                         failureBlock failure:@escaping (String) -> ()){
        
        var param = ["connection_from_id":userID]
        if !accepted{
            param["status"] = "REJECTED"
        }
        
        self.postPath(urlString: Constant.respondToRequestURL, params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [String : AnyObject])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    func getAllEvents(param: [String: Any], successBlock success:@escaping ([[String: AnyObject]]) -> (),
                             failureBlock failure:@escaping (String) -> ()){
        self.getPath(urlString: Constant.getEventsURL, params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [[String : AnyObject]])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    func addEvent(param: [String: Any], image: UIImage, successBlock success:@escaping ([String: AnyObject]) -> (),
                         failureBlock failure:@escaping (String) -> ()){
        
        self.multipartPost(urlString: Constant.createEventURL, params: param as [String : AnyObject], image: image, imageName: "image_path", successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [String : AnyObject])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
        
    }
    
    
    func getLocations(param: [String: Any], successBlock success:@escaping ([[String: AnyObject]]) -> (),
                      failureBlock failure:@escaping (String) -> ()){
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        manager.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json", parameters: param, progress: nil, success: { (sessionTask, response) in
            print(response ?? "")
            
            if let responseObject = response as? [String: AnyObject] {
                if responseObject["status"] as! String == "OK" {
                    success(responseObject["results"] as! [[String: AnyObject]])
                }
                else{
                    failure("Failed to load locations")
                }
            }
            else{
                failure("Failed to load locations")
            }
            
            
            
        }) { (sessionTask, error) in
            print(error)
            failure(error.localizedDescription)
        }
    }
    
    func getConnections(param: [String: Any], successBlock success:@escaping ([[String: AnyObject]]) -> (),
                      failureBlock failure:@escaping (String) -> ()){
        self.getPath(urlString: Constant.getConnectionsURL, params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [[String : AnyObject]])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
}
