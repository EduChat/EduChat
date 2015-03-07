//
//  PostTableViewCell.swift
//  EduChat
//
//  Created by loaner on 3/7/15.
//  Copyright (c) 2015 Martin Developments. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var contentBox: UITextView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
