//
//  PostedTableViewCell.swift
//  Instagram
//
//  Created by Sanzida Sultana on 10/22/20.
//

import UIKit

class PostedTableViewCell: UITableViewCell {

    @IBOutlet weak var postedImage: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var caption: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
