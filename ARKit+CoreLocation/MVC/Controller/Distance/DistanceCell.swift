//
//  DistanceCell.swift
//  ARKit+CoreLocation
//
//  Created by EMILENCE on 24/07/18.
//  Copyright © 2018 Project Dent. All rights reserved.
//

import UIKit

class DistanceCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var vwLine: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
