//
//  UserSideTableViewCell.swift
//  Zodium
//
//  Created by tecH on 01/11/21.
//

import UIKit

class UserSideTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var txtMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
