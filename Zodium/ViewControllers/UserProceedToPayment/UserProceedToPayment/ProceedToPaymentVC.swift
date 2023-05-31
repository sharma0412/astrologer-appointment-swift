//
//  ProceedToPaymentVC.swift
//  Zodium
//
//  Created by tecH on 25/10/21.
//

import UIKit
import SwiftUI
import Stripe

var RiD = String()

class ProceedToPaymentVC: UIViewController, UITextFieldDelegate {

    var bokId = Int()
    var AdvId = Int()
    var Totalamount = Int()
    @IBOutlet weak var txtTotalAmount: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtExpirtDate: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var txtPayAmount: UITextField!
    
    var model = UserAdvisorListPopUpViewModelClass()
    
    var model2 = WebViewModelClass()
    
    var messageModalClass = [UserModel]()
    var userStripeID = ""
    let date = Date()
    let calendar = Calendar.current
    
    var param = [String: Any]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.model2.delegate = self
        
        self.model.delegate = self
        txtTotalAmount.text = "\(Totalamount)"
        
        self.txtCardNumber.delegate = self
        self.txtExpirtDate.delegate = self
        self.txtCVV.delegate = self
        self.txtExpirtDate.addTarget(self, action: #selector(expirationDateDidChange), for: .editingChanged)
        self.txtCardNumber.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        
    }
    
    
    @objc func expirationDateDidChange() {
        let currentText = txtExpirtDate.text ?? ""
        
        if currentText.count == 4 {
            txtExpirtDate.text = String(currentText.prefix(2))
            return
        }
        
        var dateText = txtExpirtDate.text?.replacingOccurrences(of: "/", with: "") ?? ""
        dateText = dateText.replacingOccurrences(of: " ", with: "")
        
        var newText = ""
        for (index, character) in dateText.enumerated() {
            if index == 1 {
                newText = "\(newText)\(character) / "
            } else {
                newText.append(character)
            }
        }
        txtExpirtDate.text = newText
    }
    
    @objc func didChangeText(textField:UITextField) {
        if textField == txtCardNumber{
            txtCardNumber.text = self.modifyCreditCardString(creditCardString: textField.text!)
        }else if textField == txtExpirtDate{
//                        txtExpireDate.text = self.modifyExpDateString(creditCardString: textField.text!)
        }
    }
    
    func modifyCreditCardString(creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        
        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
    
    @IBAction func btnClickNext(_ sender: Any) {
        
        
        if txtCardNumber.text?.isEmpty == true{
            Alert.showSimple("Enter Card Number")
        }else if txtExpirtDate.text?.isEmpty == true{
            Alert.showSimple("Enter Expiry Date")
        }else if txtCVV.text?.isEmpty == true{
            Alert.showSimple("Enter CVV")
        }else{
            let comps = txtExpirtDate.text?.components(separatedBy: " / ")
            let f = UInt(comps!.first!)
            let l = UInt(comps!.last!)
            let cardParams: STPCardParams = STPCardParams()
            cardParams.number = self.txtCardNumber.text ?? ""
            cardParams.expMonth = f!
            cardParams.expYear = l!
            
            
            let otheruser = [Param.type: "card",Param.cardNo: cardParams.number ?? "",Param.cardMonth: cardParams.expMonth,Param.cardYear: cardParams.expYear] as [String : Any]
            
            self.model2.callStripApiTTT(param: otheruser, onSucssesMsg: CustomeAlertMsg.stripeFetched)
        }
        

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text ?? "").count + string.count - range.length
        if(textField == txtCardNumber) {
            if newLength <= 19{
                return true
            }else{
                self.txtExpirtDate.becomeFirstResponder()
                return false
            }
        }
        if(textField == txtExpirtDate) {
            if newLength <= 7{
                return true
            }else{
                self.txtCVV.becomeFirstResponder()
                return false
            }
        }
        if(textField == txtCVV) {
            if newLength <= 3{
                return true
            }else{
                self.txtCVV.resignFirstResponder()
                return false
            }
        }
        return true
    }
    
    func expDateValidation(dateStr:String) {
        
        let currentYear = Calendar.current.component(.year, from: Date()) % 100   // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)
        
        let enteredYear = Int(dateStr.suffix(2)) ?? 0 // get last two digit from entered string as year
        let enteredMonth = Int(dateStr.prefix(2)) ?? 0 // get first two digit from entered string as month
        print(dateStr) // This is MM/YY Entered by user
        
        if enteredYear > currentYear {
            if (1 ... 12).contains(enteredMonth) {
                print("Entered Date Is Right")
            } else {
                print("Entered Date Is Wrong")
            }
        } else if currentYear == enteredYear {
            if enteredMonth >= currentMonth {
                if (1 ... 12).contains(enteredMonth) {
                    print("Entered Date Is Right")
                } else {
                    print("Entered Date Is Wrong")
                }
            } else {
                print("Entered Date Is Wrong")
            }
        } else {
            print("Entered Date Is Wrong")
        }
    }
 
    @IBAction func btnClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func hitPymentSocket(paymentId: String){
        
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        
        let curTime = "\(hour):\(minutes):\(second)"
        
        SocketHelperss.shared.emitMakePayment(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", status: "5", booking_id: "\(bokId)", payment_id: paymentId, curr_time: curTime, adviser_id: "\(AdvId)",user_stripe_id: self.userStripeID,booking_amount: self.txtPayAmount.text ?? ""){
                        print("Done")
        }
        SocketHelperss.shared.onMakePayment(booking_id: "\(bokId)") { userList, success in
            if success == 200{
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserPaymentSucessfull") as! UserPaymentSucessfull
                vc.roomId = userList
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
//        SocketHelperss.shared.onMakePayment(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", status: "5",booking_id: "\(bokId)",payment_id: ""){(model),(succ)  in
//
//
//            self.messageModalClass = model ?? []
//                      print("Done")
//
//                      if self.messageModalClass.count == 0{
//
//                      }else if self.messageModalClass.count == 1{
//
//                          //self.tableView.reloadData()
//                          if self.messageModalClass.count != 0 {
//

//                          }
//
//                      }
//                      LoaderClass.shared.stopAnimation()
//                  }
        LoaderClass.shared.stopAnimation()

        }
    
}

extension ProceedToPaymentVC: ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        if  msg == CustomeAlertMsg.stripeFetched {
            SocketHelperss.shared.establishConnection()
            let id = response["id"] as? String
            self.hitPymentSocket(paymentId: id ?? "")
          //  let stripeUserId = response["stripe_user_id"] as? String ?? ""
         //   let stripeUblishableKey = response["stripe_publishable_key"] as? String ?? ""
            
         //   UserIdStripe = response["stripe_user_id"] as? String ?? ""
         //   PublishableKey = response["stripe_publishable_key"] as? String ?? ""
            
          //  print(stripeUserId)
         //   print(stripeUblishableKey)
            
         //   navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    func onFailure(msg: String) {
        print(msg)
        Alert.showSimple(msg)
    }
    
    
    
}
