//
//  UserAdvisorTableViewCell.swift
//  Zodium
//
//  Created by tecH on 20/10/21.
//

import UIKit
import IBAnimatable

class UserAdvisorTableViewCell: UITableViewCell {

    @IBOutlet weak var imgOnOff: AnimatableImageView!
    
    @IBOutlet weak var btnFavUnFav: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnChatAudio: UIButton!
    @IBOutlet weak var btnChatVideo: UIButton!
    
    @IBOutlet weak var lblChatPerMinute: UILabel!
    @IBOutlet weak var lblChatAudioPerMinute: UILabel!
    @IBOutlet weak var lblChatVideoPerMinute: UILabel!
    
    @IBOutlet weak var AdvImage: AnimatableImageView!
    @IBOutlet weak var lblAdvName: UILabel!
    @IBOutlet weak var lblStarCount: UILabel!
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var lblDescr: UILabel!
    @IBOutlet weak var lblAvailableTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
