//
//  NotificationVC.swift
//  Zodium
//
//  Created by DR.MAC on 08/12/21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell{
    
    @IBOutlet weak var notiTopLabel: UILabel!
    @IBOutlet weak var notiDownLabel: UILabel!
    @IBOutlet weak var notiImageView: UIImageView!
}

class NotificationVC: UIViewController {

    @IBOutlet weak var notitableView:UITableView!
    var model = MyProfileViewModelClass()
    var notiData : [NotificationModelClass]?
    @IBOutlet weak var noNotiFoundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model.delegate = self
        self.notitableView.delegate = self
        self.notitableView.dataSource = self
        self.model.notificationApi(onSucssesMsg: "Notification Fetch")
        // Do any additional setup after loading the view.
        
        noNotiFoundView.isHidden = true
    }
    
    @IBAction func backAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }


}
extension NotificationVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if notiData?.count == 0 {
            noNotiFoundView.isHidden = false
        }else{
            noNotiFoundView.isHidden = true
        }
        
        return notiData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.notiTopLabel.text = self.notiData?[indexPath.row].msg ?? ""
        cell.notiDownLabel.text = self.notiData?[indexPath.row].created_at?.convertUTCDateToLocal(format: "YYYY-mm-dd MM:ss")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Swift 4.2 onwards
        return UITableView.automaticDimension

    }
}

extension NotificationVC:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        if  msg == "Notification Fetch" {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response["body"] ?? [], options: .prettyPrinted)
                let encodedJson = try JSONDecoder().decode(notificationModelClass.self, from: jsondata)
                self.notiData = encodedJson
                self.notitableView.reloadData()
        
                
                
    
                
            }catch {
            }
            
        }
            
            
            
        }
 
    
    func onFailure(msg: String) {
        print(msg)
        Alert.showSimple(msg)
    }
    
    
}
