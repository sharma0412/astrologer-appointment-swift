//
//  AdvisorChatController.swift
//  Zodium
//
//  Created by tecH on 01/11/21.
//

import UIKit
import IBAnimatable
import JitsiMeetSDK

class AdvisorChatController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgProfilePhoto: AnimatableImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtMessage: UITextView!
    
    let date = Date()
    let calendar = Calendar.current
    
    var romId = ""
    var photo = ""
    var name = ""
    var advisorId = ""
    
    var randomChannel = ""
    
    var messageModalClass = [Message]()
    var makeCallResponse = [UserModel1]()
    
    var jitsiMeetView: JitsiMeetView?
    var pipViewCoordinator: PiPViewCoordinator?
    
    var UserId = UserDefaults.standard.string(forKey: "Uid")  ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(romId,photo,name)
        
        self.tableView.register(UINib(nibName: "advisorSideTableViewCell", bundle: nil), forCellReuseIdentifier: "advisorSideTableViewCell")
        
        self.tableView.register(UINib(nibName: "UserSideTableViewCell", bundle: nil), forCellReuseIdentifier: "UserSideTableViewCell")
        
        self.tableView.register(UINib(nibName: "UserChatCallCell", bundle: nil), forCellReuseIdentifier: "UserChatCallCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        hitSocket()
    }
    
    
    func scrollToBottom1(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messageModalClass.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    @IBAction func btnClickSendMessage(_ sender: Any) {
        validation()
    }
    
    func validation(){
        if txtMessage.text == ""{
            Alert.showSimple("message field is empty")
        }else{
            hitSendMessageSocket()
            txtMessage.text = ""
        }
    }
    
    
    //MARK:- Message List Socket
    
    func hitSocket(){
        
        
        SocketHelperss.shared.onSendMessage(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", room_id: romId,adviser_id: advisorId,message: txtMessage.text ?? "",type: "1") {(model) in
            
            if let mode = model{
                for item in mode{
                    self.messageModalClass.append(item)
                }
                
            }
            print("Done")
        
                      if self.messageModalClass.count == 0{
               
                      }else if self.messageModalClass.count == 1{
                          self.txtMessage.text = ""
                          self.scrollToBottom1()
                         // self.hitSocket()
                      }else{
                          
                          
                         
//                          self.lblAdvisorName.text = self.name
//                          let url = URL(string:(imageBaseUrl + (self.photo)))
//                          self.imgProfile.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
                      }
                    
            self.tableView.reloadData()
            self.scrollToBottom1()
                  }
        
        SocketHelperss.shared.emitMessageList(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", room_id: romId){
            print("Done")
        }
        
        SocketHelperss.shared.onMessageList(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", room_id: romId){(model) in
            self.messageModalClass = model ?? []
            
                      print("Done")
        
                      if self.messageModalClass.count == 0{
               
                      }else if self.messageModalClass.count == 1{
                 
                      }else{
                          
                          self.lblTitle.text = self.name
                          let url = URL(string:(imageBaseUrl + (self.photo)))
                          self.imgProfilePhoto.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
                          
                          self.scrollToBottom1()
                      }
                    
            self.tableView.reloadData()
                  }
        LoaderClass.shared.stopAnimation()

        }
    
    //MARK:- Send message API
    
    func hitSendMessageSocket(){
        SocketHelperss.shared.emitSendMessage(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", room_id: romId,adviser_id: advisorId,message: txtMessage.text ?? "",type: "1"){
            print("Done")
            
            self.tableView.reloadData()
        }
        

        LoaderClass.shared.stopAnimation()

        }
    
    
    @IBAction func btnClickBack(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdvHomePage") as! AdvHomePage
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnClickAudio(_ sender: Any) {
        
        Alert.showSimple("Under Development")
    }
    
    @IBAction func btnClickVideo(_ sender: Any) {
        
        self.makeCallFromJitsi()
        //hitSocketCallReq()
       // Alert.showSimple("Under Development")
    }
    
    
    //MARK:- call request
    
//    func hitSocketCallReq(){
//
//        let hour = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
//        let second = calendar.component(.second, from: date)
//
//        let curTime = "\(hour):\(minutes):\(second)"
//
//
//        SocketHelperss.shared.emitCallRequest(room_id: romId, receiver_id: advisorId, sender_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", type: "3", start_call: curTime){
//            print("Done")
//        }
//
//
//        SocketHelperss.shared.onCallRequest(room_id: romId, receiver_id: advisorId, sender_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", type: "3", start_call: curTime){(model) in
//
//            self.makeCallResponse = model ?? []
//                      print("Done")
//
//                      if self.makeCallResponse.count == 0{
//
//                      }else if self.makeCallResponse.count == 1{
//                          //self.tableView.reloadData()
//                       //   let viewStatus = self.messageModalClass[0].b_status ?? 0
//                      }
//                      LoaderClass.shared.stopAnimation()
//                  }
//        LoaderClass.shared.stopAnimation()
//
//        }
    
    
    
}
extension AdvisorChatController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageModalClass.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        if UserId == "\(messageModalClass[indexPath.row].user_id ?? 0)"{
            
            if messageModalClass[indexPath.row].type == 3{
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatCallCell", for: indexPath) as! UserChatCallCell
                cell.selectionStyle = .none
                cell.lblTitle.text = "Missed Audio call"
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserSideTableViewCell", for: indexPath) as! UserSideTableViewCell

                cell.txtMessage.text = messageModalClass[indexPath.row].message ?? ""
                cell.lblTimer.text = messageModalClass[indexPath.row].created_at?.convertUTCDateToLocal(format: "h:mm a")
                    cell.selectionStyle = .none
                    return cell
            }
            

            let cell = tableView.dequeueReusableCell(withIdentifier: "UserSideTableViewCell", for: indexPath) as! UserSideTableViewCell

            cell.txtMessage.text = messageModalClass[indexPath.row].message ?? ""
            cell.lblTimer.text = messageModalClass[indexPath.row].created_at?.convertUTCDateToLocal(format: "h:mm a")
                cell.selectionStyle = .none
                return cell

        }else{

            let cell = tableView.dequeueReusableCell(withIdentifier: "advisorSideTableViewCell", for: indexPath) as! advisorSideTableViewCell

            cell.lblMessage.text = messageModalClass[indexPath.row].message ?? ""
            cell.lblTime.text = messageModalClass[indexPath.row].created_at?.convertUTCDateToLocal(format: "h:mm a")
            cell.selectionStyle = .none
            return cell


        }
        
        
        
    }
}
