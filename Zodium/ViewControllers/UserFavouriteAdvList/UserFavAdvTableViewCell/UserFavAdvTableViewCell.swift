//
//  UserFavAdvTableViewCell.swift
//  Zodium
//
//  Created by tecH on 27/10/21.
//

import UIKit
import IBAnimatable

class UserFavAdvTableViewCell: UITableViewCell {

    @IBOutlet weak var btnOnOff: UIImageView!
    @IBOutlet weak var btnBookmarks: UIButton!
    @IBOutlet weak var imgAdvisor: AnimatableImageView!
    @IBOutlet weak var lblAdvName: UILabel!
    @IBOutlet weak var lblStarRating: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
