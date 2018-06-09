//
//  PostDetailViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 6/6/18.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController, EasyTipViewDelegate, UITableViewDelegate, UITableViewDataSource {

    static let storyboardID = "postDetailViewController"
    
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var bodyLabel: ActiveLabel!
    @IBOutlet weak var profileNameButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var atLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var radiusLabelCheckinConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageOverlayButton: UIButton!
    @IBOutlet weak var postImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingSpaceToOptionsButton: NSLayoutConstraint!
    @IBOutlet weak var optionsButton: UIButton!
    
    @IBOutlet weak var likeCommentLabel: UILabel!
    @IBOutlet weak var likeCommentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var likesViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var likesCollectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var post = Post()
    
    @objc var isDeletionPopUpShowing = false
    @objc var easyTipView: EasyTipView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var headerViewHeight = 293

        if let images = post.postImages {
            let calculatedHeight = Float(self.tableView.frame.size.width) / (images.medium.aspect ?? 1.0)
            postImageHeightConstraint.constant = CGFloat(calculatedHeight)
            headerViewHeight += Int(calculatedHeight)
            
            postImageView.sd_setImage(with: URL(string: images.medium.url), placeholderImage: UIImage(named: "placeholder-banner"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], completed: { (image, error, cacheType, url) in
                
            })
            
            imageOverlayButton.addTarget(self, action: #selector(self.openImage(_:)), for: .touchUpInside)
            
        }
        else{
            postImageHeightConstraint.constant = CGFloat(0)
        }
        
        //        geoFeedImageTableViewCell
        
        bodyLabel.text = post.content
        if post.location_name != nil && post.location_name?.count ?? 0 > 0 {
            atLabel.isHidden = false
            atLabel.text = "at"
            locationButton.isHidden = false
            locationButton.setTitle(post.location_name, for: .normal)
            radiusLabelCheckinConstraint.isActive = false
        }
        else{
            atLabel.isHidden = true
            locationButton.isHidden = true
            atLabel.text = nil
            radiusLabelCheckinConstraint.isActive = true
            self.tableView.tableHeaderView?.layoutSubviews()
            radiusLabel.layoutIfNeeded()
            
        }
        
        if let radius = post.distance {
            radiusLabel.text = "(\(radius) away)"
        }
        else {
            radiusLabel.text = ""
        }
        
        profileNameButton.setTitle(post.full_name, for: .normal)
        profileNameButton.addTarget(self, action: #selector(self.showProfile(_:)), for: .touchUpInside)
        profileImageView.sd_setImage(with: URL(string: post.profileImages.small.url), placeholderImage: UIImage(named: "placeholder-image"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], completed: nil)
        timeLabel.text = UtilityManager.timeAgoSinceDate(date: post.created_at!, numericDates: true)
        
        
        optionsButton.isHidden = false
        trailingSpaceToOptionsButton.constant = 0

        optionsButton.addTarget(self, action: #selector(self.showDeletionPopup(_:)), for: .touchUpInside)
        
        if let tipView = post.easyTipView {
            post.isDeletionPopUpShowing = false
            tipView.delegate = nil
            tipView.dismiss()
        }
        let likeCount = post.likeCount ?? 0
        let commentCount = post.commentCount ?? 0
        
        if likeCount <= 0 {
            likesViewHeightConstraint.constant = 0
            headerViewHeight -= 70
            if commentCount <= 0 {
                headerViewHeight -= 30
            }
        }
        
        var likeCommentCount = ""
        
        if likeCount > 0 || commentCount > 0 {
            likeCommentCount.append("\(likeCount) ")
            likeCommentCount.append(likeCount == 1 ? "Like  •  " : "Likes  •  ")
            likeCommentCount.append("\(commentCount) ")
            likeCommentCount.append(commentCount == 1 ? "Comment" : "Comments")
            
        }
        
        likeCommentLabel.text = likeCommentCount
        
        likeButton.addTarget(self, action: #selector(self.likePostButtonPressed(_:)), for: .touchUpInside)
        
        commentButton.addTarget(self, action: #selector(self.commentPostButtonPressed(_:)), for: .touchUpInside)
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: Int(self.tableView.frame.width), height: headerViewHeight)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func openImage(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath (row: sender.tag, section: 0)) as! GeoFeedBasicTableViewCell
        removeToolTip()
        let image = LightboxImage(image: cell.postImageView.image!, text: cell.bodyLabel.text!, videoURL: nil)
        
        let controller = LightboxController(images: [image], startIndex: 0)
        
        controller.footerView.pageLabel.isHidden = true
        controller.footerView.separatorView.isHidden = true
        
        // Use dynamic background.
        controller.dynamicBackground = true
        
        // Present your controller.
        present(controller, animated: true, completion: nil)
        
    }
    
    @objc func showProfile(_ sender: UIButton) {
        let userID = post.user_id
        removeToolTip()
        let user = User()
        user.user_id = userID
        Router.showProfileViewController(user: user, from: self)
    }
    
    @objc func likePostButtonPressed(_ sender: UIButton) {
        let post = self.post
        
        var params = [String: AnyObject]()
        params["post_id"] = post.id as AnyObject
        params["user_id"] = ApplicationManager.sharedInstance.user.user_id as AnyObject
        params["post_action"] = !sender.isSelected ? "like" as AnyObject : "dislike" as AnyObject
        
        sender.isEnabled = false
        RequestManager.likePost(param: params, successBlock: { (response) in
            sender.isSelected = !sender.isSelected
            sender.isEnabled = true
            self.post.likeCount = response["postCount"] as? Int ?? 0
            self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: UITableViewRowAnimation.none)
        }) { (error) in
            
        }
        
    }
    
    @objc func commentPostButtonPressed(_ sender: UIButton) {
        
    }
    
    func removeToolTip() {
        
        if let tipView = easyTipView {
            isDeletionPopUpShowing = false
            tipView.delegate = nil
            tipView.dismiss()
        }
        
    }
    
    @objc func showDeletionPopup(_ sender: UIButton) {
        
        
        if (isDeletionPopUpShowing){
            let tipView : EasyTipView
            
            if post.user_id == ApplicationManager.sharedInstance.user.user_id {
                tipView = EasyTipView(text: "     Delete        ", delegate: self)
            }
            else{
                tipView = EasyTipView(text: "     Report        ", delegate: self)
            }
            
            tipView.show(animated: true, forView: sender, withinSuperview: sender.superview)
            //            EasyTipView.show(animated: true, forView: sender, withinSuperview: sender.superview, text: "Delete", delegate: self)
            easyTipView = tipView
            isDeletionPopUpShowing = true
        }
        else{
            isDeletionPopUpShowing = false
            if let tipView = easyTipView{
                tipView.delegate = nil
                tipView.dismiss()
            }
        }
        
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        
        
        if tipView.presentingView != nil
        {
            isDeletionPopUpShowing = false
            let post = self.post
            
            let params = ["post_id":post.id ?? "0"]
            
            if post.user_id == ApplicationManager.sharedInstance.user.user_id {
                UIAlertController.showAlert(in: self, withTitle: "Confirm", message: "Are you sure you want to delete this post?", cancelButtonTitle: "No", destructiveButtonTitle: nil, otherButtonTitles: ["Yes"], tap: { (alertController, alertAction, buttonIndex) in
                    if alertAction.title == "Yes" {
                        SVProgressHUD.show()
                        RequestManager.deletePosts(param: params, successBlock: { (response) in
                            self.navigationController?.popViewController(animated: true)
                        }) { (error) in
                            UtilityManager.showErrorMessage(body: error, in: self)
                        }
                    }
                })
            }
            else{
                UIAlertController.showAlert(in: self, withTitle: "Confirm", message: "Are you sure you want to report this post?", cancelButtonTitle: "No", destructiveButtonTitle: nil, otherButtonTitles: ["Yes"], tap: { (alertController, alertAction, buttonIndex) in
                    if alertAction.title == "Yes" {
                        SVProgressHUD.show()
                        RequestManager.reportPosts(param: params, successBlock: { (response) in
                            
                        }) { (error) in
                            UtilityManager.showErrorMessage(body: error, in: self)
                        }
                    }
                })
            }
            
            
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier) as! CommentTableViewCell
        return cell
    }

}
