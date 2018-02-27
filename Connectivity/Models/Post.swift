//
//  Post.swift
//  Connectivity
//
//  Created by Danial Zahid on 03/01/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class Post: BaseEntity {
    
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

    var content: String?
    var location_id: String?
    var location_name: String?
    var latitude: String?
    var longitude: String?
    var image_path: String?
    var created_at: NSDate?
    var full_name: String?
    var id: String?
    var user_id: String?
    var user_image: String?
    var radius: String?
    var distance: String?
    var postImages: Images?
    var profileImages = Images()
    var isDeletionPopUpShowing = false
    
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
    }
    
}
