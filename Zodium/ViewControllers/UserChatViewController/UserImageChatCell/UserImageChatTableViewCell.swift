//
//  UserImageChatTableViewCell.swift
//  Zodium
//
//  Created by tecH on 30/11/21.
//

import UIKit

class UserImageChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sendImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var btnImageSecViewHandler :(()->())?
    
    @IBAction func btnImageSecViewHandler(_ sender: Any) {
        btnImageSecViewHandler?()
    }
    
    
}
