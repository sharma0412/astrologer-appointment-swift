//
//  ImageViewController.swift
//  Zodium
//
//  Created by tecH on 17/12/21.
//

import UIKit
import SDWebImage

class ImageViewController: UIViewController {

    var imageDta = ""
    var imgData2 = UIImage()
    
    @IBOutlet weak var imgCell: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if imageDta != ""{
            let url = URL(string: imageBaseUrl + imageDta)
            
            imgCell.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
        }else if imgData2 != nil{
            imgCell.image = imgData2
        }
        
        
    }
    
    @IBAction func btnClickCross(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
   
}
