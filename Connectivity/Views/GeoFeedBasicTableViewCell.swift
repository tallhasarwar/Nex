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
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var profileNameButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var atLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
