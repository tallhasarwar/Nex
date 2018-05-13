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
    static let sharedInstance = WebClient(url: NSURL(string: Constant.serverURL)!, securityPolicy: AFSecurityPolicy(pinningMode: AFSSLPinningMode.none))
    
    
    convenience init(url: NSURL, securityPolicy: AFSecurityPolicy){
        self.init(baseURL: url as URL)
        self.securityPolicy = securityPolicy
        
    }
    
    
    func postPath(urlString: String,
                  params: [String: AnyObject],
                  addToken: Bool = true,
                  successBlock success:@escaping (AnyObject) -> (),
                  failureBlock failure: @escaping (String) -> ()){
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        if let sessionID = UserDefaults.standard.value(forKey: UserDefaultKey.sessionID) as? String {
            manager.requestSerializer.setValue(sessionID, forHTTPHeaderField: UserDefaultKey.sessionID)
        }
        
        manager.post((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, progress: nil, success: {
            (sessionTask, responseObject) -> () in
            print(responseObject ?? "")
            success(responseObject! as AnyObject)
        },  failure: {
            (sessionTask, error) -> () in
            print(error)
            
            let err = error as NSError
            do {

                
                if let data = err.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data {
                    let dictionary = try JSONSerialization.jsonObject(with: data,
                                                                      options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                    
                    if let status = dictionary["status"] as? String {
                        if status == "403" {
                            Router.logout()
                        }
                        
                    }
                    
                    failure(dictionary["message"]! as! String)
                }
                else{
                    failure("Failed to connect")
                }
            }catch
            {
                failure(error.localizedDescription)
            }
            
        })
    }
    
    func multipartPost(urlString: String,
                       params: [String: AnyObject],
                       image: UIImage?,
                       imageName: String,
                       addToken: Bool = true,
                       progressBlock progressB:@escaping (Int) -> (),
                       successBlock success:@escaping (AnyObject) -> (),
                       failureBlock failure: @escaping (NSError) -> ()){
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        
        if let sessionID = UserDefaults.standard.value(forKey: UserDefaultKey.sessionID) as? String {
            manager.requestSerializer.setValue(sessionID, forHTTPHeaderField: UserDefaultKey.sessionID)
        }
        
        manager.post((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, constructingBodyWith: { (data) in
            if image != nil {
                if let imageData = UIImagePNGRepresentation(image!) {
                    data.appendPart(withFileData: imageData, name: imageName, fileName: "image", mimeType: "image/jpeg")
                }
            }
            
        }, progress: { (progress) in
            progressB(Int(progress.completedUnitCount))
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
            manager.requestSerializer.setValue(sessionID, forHTTPHeaderField: UserDefaultKey.sessionID)
        }
        
        manager.get((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, progress: nil, success: {
            (sessionTask, responseObject) -> () in
//            print(responseObject ?? "")
            success(responseObject! as AnyObject)
        }, failure: {
            (sessionTask, error) -> () in
            print(error)
            failure(error as NSError)
            
            let err = error as NSError
            do {
                
                if let data = err.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data {
                    let dictionary = try JSONSerialization.jsonObject(with: data,
                                                                      options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                    if let status = dictionary["status"] as? String {
                        if status == "403" {
                            Router.logout()
                        }
                        
                    }
                }
            }
            catch {
                
            }
        })
    }
    
    func deletePath(urlString: String,
                 params: [String: AnyObject]?,
                 addToken: Bool = true,
                 successBlock success:@escaping (AnyObject) -> (),
                 failureBlock failure: @escaping (NSError) -> ()){
        
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        if let sessionID = UserDefaults.standard.value(forKey: UserDefaultKey.sessionID) as? String , addToken == true {
            manager.requestSerializer.setValue(sessionID, forHTTPHeaderField: UserDefaultKey.sessionID)
        }
        
        manager.delete((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, success: {
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
//            if error.code == 422 {
//                failure("Email already in use")
//            }
//            else{
//                failure(error.localizedDescription)
//            }
            failure(error)
            
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
                    failure("Invalid credentials")
                }
            }
        }) { (error) in
//            if error.code == 422 {
//                failure("Invalid credentials")
//            }
//            failure(error.localizedDescription)
            failure(error)
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
        
        self.multipartPost(urlString: Constant.updateProfileURL, params: param as [String : AnyObject], image: image, imageName: "image", progressBlock: { (progress) in
            
        }, successBlock: { (response) in
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
        
        self.getPath(urlString: "https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,email-address,headline,public-profile-url,picture-url,location,industry,summary,positions)?oauth2_access_token=\(access_token)&format=json&secure-urls=true",
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
    
    func getUserFacebookProfileImage(userID: String,
                                successBlock success:@escaping ([String: AnyObject]) -> (),
                                failureBlock failure:@escaping (String) -> ()) {
        self.getPath(urlString: "https://graph.facebook.com/\(userID)/?fields=picture",
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
//            failure(error.localizedDescription)
            failure(error)
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
//            failure(error.localizedDescription)
            failure(error)
        }
    }
    
    func checkinEvent(param: [String: Any], successBlock success:@escaping ([[String: AnyObject]]) -> (),
                         failureBlock failure:@escaping (String) -> ()){
        self.getPath(urlString: Constant.checkinEventURL, params: param as [String : AnyObject], successBlock: { (response) in
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
//            failure(error.localizedDescription)
            failure(error)
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
    
    func getOtherBusinessCard(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                         failureBlock failure:@escaping (String) -> ()){
        self.postPath(urlString: "get_other_bcard", params: param as [String : AnyObject], successBlock: { (response) in
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
            failure(error)
        }
    }
    
    func addBusinessCard(param: [String: Any], image: UIImage?, successBlock success:@escaping ([String: AnyObject]) -> (),
                     failureBlock failure:@escaping (String) -> ()){
        self.multipartPost(urlString: Constant.addBusinessCardURL, params: param as [String : AnyObject], image: image, imageName: "image", progressBlock: { (progress) in
            
        }, successBlock: { (response) in
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
//            failure(error.localizedDescription)
            failure(error)
        }
    }
    
    
    func respondToConnectionRequest(userID : String, accepted: Bool = true, successBlock success:@escaping ([String: AnyObject]) -> (),
                         failureBlock failure:@escaping (String) -> ()){
        
        var param = ["connection_from_id":userID]
        if !accepted{
            param["status"] = "REJECTED"
        }
        else{
            param["status"] = "ACCEPTED"
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
//            failure(error.localizedDescription)
            failure(error)
        }
    }
    
    func forgotPassword(email: String, successBlock success:@escaping ([String: AnyObject]) -> (),
                                    failureBlock failure:@escaping (String) -> ()){
        
        let param = ["email":email]
        
        self.postPath(urlString: Constant.forgotPasswordURL, params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response as! [String : AnyObject])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
//            failure(error.localizedDescription)
            failure(error)
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
    
    func getNearbyEvents(param: [String: Any], successBlock success:@escaping ([[String: AnyObject]]) -> (),
                      failureBlock failure:@escaping (String) -> ()){
        self.getPath(urlString: Constant.getNearbyEventsURL, params: param as [String : AnyObject], successBlock: { (response) in
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
        
        self.multipartPost(urlString: Constant.createEventURL, params: param as [String : AnyObject], image: image, imageName: "image_path", progressBlock: { (progress) in
            
        }, successBlock: { (response) in
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
    
    
    func getLocations(param: [String: Any], successBlock success:@escaping (_ response: [[String: AnyObject]], _ nextPageToken: String?) -> (),
                      failureBlock failure:@escaping (String) -> ()){
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        manager.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json", parameters: param, progress: nil, success: { (sessionTask, response) in
            print(response ?? "")
            
            if let responseObject = response as? [String: AnyObject] {
                if responseObject["status"] as! String == "OK" {
                    success(responseObject["results"] as! [[String: AnyObject]], responseObject["next_page_token"] as? String)
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
    
    func getAddressForCoords(param: [String: Any], successBlock success:@escaping (_ response: [[String: AnyObject]]) -> (),
                      failureBlock failure:@escaping (String) -> ()){
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        manager.get("https://maps.googleapis.com/maps/api/geocode/json", parameters: param, progress: nil, success: { (sessionTask, response) in
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
    
    func markNotificationsRead(param: [String: Any],
                               successBlock success:@escaping ([[String: AnyObject]]) -> (),
                               failureBlock failure:@escaping (String) -> ()){
        self.getPath(urlString: Constant.markNotificationsReadURL, params: param as [String : AnyObject], successBlock: { (response) in
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
    
    func createPost(param: [String: Any],image: UIImage?, successBlock success:@escaping ([String: AnyObject]) -> (),
                       failureBlock failure:@escaping (String) -> ()){
        
        if image != nil {
            self.multipartPost(urlString: Constant.createPostURL, params: param as [String : AnyObject], image: image, imageName: "image_path", progressBlock: { (progress) in
                
            }, successBlock: { (response) in
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
        else{
            self.postPath(urlString: Constant.createPostURL, params: param as [String : AnyObject], successBlock: { (response) in
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
//                failure(error.localizedDescription)
                failure(error)
            }
        }
    }
    
    
    func getPosts(param: [String: Any], successBlock success:@escaping ([[String: AnyObject]]) -> (),
                        failureBlock failure:@escaping (String) -> ()){
        self.getPath(urlString: Constant.getPostURL, params: param as [String : AnyObject], successBlock: { (response) in
//            print(response)
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
    
    func deletePosts(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                  failureBlock failure:@escaping (String) -> ()){
        self.deletePath(urlString: Constant.deletePostURL, params: param as [String : AnyObject], successBlock: { (response) in
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
    
    func reportPosts(param: [String: Any], successBlock success:@escaping ([[String: AnyObject]]) -> (),
                     failureBlock failure:@escaping (String) -> ()){
        self.postPath(urlString: Constant.reportPostURL, params: param as [String : AnyObject], successBlock: { (response) in
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
//            failure(error.localizedDescription)
            failure(error)
        }
    }
    
    func deleteUser(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                     failureBlock failure:@escaping (String) -> ()){
        self.deletePath(urlString: Constant.deleteUserURL, params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success([:])
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
    
    
    func logoutUser(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                  failureBlock failure:@escaping (String) -> ()){
        self.getPath(urlString: Constant.logoutURL, params: param as [String : AnyObject], successBlock: { (response) in
            //            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success([:])
//                success(response[Constant.responseKey] as! [[String : AnyObject]])
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
    
    func reportUser(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                   failureBlock failure:@escaping (String) -> ()){
        self.postPath(urlString: "report_user", params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success([:])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            //            failure(error.localizedDescription)
            failure(error)
        }
    }
    
    func blockUser(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                     failureBlock failure:@escaping (String) -> ()){
        self.postPath(urlString: "block_user", params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success([:])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            //            failure(error.localizedDescription)
            failure(error)
        }
    }
    
}
