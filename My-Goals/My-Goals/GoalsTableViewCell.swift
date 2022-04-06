//
//  GoalsTableViewCell.swift
//  My-Goals
//
//  Created by Caner Çağrı on 5.04.2022.
//

import UIKit

class GoalsTableViewCell: UITableViewCell {

    @IBOutlet var cellimageview: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellimageview.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
