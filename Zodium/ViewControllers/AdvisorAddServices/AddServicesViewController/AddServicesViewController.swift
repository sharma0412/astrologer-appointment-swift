//
//  AddServicesViewController.swift
//  Zodium
//
//  Created by tecH on 19/10/21.
//

import UIKit
import Cosmos

class AddServicesViewController: UIViewController {
    
    
    var advName = ""
    var advDOB = ""
    var advEmail = ""
    var advPassword = ""
    var advCat = [String]()
    var listdat = ""
    var advHouse = ""
    var advCountry = ""
    var advCity = ""
    var advImage = [UIImage]()
    var param = [String: Any]()
    var come = ""

    @IBOutlet weak var chatSlider: UISlider!
    @IBOutlet weak var lblChat: UILabel!
 //   @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var chatAudioSlider: UISlider!
    @IBOutlet weak var lblChatAudioCall: UILabel!
    
    @IBOutlet weak var ChatVideoCallSlider: UISlider!
    @IBOutlet weak var lblChatVideochat: UILabel!
    
    var model = SignUpViewModelClass()
    var model1 = MyProfileViewModelClass()

    override func viewDidLoad() {
        super.viewDidLoad()
        if come == "SignUp"{
            self.model.delegate = self
        //    self.topLabel.text = "Add my service"
            self.signUpButton.setTitle("SIGN UP", for: .normal)
            lblChat.text = "£1"
            lblChatAudioCall.text = "£1"
            lblChatVideochat.text = "£1"
        }else{
            self.model1.delegate = self
         //   self.topLabel.text = "Edit my service"
            self.signUpButton.setTitle("UPDATE", for: .normal)
            self.chatSlider.value = Float(Singleton.shared.chatPrice ?? 0)
            self.chatAudioSlider.value = Float(Singleton.shared.chatAudioPrice ?? 0)
            self.ChatVideoCallSlider.value = Float(Singleton.shared.chatVideoPrice ?? 0)
            lblChat.text = "£\(Singleton.shared.chatPrice ?? 0)"
            lblChatAudioCall.text = "£\(Singleton.shared.chatAudioPrice ?? 0)"
            lblChatVideochat.text = "£\(Singleton.shared.chatVideoPrice ?? 0)"
        }
        
  
      
//    listdat.append(advCat.joined(separator: ","))
        
    }

    func SignUpAdvisorAPI(){
        
//        let otheruser = [Param.name: advName,Param.dob: advDOB,Param.email: advEmail,Param.password: advPassword,Param.cat_id: listdat,Param.other: advHouse,Param.country: advCountry,Param.chat_price: lblChat.text!,Param.chat_audio_price: lblChatAudioCall.text!,Param.chat_video_price: lblChatVideochat.text! ,Param.city: advCity,Param.role: 2,Param.device_type: "iOS",Param.device_token: UserDefaults.standard.string(forKey: "deviceToken")!] as [String : Any]
        
        
        let otheruser = [Param.name: advName,Param.dob: advDOB,Param.email: advEmail,Param.password: advPassword,Param.cat_id: advCat.joined(separator: ","),Param.other: advHouse,Param.country: advCountry,Param.chat_price: (Int(round(self.chatSlider.value))),Param.chat_audio_price: (Int(round(self.chatAudioSlider.value))),Param.chat_video_price: (Int(round(self.ChatVideoCallSlider.value))) ,Param.city: advCity,Param.role: 2,Param.device_type: "iOS",Param.device_token: appDeviceToken,Param.user_stripe_id: UserIdStripe] as [String : Any]
        
        
        self.model.callSignUpApi(param: otheruser, image: advImage, onSucssesMsg:  CustomeAlertMsg.signupFetched)
        
    }
    

    @IBAction func onSliderChanged(_ sender: AnyObject) {
        updateRating(requiredRating: nil)
    }
    
    @IBAction func onChatAudioSliderChange(_ sender: AnyObject) {
        chatAudio(requiredRating: nil)
    }
    
    @IBAction func chatVideoChat(_ sender: AnyObject) {
        chatVideo(requiredRating: nil)
        
    }
    
    
    
