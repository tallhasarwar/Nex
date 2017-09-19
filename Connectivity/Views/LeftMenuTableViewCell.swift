//
//  LeftMenuTableViewCell.swift
//  Quicklic
//
//  Created by Danial Zahid on 29/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class LeftMenuTableViewCell: UITableViewCell {

    static let identifier = "leftMenuTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
