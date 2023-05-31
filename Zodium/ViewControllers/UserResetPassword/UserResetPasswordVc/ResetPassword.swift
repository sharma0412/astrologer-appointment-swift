//
//  ResetPassword.swift
//  Zodium
//
//  Created by tecH on 11/10/21.
//

import UIKit

class ResetPassword: UIViewController {

    @IBOutlet weak var lblCurrentPassword: UITextField!
    @IBOutlet weak var lblNewPassword: UITextField!
    @IBOutlet weak var lblConfirmPassword: UITextField!
    
    @IBOutlet weak var btnCurrentPass: UIButton!
    @IBOutlet weak var btnNewPass: UIButton!
    @IBOutlet weak var btnConFirmPassword: UIButton!
    var model = UserResetViewModelClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model.delegate = self

        uiSetUp()
    }
    
    
    @IBAction func btnClickCEye(_ sender: Any) {
        btnCurrentPass.isSelected = !btnCurrentPass.isSelected
        if btnCurrentPass.isSelected == true{
             lblCurrentPassword?.isSecureTextEntry = false
         }else{
             lblCurrentPassword?.isSecureTextEntry = true
         }
    }
    @IBAction func btnClickNewPass(_ sender: Any) {
        btnNewPass.isSelected = !btnNewPass.isSelected
        if btnNewPass.isSelected == true{
             lblNewPassword?.isSecureTextEntry = false
         }else{
             lblNewPassword?.isSecureTextEntry = true
         }
    }
    
    @IBAction func btnConConfirmPassword(_ sender: Any) {
        btnConFirmPassword.isSelected = !btnConFirmPassword.isSelected
        
        if btnConFirmPassword.isSelected == true{
             lblConfirmPassword?.isSecureTextEntry = false
         }else{
             lblConfirmPassword?.isSecureTextEntry = true
         }
    }
    
    
    func ResetPasswordAPI(){
        
        let otheruser = [Param.old_pass: lblCurrentPassword.text!,Param.new_pass: lblConfirmPassword.text!] as [String : Any]
        self.model.callresetPasswordApi(param: otheruser, onSucssesMsg:  CustomeAlertMsg.reset)
        
    }
    

    func uiSetUp(){
        lblCurrentPassword.attributedPlaceholder = NSAttributedString(string: "Current Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        lblNewPassword.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        lblConfirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    }

    @IBAction func btnClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnClickChangePass(_ sender: Any) {
        if lblCurrentPassword.text == ""{
            Alert.showSimple("Enter the current password")
        }else if lblNewPassword.text == ""{
            Alert.showSimple("Enter the new password")
        }else if lblConfirmPassword.text == ""{
            Alert.showSimple("Confirm password fiels is empty")
        }else if lblNewPassword.text != lblConfirmPassword.text {
            Alert.showSimple("Password did not match")
        }else {
            ResetPasswordAPI()
        }
    }
    
}
extension ResetPassword:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        if  msg == CustomeAlertMsg.reset {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let encodedJson = try JSONDecoder().decode(resetPaswordSave.self, from: jsondata)
                print(encodedJson)
                
                if encodedJson.message == "Password update successfully."{
                    
                    Alert.showSimple(encodedJson.message ?? ""){
                        self.navigationController?.popViewController(animated: true)
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
