//
//  ProfileDetailTableViewCell.swift
//  Connectivity
//
//  Created by Danial Zahid on 24/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ProfileDetailTableViewCell: UITableViewCell {

    static let identifier = "profileDetailTableViewCell"
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
