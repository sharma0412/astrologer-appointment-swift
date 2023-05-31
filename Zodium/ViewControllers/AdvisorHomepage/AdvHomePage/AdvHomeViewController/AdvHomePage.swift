//
//  AdvHomePage.swift
//  Zodium
//
//  Created by tecH on 19/10/21.
//

import UIKit
import SideMenu
import IBAnimatable
import SocketIO

var advName = ""
var advEmail = ""
var advImage = ""

class AdvHomePage: UIViewController {
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblCustomer: UILabel!
    @IBOutlet weak var lblTotalEarning: UILabel!
    
    @IBOutlet weak var btnSwitch: UISwitch!
    
    @IBOutlet weak var imgAdv: AnimatableImageView!
    @IBOutlet weak var lblAdvMail: UILabel!
    @IBOutlet weak var lblAdvName: UILabel!
    var menu : SideMenuNavigationController?
    var model = AdvHomeViewModelClass()
    var messageModalClass = [UserModel]()
    
    var stat = Int()
    var bokId = Int()
    var UId = ""
    
    var currentdate = ""
    
    //MARK:- Views
    
    @IBOutlet weak var confirmRequestView: AnimatableView!
    @IBOutlet weak var waitingForUserConfirmView: AnimatableView!
    @IBOutlet weak var onGoingView: AnimatableView!
    
    //MARK:- Views Height
    
    @IBOutlet weak var confirmReqViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var waitingforUserHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var onGoingHeightConstraint: NSLayoutConstraint!
    
    //MARK:- Views confirm request Label
    
    @IBOutlet weak var lblConfirmViewUserName: UILabel!
    @IBOutlet weak var lblConfirmViewUserLocation: UILabel!
    @IBOutlet weak var imgConfirmViewUser: AnimatableImageView!
    @IBOutlet weak var lblOngoingUserName: UILabel!
    @IBOutlet weak var lblOngoingUserLocation: UILabel!
    
    
    //MARK:- View waiting for user confirmation
    
    @IBOutlet weak var lblUserNameWaitingforPayment: UILabel!
    
