//
//  EventsListTableViewCell.swift
//  Connectivity
//
//  Created by Danial Zahid on 02/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class EventsListTableViewCell: UITableViewCell {

    static let identifier = "eventsListTableViewCell"
    
    @IBOutlet weak var eventImageView: DesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var radiusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
