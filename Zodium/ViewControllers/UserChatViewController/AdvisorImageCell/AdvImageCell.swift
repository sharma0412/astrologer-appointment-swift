//
//  AdvImageCell.swift
//  Zodium
//
//  Created by tecH on 30/11/21.
//

import UIKit
import IBAnimatable

class AdvImageCell: UITableViewCell {

    
    @IBOutlet weak var getImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var btnImageViewHandler :(()->())?
    
    @IBAction func btnImageViewHandler(_ sender: Any) {
        btnImageViewHandler?()
    }
    
}
