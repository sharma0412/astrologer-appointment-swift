//
//  ResetPassword.swift
//  Zodium
//
//  Created by tecH on 11/10/21.
//

import UIKit

class ForgotPassword: UIViewController {

    @IBOutlet weak var txtMail: UITextField!
    
    var model = ForgotPasswordViewModelClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model.delegate = self
        uiSetUp()
    }
    
    func uiSetUp(){
        txtMail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
    }
    @IBAction func btnClickSubmit(_ sender: Any) {
        if txtMail.text == ""{
            Alert.showSimple("Enter E-mail")
        }else if ((txtMail.text?.isValidEmail) != true) {
            Alert.showSimple("E-mail not valid")
        }else{
            ForgotPasswordAPI()
        }
        
    }
    
    func ForgotPasswordAPI(){
        
        let otheruser = [Param.email: txtMail.text!] as [String : Any]
        self.model.forgotPasswordApi(param: otheruser, onSucssesMsg:  CustomeAlertMsg.forgotPassword)
        
    }
    @IBAction func btnClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension ForgotPassword:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        if  msg == CustomeAlertMsg.forgotPassword {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
//                let encodedJson = try JSONDecoder().decode(CatagorySaveData.self, from: jsondata)
//                print(encodedJson)
                Alert.showSimple("Password sent sucessfully"){
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
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
