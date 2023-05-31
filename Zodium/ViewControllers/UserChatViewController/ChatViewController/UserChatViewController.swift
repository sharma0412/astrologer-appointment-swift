//
//  UserChatViewController.swift
//  Zodium
//
//  Created by tecH on 01/11/21.
//

import UIKit
import IBAnimatable
import JitsiMeetSDK
import IQKeyboardManager

class UserChatViewController: UIViewController {
    
    var imgSelect = UIImage()

    @IBOutlet weak var constHeightBottomView: NSLayoutConstraint!
    @IBOutlet weak var txtMesaage: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblStarRating: UILabel!
    @IBOutlet weak var lblAdvisorName: UILabel!
    @IBOutlet weak var imgProfile: AnimatableImageView!
    @IBOutlet weak var uploadImageButton: UIPhotosButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    var selectedOne = ""
    @IBOutlet weak var SendImgPreview: UIImageView!
    @IBOutlet weak var SendImageView: UIView!
    
    private var timer: Timer?
    private var timeCounter: Double = 0
    var model = SendImageViewModel()
    var callType = ""
    var romId = ""
    var photo = ""
    var name = ""
    var advisorId = ""
    var callTypeStatus = ""
    var randomChannel = ""
    var jitsiMeetView: JitsiMeetView?
    var pipViewCoordinator: PiPViewCoordinator?
    var videoStatus = false
    var modelData : BookingModal?
    var senderID = 0
    var reciverID = 0
    let date = Date()
    let calendar = Calendar.current
    var imageFile = UIImage()
    var bookingType = ""
    var UserId = UserDefaults.standard.string(forKey: "Uid")  ?? ""
    
    var messageModalClass = [Message]()
    
    var makeCallResponse = [UserModel1]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SendImageView.isHidden = true
        
        self.lblAdvisorName.text = self.name
        if self.photo == "" {
            self.imgProfile.image = UIImage(named: "placeholder")
        }else{
            let url = URL(string: imageBaseUrl + self.photo)
            self.imgProfile.sd_setImage(with: url)
        }
        if bookingType == "1"{
            self.callButton.isHidden = true
            self.videoButton.isHidden = true

        }else if bookingType == "2"{
            self.callButton.isHidden = false
            self.videoButton.isHidden = true
        }else if bookingType == "3"{
            self.callButton.isHidden = false
            self.videoButton.isHidden = false
        }
        
        uploadImageButton.closureDidFinishPickingAnUIImage = { (image) in
            if let uploadImage = image {
                self.imageFile = uploadImage
                
                self.imgSelect = uploadImage
                
                self.SendImageView.isHidden = false
                self.SendImgPreview.image = uploadImage
                

            }
        }
        SocketHelperss.shared.establishConnection()
        
        self.tableView.register(UINib(nibName: "AdvImageCell", bundle: nil), forCellReuseIdentifier: "AdvImageCell")
        self.tableView.register(UINib(nibName: "advisorSideTableViewCell", bundle: nil), forCellReuseIdentifier: "advisorSideTableViewCell")
        self.tableView.register(UINib(nibName: "UserImageChatTableViewCell", bundle: nil), forCellReuseIdentifier: "UserImageChatTableViewCell")
        self.tableView.register(UINib(nibName: "UserSideTableViewCell", bundle: nil), forCellReuseIdentifier: "UserSideTableViewCell")
        self.tableView.register(UINib(nibName: "UserChatCallCell", bundle: nil), forCellReuseIdentifier: "UserChatCallCell")
     
        tableView.delegate = self
        tableView.dataSource = self
        
