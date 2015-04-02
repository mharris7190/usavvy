//
//  PostingTableViewCell.swift
//  USavvy
//
//  Created by Max Harris on 11/23/14.
//  Copyright (c) 2014 Max Harris. All rights reserved.
//

import UIKit

class PostingTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var spotsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startEndTimeLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 38
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    

}
