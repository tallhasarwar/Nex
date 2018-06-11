//
//  PopOverTableViewCell.swift
//  Connectivity
//
//  Created by Danial Zahid on 6/11/18.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class PopOverTableViewCell: UITableViewCell {

    static let identifier = "popOverTableViewCell"
    
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
