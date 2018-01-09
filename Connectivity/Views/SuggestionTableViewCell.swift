//
//  SuggestionTableViewCell.swift
//  Connectivity
//
//  Created by Danial Zahid on 09/01/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class SuggestionTableViewCell: UITableViewCell {

    static let identifier = "suggestionTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
