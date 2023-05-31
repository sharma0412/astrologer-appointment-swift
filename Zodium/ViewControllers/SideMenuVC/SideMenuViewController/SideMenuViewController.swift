//
//  SideMenuViewController.swift
//  Zodium
//
//  Created by tecH on 14/10/21.
//

import UIKit
import IBAnimatable
import SDWebImage

class SideMenuViewController: UIViewController {

    var SideMenuList = ["My Profile","My Horoscopes","My Favourite","History","Notification","About","Settings","Logout"]
    
  //  var menuImage:[UIImage] = [#imageLiteral(resourceName: "Profile"),#imageLiteral(resourceName: "Profile"),#imageLiteral(resourceName: "my_heroscope"),#imageLiteral(resourceName: "heart"),#imageLiteral(resourceName: "bell"),#imageLiteral(resourceName: "about"),#imageLiteral(resourceName: "setting"),#imageLiteral(resourceName: "Profile")]
    var menuImage:[UIImage] = [#imageLiteral(resourceName: "Profile"),#imageLiteral(resourceName: "my_heroscope"),#imageLiteral(resourceName: "heart"),#imageLiteral(resourceName: "history"),#imageLiteral(resourceName: "bell"),#imageLiteral(resourceName: "about"),#imageLiteral(resourceName: "setting"),#imageLiteral(resourceName: "logout")]
    
    @IBOutlet weak var txtUserName: UILabel!
    @IBOutlet weak var txtUserEmail: UILabel!
    @IBOutlet weak var imgUserImage: AnimatableImageView!
    
    var model = LogInViewModelClass()
    
  //  var profileData: ProfileDataSave?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model.delegate = self

        txtUserName.text = nameProfileUser
        txtUserEmail.text = emailUser
        
        let url = URL(string:(imageBaseUrl + (imgProfileUser ?? "")))
        imgUserImage.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
        
        self.tableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func logOutAPI(){

        self.model.callLogOutApi(param: [:], onSucssesMsg:  CustomeAlertMsg.logOut)
        
    }


}
extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SideMenuList.count ?? 0
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        cell.selectionStyle = .none
 
        cell.lblItemName.text = SideMenuList[indexPath.row]
        cell.imgViewMenu.image = menuImage[indexPath.row]
        
            return cell
        }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 7{
            Alert.showAlertWithOkCancel(message: "Are you sure", actionOk: "YES", actionCancel: "NO") {
                
                self.logOutAPI()
                

            } completionCancel: {
                
            }
        }else if indexPath.row == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserHoroscopeVc") as! UserHoroscopeVc
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 6{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserSettingVc") as! UserSettingVc
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 3{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 4{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        else if indexPath.row == 2{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserFavAdvList") as! UserFavAdvList
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
           
}

extension SideMenuViewController: ResponseProtocol{
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
