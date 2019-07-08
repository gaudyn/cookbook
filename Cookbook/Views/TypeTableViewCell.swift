//
//  TypeTableViewCell.swift
//  Cookbook
//
//  Created by Gniewomir Gaudyn on 09/06/2019.
//  Copyright © 2019 Gniewomir Gaudyn. All rights reserved.
//

import UIKit

class TypeTableViewCell: UITableViewCell {

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
