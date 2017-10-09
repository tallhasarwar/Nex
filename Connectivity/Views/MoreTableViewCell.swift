//
//  MoreTableViewCell.swift
//  Connectivity
//
//  Created by Danial Zahid on 02/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class MoreTableViewCell: UITableViewCell {
    
    static let identifier = "moreTableViewCell"

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
