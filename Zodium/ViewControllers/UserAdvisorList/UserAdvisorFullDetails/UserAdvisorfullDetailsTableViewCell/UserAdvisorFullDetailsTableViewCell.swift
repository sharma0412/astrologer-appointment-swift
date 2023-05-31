//
//  UserAdvisorFullDetailsTableViewCell.swift
//  Zodium
//
//  Created by tecH on 20/10/21.
//

import UIKit

class UserAdvisorFullDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblUserDesc: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
