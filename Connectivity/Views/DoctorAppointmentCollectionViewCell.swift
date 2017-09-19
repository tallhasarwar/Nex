//
//  DoctorAppointmentCollectionViewCell.swift
//  Quicklic
//
//  Created by Danial Zahid on 29/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class DoctorAppointmentCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "doctorAppointmentCollectionViewCell"
 
    @IBOutlet weak var statusView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let path = UIBezierPath(roundedRect:statusView.bounds,
                                byRoundingCorners:[.bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: 5, height:  5))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        statusView.layer.mask = maskLayer
    }

    
}