    //MARK:- Chat
    
    private func updateRating(requiredRating: Double?) {
    var newRatingValue: Double = 0
        
    if let nonEmptyRequiredRating = requiredRating {
        newRatingValue = nonEmptyRequiredRating
    } else {
        newRatingValue = Double(chatSlider.value)
    }
    self.lblChat.text = "£\(Int(round(self.chatSlider.value)))" //"£\(AddServicesViewController.formatValue(newRatingValue))"
  }
    
    //MARK:- Chat & Audio call
    
    private func chatAudio(requiredRating: Double?) {
    var newRatingValue: Double = 0
        
    if let nonEmptyRequiredRating = requiredRating {
        newRatingValue = nonEmptyRequiredRating
    } else {
        newRatingValue = Double(chatAudioSlider.value)
    }
    self.lblChatAudioCall.text = "£\(Int(round(self.chatAudioSlider.value)))" //"£\(AddServicesViewController.formatValue(newRatingValue))"
  }
    
    //MARK:- Chat and VideoChat
    
    private func chatVideo(requiredRating: Double?) {
    var newRatingValue: Double = 0
        
    if let nonEmptyRequiredRating = requiredRating {
        newRatingValue = nonEmptyRequiredRating
    } else {
        newRatingValue = Double(ChatVideoCallSlider.value)
    }
    self.lblChatVideochat.text = "£\(Int(round(self.ChatVideoCallSlider.value)))"
        // "£\(AddServicesViewController.formatValue(newRatingValue))"
  }
    
    
    
    
  
    //MARK:- Common function
    
    private class func formatValue(_ value: Double) -> String {
      return String(format: "%.2f", value)
    }
    
    @IBAction func btnClickSignUpAdv(_ sender: Any) {
        
        print("clicked")
        if come == "SignUp"{
            SignUpAdvisorAPI()

        }else{
            
            let x = Int(round(self.chatSlider.value)) // x is Int
            let y = Int(round(self.chatAudioSlider.value)) // x is Int
            let z = Int(round(self.ChatVideoCallSlider.value)) // x is Int

            let otheruser = ["chat_price":  x,"chat_audio_price": y,"chat_video_price": z] as [String : Any]
           
            self.model1.updateProfileApi(param: otheruser, onSucssesMsg:  CustomeAlertMsg.userProfileUpdate)
        }
    }
    @IBAction func btnClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension AddServicesViewController:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
         if msg == CustomeAlertMsg.signupFetched {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
//                let encodedJson = try JSONDecoder().decode(RecipieReviewData.self, from: jsondata)
//                print(encodedJson)
                
//                if let body = response["body"] as? [String: Any]{
//                               let token = body["token"] as? String ?? ""
//                               UserDefaults.standard.setValue(token, forKey: UserDefaultKey.kUserToken)
//
//                    let role = body["role"]
//                    print(role)
//
//                    print(UserDefaultKey.kUserToken)
                    
//                    if role as! String != "2" {
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserHomeVC") as! UserHomeVC
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }else{
//                        Alert.showSimple("Under development")
//                    }
                
              //  }
                
                
                if let body = response["body"] as? [String: Any]{
                               let token = body["token"] as? String ?? ""
                               UserDefaults.standard.setValue(token, forKey: UserDefaultKey.kUserToken)
                    
                    let role = body["role"]
                    let userId = body["user_id"] as? Int ?? 0
                    print(role)
                
                    print(UserDefaultKey.kUserToken)
                    UserDefaults.standard.setValue(userId, forKey: "Uid")
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdvHomePage") as! AdvHomePage
                
                    self.navigationController?.pushViewController(vc, animated: true)
                    

                
                }

            }catch {
            }
            
        }else if  msg == CustomeAlertMsg.userProfileUpdate {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response["body"], options: .prettyPrinted)
               // let encodedJson = try JSONDecoder().decode(userProfileDataSave.self, from: jsondata)
            
                self.navigationController?.popViewController(animated: true)
            }catch {
            }
            
        }
        
    }
    
    func onFailure(msg: String) {
        print(msg)
        Alert.showSimple(msg)
    }
    
    
    
}