    @IBOutlet weak var lblUserLocationWaitingforPayment: UILabel!
    @IBOutlet weak var imgUserWaitingForPayment: AnimatableImageView!
    @IBOutlet weak var imgOngoingUser: AnimatableImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.model.delegate = self
        
//        setupSideMenu()
//
//        btnSwitch.layer.borderWidth = 1
//        btnSwitch.layer.cornerRadius = 15
//        btnSwitch.layer.borderColor = UIColor.white.cgColor
//        // Do any additional setup after loading the view.
//        advisorDetailsAPI()
    }
    @IBAction func btnClickConfirmRequest(_ sender: Any) {
        
        SocketHelperss.shared.establishConnection()
        hitSocketStatusUopdate()
        
    }
    @IBAction func notiAction(_ sender: UIButton){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnClickOnGoing(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "UserChatViewController") as! UserChatViewController
     
        vc.romId = self.messageModalClass[0].room_id ?? ""
        vc.photo = self.messageModalClass[0].profile_image ?? ""
        vc.name = self.messageModalClass[0].name ?? ""
        vc.advisorId = "\(self.messageModalClass[0].userId ?? 0)"
        vc.bookingType = "\(self.messageModalClass[0].b_type ?? 0)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.model.delegate = self
        setupSideMenu()
        
        btnSwitch.layer.borderWidth = 1
        btnSwitch.layer.cornerRadius = 15
        btnSwitch.layer.borderColor = UIColor.white.cgColor

        
    
        confirmReqViewHeightConstraint.constant = 0
        confirmRequestView.isHidden = true
        
        waitingforUserHeightContraint.constant = 0
        waitingForUserConfirmView.isHidden = true
        
        onGoingHeightConstraint.constant = 0
        onGoingView.isHidden = true
        
        advisorDetailsAPI()
        SocketHelperss.shared.establishConnection()
        hitSocket()
    }
    
    //MARK:- hitting Advisor home details socket
    
    func hitSocket(){
        SocketHelperss.shared.emitHomeRequest(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", role: "2"){
            print("Done")
            
        }
        SocketHelperss.shared.onAdvisorStatus { response in
            print("OnStatus")
            self.advisorDetailsAPI()
        }
        SocketHelperss.shared.onAdvHomeRequest(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", role: "2"){(model) in
            
            self.messageModalClass = model ?? []
                      print("Done")
        
                      if self.messageModalClass.count == 0{
          
                      }else if self.messageModalClass.count == 1{
          
                          self.stat = self.messageModalClass[0].b_status ?? 0
                          self.bokId = self.messageModalClass[0].booking_id ?? 0
                          
                          self.lblRating.text = "\(self.messageModalClass[0].total_rating ?? 0)"
                          self.lblReview.text = "\(self.messageModalClass[0].total_review ?? 0)"
                          self.lblCustomer.text = "\(self.messageModalClass[0].total_customer ?? 0)"
                          self.lblTotalEarning.text = "\(self.messageModalClass[0].total_earning ?? 0)"
                          
                          
                          if self.stat == 1 {
                              self.confirmReqViewHeightConstraint.constant = 350
                              self.confirmRequestView.isHidden = false
                              
                              self.lblConfirmViewUserName.text = self.messageModalClass[0].name ?? ""
                              self.lblConfirmViewUserLocation.text = self.messageModalClass[0].email ?? ""
                              self.UId = "\(self.messageModalClass[0].id ?? 0)"
                              
                              let url = URL(string:(imageBaseUrl + (self.messageModalClass[0].profile_image ?? "" )))
                              self.imgConfirmViewUser.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
                              
                              
                              self.waitingforUserHeightContraint.constant = 0
                              self.waitingForUserConfirmView.isHidden = true
                              
                              self.onGoingHeightConstraint.constant = 0
                              self.onGoingView.isHidden = true
                              
                            
                          }else if self.stat == 3 {
                              self.waitingforUserHeightContraint.constant = 350
                              self.waitingForUserConfirmView.isHidden = false
                              
                              let url = URL(string:(imageBaseUrl + (self.messageModalClass[0].profile_image ?? "" )))
                              self.imgUserWaitingForPayment.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
                              
                              self.lblUserNameWaitingforPayment.text = self.messageModalClass[0].name ?? ""
                              self.lblUserLocationWaitingforPayment.text = self.messageModalClass[0].email ?? ""
                              
                              
                              self.confirmReqViewHeightConstraint.constant = 0
                              self.confirmRequestView.isHidden = true
                              
                              self.onGoingHeightConstraint.constant = 0
                              self.onGoingView.isHidden = true
                              
                          }else if self.stat == 5 {
                              self.onGoingHeightConstraint.constant = 350
                              self.onGoingView.isHidden = false
                              
                              let url = URL(string:(imageBaseUrl + (self.messageModalClass[0].profile_image ?? "" )))
                              self.imgOngoingUser.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
                              
                              self.lblOngoingUserName.text = self.messageModalClass[0].name ?? ""
                              self.lblOngoingUserLocation.text = self.messageModalClass[0].email ?? ""
                              
                              
                              
                          }else{
                        
                          }
                          
                          
                          
                      }
                      LoaderClass.shared.stopAnimation()
                  }
        LoaderClass.shared.stopAnimation()

        }
    
    //MARK:- Hiting socket for ststus Update
    
    func hitSocketStatusUopdate(){
        
        
        let date = Date()
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
           let current_date_time = dateFormatter.string(from: date)
//           print("before add time-->",current_date_time)
        print("before add time-->\(current_date_time)")
        currentdate = current_date_time
        
        SocketHelperss.shared.emitHomeStatusUpdate(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", status: "3", booking_id: "\(bokId)", id: UId, b_current_timestamp: currentdate){
            print("Done")
        }
        
        SocketHelperss.shared.onHomeStatusUpdate(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", status: "3", booking_id: "\(bokId)", id: UId, b_current_timestamp: currentdate){(model) in
            
            self.messageModalClass = model ?? []
                      print("Done")
        
                      if self.messageModalClass.count == 0{
          
                      }else if self.messageModalClass.count == 1{
          
                          let stat = self.messageModalClass[0].b_status
                          
                          
                          if stat == 1 {
                              self.confirmReqViewHeightConstraint.constant = 350
                              self.confirmRequestView.isHidden = false
                            
                          }else{
                              self.confirmReqViewHeightConstraint.constant = 0
                              self.confirmRequestView.isHidden = true
                          }
                          
                          self.lblConfirmViewUserName.text = self.messageModalClass[0].name ?? ""
                          self.lblConfirmViewUserLocation.text = self.messageModalClass[0].city ?? ""
                          
                          
                          let url = URL(string:(imageBaseUrl + (self.messageModalClass[0].profile_image ?? "" )))
                          self.imgConfirmViewUser.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
                          
                      }
            
            SocketHelperss.shared.establishConnection()
            self.hitSocket()
            
                      LoaderClass.shared.stopAnimation()
                  }
        LoaderClass.shared.stopAnimation()

        }
    
    
    
    
    func advisorDetailsAPI(){
        
       
        self.model.callAdvDetailsApi(param: [:], onSucssesMsg:  CustomeAlertMsg.myDetails)
        
    }
    
    func setupSideMenu() {
           
               SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeeftMenuNavigationController") as? SideMenuNavigationController
               SideMenuManager.default.addPanGestureToPresent(toView: view)
           }
    
    
    @IBAction func btnSwitch(_ sender: Any) {
        if ((sender as AnyObject).isOn == true) {
            print("Online")
            btnSwitch.layer.cornerRadius = 15
            btnSwitch.thumbTintColor = UIColor.lightGray
            SocketHelperss.shared.emitAdvisorStatus(adviser_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", status: "1") {
                print("OOnnDone")
            }
        }else{
            print("Offline")
            btnSwitch.layer.cornerRadius = 15
            btnSwitch.thumbTintColor = UIColor.black
            SocketHelperss.shared.emitAdvisorStatus(adviser_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", status: "0") {
                print("OOFFDONE")
            }
        }
        
    }
}
extension AdvHomePage:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        if  msg == CustomeAlertMsg.myDetails {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response["body"], options: .prettyPrinted)
                let encodedJson = try JSONDecoder().decode(userProfileDataSave.self, from: jsondata)
                print(encodedJson)

                lblAdvName.text = encodedJson.name ?? ""
                lblAdvMail.text = encodedJson.email ?? ""
                
                let url = URL(string:(imageBaseUrl + (encodedJson.profile_image ?? "")))
                imgAdv.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
                
                
                advName = encodedJson.name ?? ""
                advEmail = encodedJson.email ?? ""
                advImage = encodedJson.profile_image ?? ""
                Singleton.shared.chatPrice = encodedJson.chat_price ?? 0
                Singleton.shared.chatAudioPrice = encodedJson.chat_audio_price ?? 0
                Singleton.shared.chatVideoPrice = encodedJson.chat_video_price ?? 0

                if encodedJson.is_online == 1{
                    btnSwitch.layer.cornerRadius = 15
                    btnSwitch.isOn = true
                    btnSwitch.thumbTintColor = UIColor.lightGray
                }else{
                    btnSwitch.layer.cornerRadius = 15
                    btnSwitch.isOn = false
                    btnSwitch.thumbTintColor = UIColor.black
                }
                
                
            }catch {
            }
            
        }
        
    }
    
    func onFailure(msg: String) {
        print(msg)
        Alert.showSimple(msg)
    }
    
    
    
}
