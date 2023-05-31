//
//  UserAdvisorListPopUp.swift
//  Zodium
//
//  Created by tecH on 22/10/21.
//

import UIKit
import Cosmos
protocol NextPage {
    func first()
}


class UserAdvisorListPopUp: UIViewController {


    var messageModalClass = [UserModel]()
    var delegate1: NextPage?
    var myHeading = ""
    var advPrice = Double()
    var advisorsId = Int()
    var chatType = ""
    var chatTime = Int()
    
    let date = Date()
    let calendar = Calendar.current

    var timeZone = ""
    var currentdate = ""
    var model = UserAdvisorListPopUpViewModelClass()
    
    @IBOutlet weak var lblIncreasingTime: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var chatSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.model.delegate = self
        
        print(advisorsId)
        
        lblHeading.text = myHeading
        lblPrice.text = "£\(advPrice)/min"
        
        self.chatTime = 1
        
        let date = Date()
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
           let current_date_time = dateFormatter.string(from: date)
//           print("before add time-->",current_date_time)
        print("before add time-->\(current_date_time)")
        currentdate = current_date_time
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        timeZone = localTimeZoneIdentifier
        print("9999999999999999999999\(localTimeZoneIdentifier)")
    }
    
    // Hitting socket to update advisor side
    
    func hitSocket(){
        SocketHelperss.shared.emitHomeRequest(user_id: "\(advisorsId)", role: "2"){
            print("Done")
        }
        
        SocketHelperss.shared.onAdvHomeRequest(user_id: "\(advisorsId)", role: "2"){(model) in
            
            self.messageModalClass = model ?? []
                      print("Done")
        
                      if self.messageModalClass.count == 0{
          
                      }else if self.messageModalClass.count == 1{
          
                          
                          
                          
                      }
                      LoaderClass.shared.stopAnimation()
                  }
        LoaderClass.shared.stopAnimation()

        }
    
    
    
    

    @IBAction func onSliderChanged(_ sender: Any) {
        
        updatePrice(requiredRating: nil)
      
    }
    
    private func updatePrice(requiredRating: Int?) {
    var newRatingValue: Int = 0
        
    if let nonEmptyRequiredRating = requiredRating {
        newRatingValue = nonEmptyRequiredRating
    } else {
        newRatingValue = Int(chatSlider.value)
    }
        
        
    self.lblIncreasingTime.text = "\(UserAdvisorListPopUp.formatValue(newRatingValue))-min"
        self.chatTime = Int((UserAdvisorListPopUp.formatValue(newRatingValue))) ?? 0
        
  }
    //MARK:- Common function
    
    private class func formatValue(_ value: Int) -> String {
      return String(format: "%02d", value)
    }
    @IBAction func btnClickCross(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btnClickProceedToPay(_ sender: Any) {
        
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        
        
        print("\(hour)\(minutes)\(second)")
        let amount = "\(advPrice * Double(chatTime))"
        let otheruser = [Param.adviser_id: "\(advisorsId)", Param.b_type: chatType,Param.b_minute: "\(chatTime)",Param.b_amount: amount,Param.req_time :"\(hour):\(minutes):\(second)",Param.b_timezone: timeZone, Param.b_current_timestamp: currentdate] as [String : Any]
        self.model.makeReqApi(param: otheruser, onSucssesMsg: CustomeAlertMsg.booking)
          
    }
    
}
extension UISlider {

    func setThumbValueWithLabel() -> CGPoint {
    
        let slidertTrack : CGRect = self.trackRect(forBounds: self.bounds)
        let sliderFrm : CGRect = self.thumbRect(forBounds: self.bounds, trackRect: slidertTrack, value: self.value)
        return CGPoint(x: sliderFrm.origin.x + self.frame.origin.x + 8, y: self.frame.origin.y - 20)
    }
}
extension UserAdvisorListPopUp:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        if  msg == CustomeAlertMsg.booking {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
           //     let encodedJson = try JSONDecoder().decode(horoDataSave.self, from: jsondata)
            //    print(encodedJson)
//
                hitSocket()
                
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserHomeVC") as! UserHomeVC
//
//                self.navigationController?.pushViewController(vc, animated: true)
                
                        if let del = self.delegate1{
                            dismiss(animated: true, completion: nil)
                            del.first()
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
extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    func startOfMonth() -> Date {
           return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
       }
       
       func endOfMonth() -> Date {
           return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
       }
//    func getYesterday() -> Date? {
//        return Calendar.current.date(byAdding: startOfMonth(), value: -1, to: self)
//    }
}
