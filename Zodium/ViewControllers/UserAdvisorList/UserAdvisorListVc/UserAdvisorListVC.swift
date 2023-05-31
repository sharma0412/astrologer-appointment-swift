//
//  UserAdvisorListVC.swift
//  Zodium
//
//  Created by tecH on 20/10/21.
//

import UIKit
import SocketIO
import SDWebImage

class UserAdvisorListVC: UIViewController {
    
    var favDigit = ""
    
    var messageModalClass = [UserModel]()
    var model = UserAdvisorListPopUpViewModelClass()

    var topName = ""
    var catagoryId = Int()
    
    var chatP = ""
    var chatAudioP = ""
    var chatVideoP = ""
    
    var advId = Int()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblTopHeading: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        print(catagoryId)
        self.model.delegate = self
//        lblTopHeading.text = topName
//
//        self.tableView.register(UINib(nibName: "UserAdvisorTableViewCell", bundle: nil), forCellReuseIdentifier: "UserAdvisorTableViewCell")
//        tableView.delegate = self
//        tableView.dataSource = self
//        SocketHelperss.shared.establishConnection()
//        self.hitSocket()

          }
    
    
    override func viewWillAppear(_ animated: Bool) {
        lblTopHeading.text = topName
        
        self.tableView.register(UINib(nibName: "UserAdvisorTableViewCell", bundle: nil), forCellReuseIdentifier: "UserAdvisorTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        SocketHelperss.shared.establishConnection()
        self.hitSocket()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        self.hitSocket()
//
//    }
    
//    func favUnfavAPI(){
//
//        let otheruser = [Param.cat_id: ] as [String : Any]
//
//        self.model.callFavUnfavApi(param: otheruser, onSucssesMsg:  CustomeAlertMsg.favUn)
//
//    }
    
   
    
    func hitSocket(){
        LoaderClass.shared.startAnimating()
        SocketHelperss.shared.emitChatList(cat_id: "\(catagoryId ?? 0)") {
            print("Done")
        }
        SocketHelperss.shared.onChatList(cat_id: "\(catagoryId ?? 0)"){ (model) in
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
    
    @IBAction func btnClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
   
}
extension UserAdvisorListVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageModalClass.count ?? 0
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserAdvisorTableViewCell", for: indexPath) as! UserAdvisorTableViewCell
        cell.selectionStyle = .none
        cell.lblAdvName.text = self.messageModalClass[indexPath.row].name
        
        cell.lblChatPerMinute.text = "£\(self.messageModalClass[indexPath.row].chat_price ?? 0.0)/minute"
        cell.lblChatAudioPerMinute.text = "£\(self.messageModalClass[indexPath.row].chat_audio_price ?? 0.0)/minute"
        cell.lblChatVideoPerMinute.text = "£\(self.messageModalClass[indexPath.row].chat_video_price ?? 0.0)/minute"
     
   
     //   self.chatAudioP = "£\(self.messageModalClass[indexPath.row].chat_audio_price ?? 0)/min"
     //   self.chatVideoP = "£\(self.messageModalClass[indexPath.row].chat_video_price ?? 0)/min"
        
        let url = URL(string:(imageBaseUrl + (self.messageModalClass[indexPath.row].profile_image ?? "")))
        cell.AdvImage.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
        
        let onOff = self.messageModalClass[indexPath.row].isOnline
        
        print(onOff)
        
        if onOff == 1 {
           
            cell.imgOnOff.image = UIImage(named:"online")
            
        }else if onOff == 0 {
            
            cell.imgOnOff.image = UIImage(named:"Offline")
        }
        
        if messageModalClass[indexPath.row].is_fav == "1" {
            let image = UIImage(named: "bookmark")
               cell.btnFavUnFav.setImage(image, for: .normal)
        }else{
            let image = UIImage(named: "5454571_bookmark_line_media_network_outline_icon")
               cell.btnFavUnFav.setImage(image, for: .normal)
        }
        
        
        
        cell.btnChat.addTarget(self, action: #selector(chatBtnAction(_:)), for: .touchUpInside)
        cell.btnChat.tag = indexPath.row
        
        cell.btnChatAudio.addTarget(self, action: #selector(chatAudioAction(_:)), for: .touchUpInside)
        cell.btnChatAudio.tag = indexPath.row
        
        cell.btnChatVideo.addTarget(self, action: #selector(chatVideoAction(_:)), for: .touchUpInside)
        cell.btnChatVideo.tag = indexPath.row
        
        
        cell.btnFavUnFav.addTarget(self, action: #selector(favUnfavAction(_:)), for: .touchUpInside)
        cell.btnFavUnFav.tag = indexPath.row
        
            return cell
        }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("you cliked on tableview cell")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserAdvisorFullDetails") as! UserAdvisorFullDetails
        vc.topLine = topName
        vc.advName = self.messageModalClass[indexPath.row].name ?? ""
        vc.onlineOff = self.messageModalClass[indexPath.row].isOnline ?? 0
        vc.advImage = self.messageModalClass[indexPath.row].profile_image ?? ""
      //  vc.advDesc = self.messageModalClass[indexPath.row].description
        
        
            self.navigationController?.pushViewController(vc, animated: true)
    }

       
    @objc func favUnfavAction(_ sender: UIButton){
         print(sender.tag)
        
        
        if messageModalClass[sender.tag].is_fav == "0" || messageModalClass[sender.tag].is_fav == "" {
            self.favDigit = "1"
        }else{
            self.favDigit = "2"
        }
        
        let otheruser = [Param.adviser_id: "\(messageModalClass[sender.tag].id ?? 0)",Param.cat_id: "\(messageModalClass[sender.tag].cat_id ?? 0)",Param.is_fav: favDigit] as [String : Any]
        
        self.model.callFavUnfavApi(param: otheruser, onSucssesMsg:  CustomeAlertMsg.favUn)
      
    }
    
    
    
    
    @objc func chatBtnAction(_ sender: UIButton){
        
         print(sender.tag)
        
        self.advId = self.messageModalClass[sender.tag].id ?? 0
        print(advId)
        
        if self.messageModalClass[sender.tag].isOnline == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserAdvisorListPopUp") as! UserAdvisorListPopUp
            vc.myHeading = "Set chat duration"
            vc.advPrice = self.messageModalClass[sender.tag].chat_price ?? 0.0
            vc.advisorsId = advId
            vc.delegate1 = self
            vc.chatType = "1"
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: true, completion: nil)
        }else{
            
            Alert.showSimple("User is Offline")
            
        }
       
      
    }
    
    @objc func chatAudioAction(_ sender: UIButton){
        
         print(sender.tag)
        
        self.advId = self.messageModalClass[sender.tag].id ?? 0
        
        if self.messageModalClass[sender.tag].isOnline == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserAdvisorListPopUp") as! UserAdvisorListPopUp
            vc.myHeading = "Set chat duration"
            vc.advPrice = (self.messageModalClass[sender.tag].chat_price ?? 0)
            vc.advisorsId = advId
            vc.delegate1 = self
            vc.chatType = "2"
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: true, completion: nil)
        }else{
            
            Alert.showSimple("User is Offline")
            
        }
     
    }
    
    @objc func chatVideoAction(_ sender: UIButton){
        
         print(sender.tag)
        
        self.advId = self.messageModalClass[sender.tag].id ?? 0
        
        if self.messageModalClass[sender.tag].isOnline == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserAdvisorListPopUp") as! UserAdvisorListPopUp
            vc.myHeading = "Set chat duration"
            vc.advPrice = (self.messageModalClass[sender.tag].chat_price ?? 0)
            vc.advisorsId = advId
            vc.delegate1 = self
            vc.chatType = "3"
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: true, completion: nil)
        }else{
            
            Alert.showSimple("User is Offline")
            
        }
     
    }
    
}
extension UserAdvisorListVC: NextPage{
    func first() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserHomeVC") as! UserHomeVC
//        vc.param = otherParam
        self.navigationController?.pushViewController(vc, animated: true)
    }
       
 
    
}
extension UserAdvisorListVC:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        if  msg == CustomeAlertMsg.favUn {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
           //     let encodedJson = try JSONDecoder().decode(horoDataSave.self, from: jsondata)
            //    print(encodedJson)
                self.hitSocket()
                
            }catch {
            }
            
        }
        
    }
    
    func onFailure(msg: String) {
        print(msg)
        Alert.showSimple(msg)
    }
    
    
    
}
