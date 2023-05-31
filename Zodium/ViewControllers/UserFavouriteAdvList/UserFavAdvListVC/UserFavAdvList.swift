//
//  UserFavAdvList.swift
//  Zodium
//
//  Created by tecH on 27/10/21.
//

import UIKit

class UserFavAdvList: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var model = UserFavAdvListViewModelClass()
    
    var FavAdvList: [UserFavAdvBody]?
    
    var messageModalClass = [UserModel]()
    @IBOutlet weak var noDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noDataView.isHidden = true
        
        self.model.delegate = self
        
        tableView.register(UINib(nibName: "UserFavAdvTableViewCell", bundle: nil), forCellReuseIdentifier: "UserFavAdvTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
       // favAdvListAPI()
        SocketHelperss.shared.establishConnection()
        hitSocket()
    }
    
    func hitSocket(){
        LoaderClass.shared.startAnimating()
        SocketHelperss.shared.emitAdvFavList(user_id: "\(UserDefaults.standard.string(forKey: "Uid") )"){
            print("DONE")
        }
        SocketHelperss.shared.onAdvFavList(user_id: "\(UserDefaults.standard.string(forKey: "Uid") )"){ (model) in
            self.messageModalClass = model ?? []
            print("Done")
            self.tableView.reloadData()
            if self.messageModalClass.count == 0{
            
            }else if self.messageModalClass.count == 1{
               
                self.tableView.reloadData()
            }
            LoaderClass.shared.stopAnimation()
        }
            
        }
    
    func favAdvListAPI(){
       
        self.model.userFavAdvListApi(onSucssesMsg:  CustomeAlertMsg.favAdvList)
        
    }

    @IBAction func btnClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension UserFavAdvList: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if messageModalClass.count == 0{
            noDataView.isHidden = false
        }else{
            noDataView.isHidden = true
        }
        
        return messageModalClass.count ?? 0
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserFavAdvTableViewCell") as! UserFavAdvTableViewCell
        
       // cell.lblAdvName.text = FavAdvList?[indexPath.row].user?.name ?? ""
        cell.lblAdvName.text = self.messageModalClass[indexPath.row].name ?? ""
     
//        let url = URL(string:(imageBaseUrl + (FavAdvList?[indexPath.row].user?.profile_image ?? "")))
//        cell.imgAdvisor.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
        
        let url = URL(string:(imageBaseUrl + (self.messageModalClass[indexPath.row].profile_image ?? "" )))
        cell.imgAdvisor.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
        
        
        
        if self.messageModalClass[indexPath.row].isOnline == 1 {
        
            cell.btnOnOff.image = UIImage(named:"online")
        }else{
           
               cell.btnOnOff.image = UIImage(named:"Offline")
        }
        
        
        cell.btnBookmarks.addTarget(self, action: #selector(bookmarkAction(_:)), for: .touchUpInside)
        cell.btnBookmarks.tag = indexPath.row
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    @objc func bookmarkAction(_ sender: UIButton){
        
         print(sender.tag)
        
        let otheruser = [Param.adviser_id: "\(self.messageModalClass[sender.tag].id ?? 0)",Param.cat_id: "\(self.messageModalClass[sender.tag].cat_id ?? 0)",Param.is_fav: "2"] as [String : Any]
        
        self.model.callFavUnfavApi(param: otheruser, onSucssesMsg:  CustomeAlertMsg.favUn)
        
    }
    
    
}
extension UserFavAdvList:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        if  msg == CustomeAlertMsg.favAdvList {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let encodedJson = try JSONDecoder().decode(UserFavAdvModel.self, from: jsondata)
                print(encodedJson)

                self.FavAdvList = encodedJson.body
                
                tableView.reloadData()
//                let url = URL(string:(imageBaseUrl + (encodedJson.profile_image ?? "")))
//                imgProfile.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "Profile"))
         
            }catch {
            }
            
           }else  if  msg == CustomeAlertMsg.favUn {
               do {
                   let jsondata = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
              //     let encodedJson = try JSONDecoder().decode(horoDataSave.self, from: jsondata)
               //    print(encodedJson)
                   hitSocket()
                   
               }catch {
               }
               
           }
        }
 
    
    func onFailure(msg: String) {
        print(msg)
        Alert.showSimple(msg)
    }
    
    
}
