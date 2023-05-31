//
//  HomeTableViewCell.swift
//  Zodium
//
//  Created by tecH on 13/10/21.
//

import UIKit
import IBAnimatable

class UserHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var btnSeeMore: UIButton!
    @IBOutlet weak var catImage: AnimatableImageView!
    @IBOutlet weak var lblCatDisc: UILabel!
    @IBOutlet weak var lblCatName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
