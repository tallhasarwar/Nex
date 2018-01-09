//
//  SuggestionTable.swift
//  Connectivity
//
//  Created by Danial Zahid on 09/01/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class SuggestionTable: DesignableView {

    @IBOutlet weak var tableView: UITableView!
    
    let values = [""]
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(SuggestionTableViewCell.self, forCellReuseIdentifier: SuggestionTableViewCell.identifier)
    }

}
