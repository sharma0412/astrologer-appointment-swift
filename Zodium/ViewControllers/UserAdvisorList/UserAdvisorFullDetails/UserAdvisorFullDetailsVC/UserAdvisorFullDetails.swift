//
//  UserAdvisorFullDetails.swift
//  Zodium
//
//  Created by tecH on 20/10/21.
//

import UIKit
import IBAnimatable

class UserAdvisorFullDetails: UIViewController {

    var topLine = ""
    var advName = ""
    var advDesc = ""
    var onlineOff = Int()
    var advImage = ""
    
    
    @IBOutlet weak var lblTopHeading: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblDescription: UILabel!
   
    @IBOutlet weak var imgAdvisor: AnimatableImageView!
    @IBOutlet weak var lblAdvisorName: UILabel!
    @IBOutlet weak var lblStarRating: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTopHeading.text = topLine
        lblAdvisorName.text = advName
        lblDescription.text = advDesc
        
        let url = URL(string:(imageBaseUrl + (advImage)))
        imgAdvisor.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
        
        
        self.tableView.register(UINib(nibName: "UserAdvisorFullDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "UserAdvisorFullDetailsTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func btnClickChat(_ sender: Any) {
    }
    
    @IBAction func btnClickChatAudio(_ sender: Any) {
    }
    @IBAction func btnClickChatVideo(_ sender: Any) {
    }
    @IBAction func btnClickSeeAll(_ sender: Any) {
    }
    @IBAction func btnClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension UserAdvisorFullDetails: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserAdvisorFullDetailsTableViewCell", for: indexPath) as! UserAdvisorFullDetailsTableViewCell
        cell.selectionStyle = .none
 
     //   cell.lblItemName.text = SideMenuList[indexPath.row]
        
            return cell
        }
      
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        
        
    }

}
