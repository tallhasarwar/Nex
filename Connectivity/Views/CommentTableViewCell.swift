//
//  CommentTableViewCell.swift
//  Connectivity
//
//  Created by Danial Zahid on 6/7/18.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    static let identifier = "commentTableViewCell"
    
    
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
