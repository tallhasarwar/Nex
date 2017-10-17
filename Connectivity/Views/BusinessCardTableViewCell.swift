//
//  BusinessCardTableViewCell.swift
//  Connectivity
//
//  Created by Danial Zahid on 11/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class BusinessCardTableViewCell: UITableViewCell {

    static let identifier = "businessCardTableViewCell"
    
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
