//
//  CustomTableViewCell.swift
//  SchoolApp
//
//  Created by Angelo Dizon on 9/15/15.
//  Copyright (c) 2015 Theoretics Inc. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var leftIcon: UIImageView!
    
    @IBOutlet weak var mainTitle: UILabel!
    
    @IBOutlet weak var rightIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
