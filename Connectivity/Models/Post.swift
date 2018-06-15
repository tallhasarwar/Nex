//
//  Post.swift
//  Connectivity
//
//  Created by Danial Zahid on 03/01/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

@objc class Post: BaseEntity {
    
    /*{
     "updated_at": <null>, "full_name": Anwar Malik, "current_longitude": 74.3054983, "checkin_latitude": <null>, "location_id": <null>, "content": different aspect ratio kamaal  #photo, "current_latitude": 31.4761983, "location_name": <null>, "id": 76, "post_images": {
     meduim =     {
     aspect = "1.502";
     height = 333;
     maxWidth = 500;
     suffix = "-medium";
     url = "https://s3-us-east-2.amazonaws.com/connect1395/posts/8d0e7ada-f13b-4c73-86f7-400d6d505a16-medium.jpg";
     width = 500;
     };
     orignal =     {
     aspect = "1.500";
     height = 588;
     original = 1;
     url = "https://s3-us-east-2.amazonaws.com/connect1395/posts/8d0e7ada-f13b-4c73-86f7-400d6d505a16.jpg";
     width = 882;
     };
     small =     {
     aspect = "1.000";
     height = 80;
     maxHeight = 80;
     maxWidth = 80;
     suffix = "-thumb1";
     url = "https://s3-us-east-2.amazonaws.com/connect1395/posts/8d0e7ada-f13b-4c73-86f7-400d6d505a16-thumb1.jpg";
     width = 80;
     };
     }, "created_at": 2018-01-29T19:14:21.474Z, "distance": 6.7 km, "title": <null>, "user_id": 91, "checkin_longitude": <null>, "image_path": <null>], ["profile_images": {
     meduim =     {
     aspect = "1.000";
     height = 500;
     maxWidth = 500;
     suffix = "-medium";
     url = "https://s3-us-east-2.amazonaws.com/connect1395/profile/c4854172-59a6-424e-8c8e-2748bbf03774-medium.jpg";
     width = 500;
     };
     orignal =     {
     aspect = "1.000";
     height = 400;
     original = 1;
     url = "https://s3-us-east-2.amazonaws.com/connect1395/profile/c4854172-59a6-424e-8c8e-2748bbf03774.jpg";
     width = 400;
     };
     small =     {
     aspect = "1.000";
     height = 80;
     maxHeight = 80;
     maxWidth = 80;
     suffix = "-thumb1";
     url = "https://s3-us-east-2.amazonaws.com/connect1395/profile/c4854172-59a6-424e-8c8e-2748bbf03774-thumb1.jpg";
     width = 80;
     };
     },*/

    @objc var content: String?
    @objc var location_id: String?
    @objc var location_name: String?
    @objc var latitude: String?
    @objc var longitude: String?
    @objc var image_path: String?
    @objc var created_at: NSDate?
    @objc var full_name: String?
    @objc var id: String?
    @objc var user_id: String?
    @objc var user_image: String?
    @objc var radius: String?
    @objc var distance: String?
    @objc var postImages: Images?
    @objc var profileImages = Images()
    @objc var isOptionsPopUpShowing = false
    @objc var easyTipView: EasyTipView?
    @objc var optionsPopover: Popover!
    
    @objc var number_of_comments: String?
    @objc var number_of_likes: String?
//    @objc var post_action: String?
    
    var commentCount : Int?
    var likeCount : Int?
    
    var isSelfLiked: Bool?
    
    var commentsArray = [Comment]()
    var likesArray = [User]()
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = Constant.serverDateFormat
        newDateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: newDateFormatter)
        if let postimages = dictionary["post_images"] as? [String: AnyObject] {
            self.postImages = Images(dictionary: postimages)
        }
        if let profileImages = dictionary["profile_images"] as? [String: AnyObject] {
            self.profileImages = Images(dictionary: profileImages)
        }
        
        if let comments = number_of_comments {
            commentCount = Int(comments)
        }
        
        if let likes = number_of_likes {
            likeCount = Int(likes)
        }
        
        self.likesArray.removeAll()
        if let likeUsers = dictionary["likedUser"] as? [[String: AnyObject]] {
            for user in likeUsers {
                self.likesArray.append(User(dictionary: user))
            }
        }
        
        if let isLiked = dictionary["post_action"] as? String {
            if isLiked == "like" {
                self.isSelfLiked = true
            }
        }
        
        self.commentsArray.removeAll()
        if let comments = dictionary["comments"] as? [[String: AnyObject]] {
            for comment in comments {
                self.commentsArray.append(Comment(dictionary: comment))
            }
        }
        
    }
    
}
