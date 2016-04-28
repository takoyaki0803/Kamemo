//
//  CommentCell.swift
//  160111
//
//  Created by 20150301 on 2/11/16.
//  Copyright © 2016 YasuhiroSugisawa. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    //Outlet
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentStar: UILabel!
    @IBOutlet weak var commentPoint: UILabel!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var commentDate: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
