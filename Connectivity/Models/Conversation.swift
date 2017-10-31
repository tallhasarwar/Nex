//
//  Conversation.swift
//  Connectivity
//
//  Created by Danial Zahid on 30/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import Firebase

class Conversation: BaseEntity {

    //MARK: Properties
    let user: User
    var lastMessage: Message
    
    //MARK: Inits
    init(user: User, lastMessage: Message) {
        self.user = user
        self.lastMessage = lastMessage
        super.init()
    }
//    
//    override init() {
//        super.init()
//    }
//    
//    override init(dictionary: [AnyHashable : Any]!) {
//        super.init()
//        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: nil)
//    }
    
    //MARK: Methods
    class func showConversations(completion: @escaping ([Conversation]) -> Swift.Void) {
        if let currentUserID = ApplicationManager.sharedInstance.user.user_id {
            var conversations = [Conversation]()
            Database.database().reference().child("users").child(currentUserID).child("conversations").observe(.childAdded, with: { (snapshot) in
                if snapshot.exists() {
                    let fromID = snapshot.key
                    let values = snapshot.value as! [String: String]
                    let location = values["location"]!
                    RequestManager.getOtherProfile(userID: fromID, successBlock: { (response) in
                        let user = User(dictionary: response["user"] as! [String: AnyObject])
                        let emptyMessage = Message.init(type: .text, content: "loading", owner: .sender, timestamp: 0, isRead: true)
                        let conversation = Conversation.init(user: user, lastMessage: emptyMessage)
                        conversations.append(conversation)
                        conversation.lastMessage.downloadLastMessage(forLocation: location, completion: {
                            completion(conversations)
                        })
                    }, failureBlock: { (error) in
                        SVProgressHUD.showError(withStatus: error)
                    })
                    
                
                }
            })
        }
    }
}
