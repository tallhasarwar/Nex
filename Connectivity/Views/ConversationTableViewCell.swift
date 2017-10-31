//
//  ConversationTableViewCell.swift
//  Connectivity
//
//  Created by Danial Zahid on 30/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {

    static let identifier = "conversationTableViewCell"
    
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
