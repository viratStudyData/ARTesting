//
//  DetailCell.swift
//  ARKit+CoreLocation
//
//  Created by EMILENCE on 23/07/18.
//  Copyright © 2018 Project Dent. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var imgVw: AsyncImageView!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
