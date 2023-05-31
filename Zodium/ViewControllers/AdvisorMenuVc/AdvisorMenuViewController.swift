//
//  AdvisorMenuViewController.swift
//  Zodium
//
//  Created by tecH on 19/10/21.
//

import UIKit
import IBAnimatable

class AdvisorMenuViewController: UIViewController {

    var SideMenuList = ["My Profile","About","History","Edit My Services","Setings","Logout"]
    
    var menuImage:[UIImage] = [#imageLiteral(resourceName: "Profile"),#imageLiteral(resourceName: "about"),#imageLiteral(resourceName: "history"),#imageLiteral(resourceName: "setting"),#imageLiteral(resourceName: "setting"),#imageLiteral(resourceName: "logout")]
    @IBOutlet weak var lblAdvName: UILabel!
    @IBOutlet weak var imgAdv: AnimatableImageView!
    @IBOutlet weak var lblAdvMaikl: UILabel!
    
    var model = LogInViewModelClass()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model.delegate = self
        
        lblAdvName.text = advName
        lblAdvMaikl.text = advEmail
        
        let url = URL(string:(imageBaseUrl + (advImage)))
        imgAdv.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
        
        self.tableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func logOutAPI(){

        self.model.callLogOutApi(param: [:], onSucssesMsg:  CustomeAlertMsg.logOut)
        
    }
  

}
extension AdvisorMenuViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SideMenuList.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        cell.selectionStyle = .none
 
        cell.lblItemName.text = SideMenuList[indexPath.row]
        cell.imgViewMenu.image = menuImage[indexPath.row]
        
            return cell
        }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 5{
            Alert.showAlertWithOkCancel(message: "Are you sure", actionOk: "YES", actionCancel: "NO") {
             //   let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                
                self.logOutAPI()
                //    Cookies.deleteUserInfo()
                UserDefaults.standard.setValue("", forKey: UserDefaultKey.kUserToken)
           //     self.navigationController?.pushViewController(secondViewController, animated: true)
            } completionCancel: {
                
            }
        }else if indexPath.row == 4{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserSettingVc") as! UserSettingVc
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        else if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdvProfileVC") as! AdvProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 3{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddServicesViewController") as! AddServicesViewController
            vc.come = "Edit"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
           
}

extension AdvisorMenuViewController: ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        if  msg == CustomeAlertMsg.logOut {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
//                let encodedJson = try JSONDecoder().decode(CatagorySaveData.self, from: jsondata)
//                print(encodedJson)
      
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                
                Cookies.deleteUserInfo()
                UserDefaults.standard.setValue("", forKey: "role")
                UserDefaults.standard.setValue("", forKey: UserDefaultKey.kUserToken)
                
                self.navigationController?.pushViewController(secondViewController, animated: true)
                
            }catch {
            }
            
        }
        
    }
    
    func onFailure(msg: String) {
        print(msg)
        Alert.showSimple(msg)
    }
    
    
    
}
