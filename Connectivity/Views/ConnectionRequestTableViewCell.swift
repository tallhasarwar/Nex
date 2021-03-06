//
//  ConnectionRequestTableViewCell.swift
//  Connectivity
//
//  Created by Danial Zahid on 19/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ConnectionRequestTableViewCell: UITableViewCell {

    static let identifier = "connectionRequestTableViewCell"
    
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
    var userID : String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    

}
