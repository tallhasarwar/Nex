//
//  GeoFeedBasicTableViewCell.swift
//  Connectivity
//
//  Created by Danial Zahid on 31/12/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class GeoFeedBasicTableViewCell: UITableViewCell {
    
    static let identifier = "geoFeedBasicTableViewCell"
    
    @IBOutlet weak var likeCommentView: UIView!
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        let telefonRegex = "^((\\+)|(00)|(0))[0-9]{6,14}$"
        
        let customType = ActiveType.custom(pattern: telefonRegex)
        bodyLabel.enabledTypes = [.hashtag, .url , .custom(pattern: telefonRegex)]
        bodyLabel.hashtagColor = UIColor(red: 0.06, green: 0.46, blue: 0.96, alpha: 1.0)
        bodyLabel.customColor = [customType: UIColor(red: 0.06, green: 0.46, blue: 0.96, alpha: 1.0)]
        bodyLabel.URLColor = UIColor(red: 0.06, green: 0.46, blue: 0.96, alpha: 1.0)
        bodyLabel.handleURLTap { urlString in
            UIApplication.shared.open(urlString)
        }
        
        
        bodyLabel.handleCustomTap(for: customType) { element in
            print("Custom type tapped: \(element)")
            if let url = URL(string: "tel://\(element)") {
                UIApplication.shared.openURL(url)
            }
        }
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
