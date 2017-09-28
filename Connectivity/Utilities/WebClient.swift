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
    
    
    func getPath(urlString: String,
        params: [String: AnyObject]?,
        addToken: Bool = true,
        successBlock success:@escaping (AnyObject) -> (),
        failureBlock failure: @escaping (NSError) -> ()){
            
            
            let manager = AFHTTPSessionManager()
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFJSONResponseSerializer()
            
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
            failure(error.localizedDescription)
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
    
    func updateProfile(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                   failureBlock failure:@escaping (String) -> ()){
        self.postPath(urlString: Constant.updateProfileURL, params: param as [String : AnyObject], successBlock: { (response) in
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
}