        print(romId)
        self.model.delegate = self
        hitSocket()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UserChatViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(UserChatViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //self.scrollToBottom1()
        
    }
//    override func viewWillAppear(_ animated: Bool) {
//        hitSocket()
//    }
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
//            IQKeyboardManager.shared().isEnabled = false
//            IQKeyboardManager.shared().isEnableAutoToolbar = false
            
        }
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            
//            if IQKeyboardManager.shared().isEnabled == false {
//                IQKeyboardManager.shared().isEnabled = true
//                IQKeyboardManager.shared().isEnableAutoToolbar = true
//            }
        }
        @objc func keyboardWillShow(notification: Notification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let height = keyboardSize.height
                constHeightBottomView.constant = height - 10
                self.view.layoutIfNeeded()
            }
        }
        @objc func keyboardWillHide(notification: Notification) {
            constHeightBottomView.constant = 20
            self.view.layoutIfNeeded()
//            constHeightBottomView.constant = 20
//                    self.view.endEditing(true)
//                    self.view.layoutIfNeeded()
        }
    
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    @objc func onComplete() {
        guard timeCounter >= 0 else {
//            countDown.text = "Time ended."
            timer?.invalidate()
            timer = nil
            return
        }
        
        let hours = Int(timeCounter) / 3600
        let minutes = Int(timeCounter) / 60 % 60
        let seconds = Int(timeCounter) % 60
        
//        countDown.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        
        timeCounter -= 1
        // print("\(timeCounter)")
    }
    
    var expiryTimeInterval: TimeInterval? {
        didSet {
            
            if timer == nil
            {
                startTimer()
                RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
            }
            
        }
    }
    private func startTimer() {
        if let interval = expiryTimeInterval {
            timeCounter = interval
            if #available(iOS 10.0, *) {
                timer = Timer(timeInterval: 1.0,
                              repeats: true,
                              block: { [weak self] _ in
                                guard let strongSelf = self else {
                                    return
                                }
                                strongSelf.onComplete()
                              })
            } else {
                timer = Timer(timeInterval: 1.0,
                              target: self,
                              selector: #selector(onComplete),
                              userInfo: nil,
                              repeats: true)
            }
        }
    }
    
    func scrollToBottom1(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messageModalClass.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
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
    
    func hitSocket(){
        SocketHelperss.shared.onSendMessage(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", room_id: romId,adviser_id: advisorId,message: txtMesaage.text ?? "",type: "1"){(model) in
            
            if let mode = model{
                for item in mode{
                self.messageModalClass.append(item)
                }
                
            }
                      print("Done")
        
                      if self.messageModalClass.count == 0{
                      }else if self.messageModalClass.count == 1{
                          self.txtMesaage.text = ""
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
            if let mode = model{
                for item in mode{
                    self.messageModalClass.append(item)
                }
                
            }
//            self.messageModalClass = model ?? []
                      print("Done")
        
                      if self.messageModalClass.count == 0{
               
                      }else if self.messageModalClass.count == 1{
                 
                      }else{
                          
                          self.lblAdvisorName.text = self.name
                          let url = URL(string:(imageBaseUrl + (self.photo)))
                          self.imgProfile.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
                          
                          self.scrollToBottom1()
                      }
                    
            self.tableView.reloadData()
                  }
        LoaderClass.shared.stopAnimation()

        }
    

    
    func hitSendMessageSocket(){
        SocketHelperss.shared.emitSendMessage(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", room_id: romId,adviser_id: advisorId,message: txtMesaage.text ?? "",type: "1"){
            print("Done")
        }
        

//        LoaderClass.shared.stopAnimation()

        }
    
    
    
    @IBAction func btnClickCall(_ sender: Any){
        callTypeStatus = "3"
        videoStatus = false
        self.makeCallFromJitsi()
        self.callSocket()
    }
    
    @IBAction func btnClickVideoCall(_ sender: Any) {
        callTypeStatus = "4"
        videoStatus = true
        self.makeCallFromJitsi()
        self.callSocket()
//        self.makeCallFromJitsi()
//        hitSocketCallReq()
//        print("Video Call")
       
    }
    
    
    
    func callSocket(){
        let  role = UserDefaults.standard.value(forKey: "role") as? Int ?? 0
     
        if callTypeStatus == "3"{
            callType = "3"
        }
        else{
            callType = "4"
        }
//        senderID = Int(UserDefaults.standard.string(forKey: "Uid")  ?? "") ?? 0
//        reciverID = Int(advisorId ?? "") ?? 0
//        if role == 1{
//            senderID = messageModalClass.first?.senderId ?? 0
//            reciverID = messageModalClass.first?.receiver_id ?? 0
//        }else if role == 2{
//            reciverID = messageModalClass.first?.receiver_id ?? 0
//            senderID = messageModalClass.first?.senderId ?? 0
//        }
        
        SocketHelperss.shared.getCall(receiver_id: advisorId) { (response) in
            if let data = response as? [[String:Any]]{
                print("calling api is here \(data)")
                if let status = data[0]["success"] as? Int{
                    if status == 200{
                        if let body = data[0]["body"] as? Int{
                            SocketHelperss.shared.getCallAcceptReject(call_id: body) { (response) in
                                print(response)
                                if response.count > 0 {
                                    if let data = response as? [[String:Any]]{
                                        print("calling api is here \(data)")
                                        if let status = data[0]["success"] as? Int{
                                            if status == 200{
                                                if let body = data[0]["body"] as? String{
                                                    if body == "2" || body == "3"{
                                                        self.jitsiMeetView?.leave()
                                                        self.pipViewCoordinator?.hide()
                                                        Callkit.sharedInstance.dismissCallkitUIOnEndCall()
                                                    }
                                                }
                                            }else{
                                                self.jitsiMeetView?.leave()
                                                self.pipViewCoordinator?.hide()
                                                Callkit.sharedInstance.dismissCallkitUIOnEndCall()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        SocketHelperss.shared.emitCall(room_id: romId, receiver_id: advisorId, sender_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", type: callType, start_call: "1:40"){
            print("Call  Emit Done")
        }
    }
    
    
    
    
    
    
    
    @IBAction func btnClickStopSession(_ sender: Any) {
        print("Stop Session")
    }
    @IBAction func btnClickBack(_ sender: Any) {
        print("Back")
        
        navigationController?.popViewController(animated: true)

    }
    @IBAction func btnClickAddPhotoVideo(_ sender: Any) {
        print("Add Photo Video")
    }
    @IBAction func btnClickSendMessage(_ sender: Any) {
        print("Send Message")
        
        
        validation()
    }
    
    func validation(){
        if txtMesaage.text == ""{
            Alert.showSimple("message field is empty")
        }else{
            hitSendMessageSocket()
            txtMesaage.text = ""
        }
    }
    
    @IBAction func btnClickCross(_ sender: Any) {
        
        SendImageView.isHidden = true
        
    }
    @IBAction func btnClickSend(_ sender: Any) {
        
                        var param = [String:Any]()
                        param["adviser_id"] = self.advisorId
                        param["room_id"] = self.romId
                        param["type"] = "2"
        
                        self.model.apiImageUplaod(parameters: param, image: imgSelect)
        
        SendImageView.isHidden = true
    }
    
    
    @IBAction func btnClickPreview(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController

        vc.imgData2 = imgSelect
        self.present(vc, animated: true, completion: nil)
        
    }
    
}

extension UserChatViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageModalClass.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        if UserId == "\(messageModalClass[indexPath.row].user_id ?? 0)"{
            
            if messageModalClass[indexPath.row].type == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserSideTableViewCell", for: indexPath) as! UserSideTableViewCell
                
                cell.txtMessage.text = messageModalClass[indexPath.row].message ?? ""
                cell.lblTimer.text = messageModalClass[indexPath.row].created_at?.convertUTCDateToLocal(format: "h:mm a")
                    cell.selectionStyle = .none
                    return cell
            }else if messageModalClass[indexPath.row].type == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserImageChatTableViewCell", for: indexPath) as! UserImageChatTableViewCell
                
                cell.btnImageSecViewHandler = {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController

                    vc.imageDta = self.messageModalClass[indexPath.row].message ?? ""
                    self.present(vc, animated: true, completion: nil)
                }
                
                let profileImage = messageModalClass[indexPath.row].message ?? ""
                if profileImage == "" {
                    cell.sendImageView.image = UIImage(named: "placeholder")
                }else{
                    let url = URL(string: imageBaseUrl + profileImage)
                    cell.sendImageView.sd_setImage(with: url)
                }
//                cell.sendImageView.image =
                    cell.selectionStyle = .none
                    return cell
            }else if messageModalClass[indexPath.row].type == 3{
                if messageModalClass[indexPath.row].call_type == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatCallCell", for: indexPath) as! UserChatCallCell
                    cell.selectionStyle = .none
                    cell.lblTitle.text = "Missed Audio call"
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatCallCell", for: indexPath) as! UserChatCallCell
                    cell.selectionStyle = .none
                    cell.lblTitle.text = "Audio call at"
                    return cell
                }
                
            }else if messageModalClass[indexPath.row].type == 4{
                if messageModalClass[indexPath.row].call_type == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatCallCell", for: indexPath) as! UserChatCallCell
                    cell.selectionStyle = .none
                    cell.lblTitle.text = "Missed Audio call"
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatCallCell", for: indexPath) as! UserChatCallCell
                    cell.selectionStyle = .none
                    cell.lblTitle.text = "Audio call at"
                    return cell
                }
            }
  
        }else{
            
            if messageModalClass[indexPath.row].type == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "advisorSideTableViewCell", for: indexPath) as! advisorSideTableViewCell
                           
                cell.lblMessage.text = messageModalClass[indexPath.row].message ?? ""
                cell.lblTime.text = messageModalClass[indexPath.row].created_at?.convertUTCDateToLocal(format: "h:mm a")
                cell.selectionStyle = .none
                return cell
            }else if messageModalClass[indexPath.row].type == 2{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "AdvImageCell", for: indexPath) as! AdvImageCell
                
                cell.btnImageViewHandler = {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController

                    vc.imageDta = self.messageModalClass[indexPath.row].message ?? ""
                    self.present(vc, animated: true, completion: nil)
                }
                
                let profileImage = messageModalClass[indexPath.row].message ?? ""
                if profileImage == "" {
                    cell.getImageView.image = UIImage(named: "placeholder")
                }else{
                    let url = URL(string: imageBaseUrl + profileImage)
                    cell.getImageView.sd_setImage(with: url)
                }
//                cell.sendImageView.image =
                    cell.selectionStyle = .none
                    return cell
            }else if messageModalClass[indexPath.row].type == 3{
                if messageModalClass[indexPath.row].call_type == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatCallCell", for: indexPath) as! UserChatCallCell
                    cell.selectionStyle = .none
                    cell.lblTitle.text = "Missed Audio call"
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatCallCell", for: indexPath) as! UserChatCallCell
                    cell.selectionStyle = .none
                    cell.lblTitle.text = "Audio call at"
                    return cell
                }
                
            }else if messageModalClass[indexPath.row].type == 4{
                if messageModalClass[indexPath.row].call_type == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatCallCell", for: indexPath) as! UserChatCallCell
                    cell.selectionStyle = .none
                    cell.lblTitle.text = "Missed Video call"
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatCallCell", for: indexPath) as! UserChatCallCell
                    cell.selectionStyle = .none
                    cell.lblTitle.text = "Video call at"
                    return cell
                }
            }
  
        }
        return UITableViewCell()

    }
  
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if messageModalClass[indexPath.row].type == 2{
//        return 80
//        }else{
//            return UITableView.automaticDimension
//        }
//
//    }
}
class SendImageViewModel{
    
    var delegate : ResponseProtocol?

    func apiImageUplaod(parameters:[String:Any],image: UIImage){
        LoaderClass.shared.loadAnimation()
            APIClient.postMultiPartAuth2(url: .sendImage, jsonObject: parameters
                                         , profilePic: (key: "file",type: image), authorizationToken: true, refreshToken: false) { (response) in
                
                            if isSuccess(json: response) {
                                self.delegate?.onSucsses(msg:"Image Sent", response: response)
                            }else{
                                if let message = response["message"] as? String{
                                    self.delegate?.onFailure(msg: message)
                                }
                            }
            } failureHandler: { (error) in
                print(error)
                if let msg = error["message"] as? String {
                    self.delegate?.onFailure(msg: msg)
                }
                
            }

    }
   
}
extension UserChatViewController:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        LoaderClass.shared.stopAnimation()
        if msg == "Image Sent"{
//            hitSocket()
            SocketHelperss.shared.emitMessageList(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", room_id: romId){
                print("Done")
            }
            
            SocketHelperss.shared.onMessageList(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", room_id: romId){(model) in
                if let mode = model{
                    for item in mode{
                        self.messageModalClass.append(item)
                    }
                    
                }
    //            self.messageModalClass = model ?? []
                          print("Done")
            
//                          if self.messageModalClass.count == 0{
//
//                          }else if self.messageModalClass.count == 1{
//
//                          }else{
//
//                              self.lblAdvisorName.text = self.name
//                              let url = URL(string:(imageBaseUrl + (self.photo)))
//                              self.imgProfile.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
//
////                              self.scrollToBottom1()
//                          }
                        
                self.tableView.reloadData()
                      }
            LoaderClass.shared.stopAnimation()
        }
        


    }
    
    func onFailure(msg: String) {
        LoaderClass.shared.stopAnimation()
        Alert.showSimple(msg)
    }
}
