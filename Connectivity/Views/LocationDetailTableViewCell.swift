//
//  LocationDetailTableViewCell.swift
//  Connectivity
//
//  Created by Danial Zahid on 16/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class LocationDetailTableViewCell: UITableViewCell {

    static let identifier = "locationDetailTableViewCell"
    
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var activationTimeLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
