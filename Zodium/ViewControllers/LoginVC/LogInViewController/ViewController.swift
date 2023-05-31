//
//  ViewController.swift
//  Zodium
//
//  Created by tecH on 11/10/21.
//

import UIKit

class ViewController: UIViewController,UIGestureRecognizerDelegate {

    var flag = true
    
    @IBOutlet weak var btnHideShowPass: UIButton!
    @IBOutlet weak var btnmail: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    
    @IBOutlet weak var lblSignUp: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var model = LogInViewModelClass()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtEmail.text = "heman@yopmail.com"
        self.txtPassword.text = "7777777"

        self.model.delegate = self
        
        btnmail.setTitle("", for: .normal)
        btnFacebook.setTitle("", for: .normal)
        btnApple.setTitle("", for: .normal)
        
        self.lblSignUp.isUserInteractionEnabled = true
        uiSetUp()
        bottomLabelText()
    }

    func uiSetUp(){
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    }
    
    func bottomLabelText(){
        let text = "Don't have an account? "
        
        let secondText = "Sign Up"
        
        lblSignUp.text = text.appending(secondText)
        self.lblSignUp.textColor =  UIColor.white
        
        
        let underlineAttriString = NSMutableAttributedString(string: text)
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)] as [NSAttributedString.Key : Any]
        
        let underlineAttriStringg = NSMutableAttributedString(string: secondText , attributes: underlineAttribute)
        
        let range1 = (text as NSString).range(of: " Sign Up")
        
       let data = underlineAttriString.append(underlineAttriStringg)
        
        lblSignUp.attributedText = underlineAttriString
        lblSignUp.isUserInteractionEnabled = true
        lblSignUp.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let termsRange = (lblSignUp.text as! NSString).range(of: " Sign Up")
        
    // comment for now
    //let privacyRange = (text as NSString).range(of: "Privacy Policy")

    if gesture.didTapAttributedTextInLabel(label: lblSignUp, inRange: termsRange) {
        print("Tapped terms")
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpVc") as? SignUpVc

        self.navigationController?.pushViewController(vc!, animated: true)
    }  else {
        print("Tapped none")
    }
    }
    @IBAction func btnClickLogIn(_ sender: Any) {
        if txtEmail.text == ""{
            Alert.showSimple("Please enter name")
        }else if txtPassword.text == ""{
            Alert.showSimple("Please enter password")
        }else if txtPassword.text?.count ?? 0 < 5{
            Alert.showSimple("Password must be of 6 chracters")
        }else if ((txtEmail.text?.isValidEmail) != true) {
            showToast(message: "E-mail nor valid")
        }else{
            LogInAPI()
        }
    }
    
    func LogInAPI(){
        
//        let otheruser = [Param.email: txtEmail.text!,Param.password: txtPassword.text!,Param.device_type: "iOS",Param.device_token: UserDefaults.standard.string(forKey: "deviceToken")!] as [String : Any]
        
        let otheruser = [Param.email: txtEmail.text!,Param.password: txtPassword.text!,Param.device_type: "iOS",Param.device_token: appDeviceToken] as [String : Any]
        
        self.model.callLogInApi(param: otheruser, onSucssesMsg:  CustomeAlertMsg.logIn)
        
    }
    
    @IBAction func btnClickForgotPassword(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassword") as! ForgotPassword
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnClickShowPass(_ sender: Any) {
        
        if flag == true{
            let image = UIImage(named: "hidden")
              btnHideShowPass.setImage(image, for: .normal)
            
            txtPassword.isSecureTextEntry = false
            
            flag = false
        }else{
            let image = UIImage(named: "Icon feather-eye-off")
              btnHideShowPass.setImage(image, for: .normal)
            
            txtPassword.isSecureTextEntry = true
            flag = true
        }
        
    }
    
    @IBAction func btnClickMail(_sender: Any) {
        print("Mail")
        Alert.showSimple("Under Development")
    }
    
    @IBAction func btnClickFacebook(_sender: Any) {
        print("Mail")
        Alert.showSimple("Under Development")
    }
    
    @IBAction func btnClickApple(_sender: Any) {
        Alert.showSimple("Under Development")
    }
    
    
}

extension ViewController:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        if  msg == CustomeAlertMsg.logIn {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
//                let encodedJson = try JSONDecoder().decode(CatagorySaveData.self, from: jsondata)
//                print(encodedJson)
                
                if let body = response["body"] as? [String: Any]{
                               let token = body["token"] as? String ?? ""
                    
                             let userId = body["user_id"] as? Int ?? 0
                    
                               UserDefaults.standard.setValue(token, forKey: UserDefaultKey.kUserToken)
                    UserDefaults.standard.set(body["role"], forKey: "role")

                    UserDefaults.standard.setValue(userId, forKey: "Uid")
                    
                    
                    
                    
                     let role = body["role"] as! String
                    
                    print(role)
                    
                    if role == "1" {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserHomeVC") as! UserHomeVC
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }else if role  == "2" {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdvHomePage") as! AdvHomePage
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
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


extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
         // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
         let layoutManager = NSLayoutManager()
         let textContainer = NSTextContainer(size: CGSize.zero)
         let textStorage = NSTextStorage(attributedString: label.attributedText!)

         // Configure layoutManager and textStorage
         layoutManager.addTextContainer(textContainer)
         textStorage.addLayoutManager(layoutManager)

         // Configure textContainer
         textContainer.lineFragmentPadding = 0.0
         textContainer.lineBreakMode = label.lineBreakMode
         textContainer.maximumNumberOfLines = label.numberOfLines
         let labelSize = label.bounds.size
         textContainer.size = labelSize

         // Find the tapped character location and compare it to the specified range
         let locationOfTouchInLabel = self.location(in: label)
         let textBoundingBox = layoutManager.usedRect(for: textContainer)
         //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                               //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
         let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.9 - textBoundingBox.origin.y)

         //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                         // locationOfTouchInLabel.y - textContainerOffset.y);
         let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
         let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
         return NSLocationInRange(indexOfCharacter, targetRange)
     }
}
