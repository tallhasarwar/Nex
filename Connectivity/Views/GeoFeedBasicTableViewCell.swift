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

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        bodyLabel.enabledTypes = [.hashtag]
        bodyLabel.hashtagColor = UIColor(red: 0.06, green: 0.46, blue: 0.96, alpha: 1.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
