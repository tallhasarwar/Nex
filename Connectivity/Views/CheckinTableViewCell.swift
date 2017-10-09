//
//  CheckinTableViewCell.swift
//  Connectivity
//
//  Created by Danial Zahid on 06/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class CheckinTableViewCell: UITableViewCell {
    
    static let identifier = "checkinTableViewCell"

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
