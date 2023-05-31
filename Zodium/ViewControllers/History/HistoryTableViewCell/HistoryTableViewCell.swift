//
//  HistoryTableViewCell.swift
//  Zodium
//
//  Created by tecH on 30/11/21.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMail: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var userImageVIew: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
