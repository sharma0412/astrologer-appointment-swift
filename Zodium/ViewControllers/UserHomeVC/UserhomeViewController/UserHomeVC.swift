//
//  HomeVC.swift
//  Zodium
//
//  Created by tecH on 13/10/21.
//

import UIKit
import SDWebImage
import SideMenu
import IBAnimatable
import SocketIO


var currenttime = 0
var paymentCTime = 0



var imgProfileUser: String?
var emailUser:String?
var nameProfileUser:String?
var param = [String: Any]()



class UserHomeVC: UIViewController {
var date2 = Date()
    var currentdate = ""
//    let calendar = Calendar.current
    
    var TimeForCall = 0
    var bookCurrenTimestamp = ""
    
    var timer : Timer? = nil {
            willSet {
                timer?.invalidate()
            }
        }
   // var timer : Timer?
    
    let date = Date()
    let calendar = Calendar.current
       
    var UId = ""
    
    var viewName = ""
    
    @IBOutlet weak var lblTimer: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    var menu : SideMenuNavigationController?
    var model = UserHomeViewModelClass()
    
    var model1 = MyProfileViewModelClass()
    
    var messageModalClass = [UserModel]()
    
    @IBOutlet weak var lblOngoingTimer: UILabel!
    var catList: [CatBody]?
    var isSelected = 0
    var bid = Int()
    var AdId = Int()
    var amount = Int()
    
    var rowNo:Bool = false
    
    
    //MARK:- Outlets of views
    
    @IBOutlet weak var waitTillConfirmView: AnimatableView!
    @IBOutlet weak var makePaymentView: AnimatableView!
    @IBOutlet weak var OnGoingView: AnimatableView!
   
    
    @IBOutlet weak var constHeightMainView: NSLayoutConstraint! //300
    
    //MARK:- Outlets of view heights
  
    //MARK:- Outlets of view labels
    
    @IBOutlet weak var lblAdvNameWaitTillView: UILabel!
    @IBOutlet weak var lblAdvLocationWaitTillView: UILabel!
    @IBOutlet weak var lblOngoingName: UILabel!
    
    @IBOutlet weak var lblmakePaymentAdvName: UILabel!
    @IBOutlet weak var lblMakePaymentLocationView: UILabel!
    @IBOutlet weak var lblOngoimgLocation: UILabel!
    
    //MARK:- Outlets of view images
    
    @IBOutlet weak var imgAdvWaitTillView: UIImageView!
    @IBOutlet weak var imgMakePaynebtView: AnimatableImageView!
    @IBOutlet weak var imgOngoingView: AnimatableImageView!
    
    var totalDiffrencetime = 0
    var difference = ""
    //MARK:- Outlets of views Timers
    
    @IBOutlet weak var waitTillConfirmTimer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        
        let date = Date()
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
           let current_date_time = dateFormatter.string(from: date)
//           print("before add time-->",current_date_time)
        print("before add time-->\(current_date_time)")
        currentdate = current_date_time
        
        
//        let addminutes = date.addingTimeInterval(5*60)
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            let after_add_time = dateFormatter.string(from: addminutes)
////            print("after add time-->",after_add_time)
//      print("after add time-->\(after_add_time)")
//       findDateDiff(time1Str: "\(after_add_time)", time2Str: "\(current_date_time)")
        
//        if after_add_time >= current_date_time{
//            print("Hello")
//        }else{
//            print("Hiiiiii")
//        }
       
        setupSideMenu()
        self.model.delegate = self
        self.model1.delegate = self
        btnMenu.setTitle("", for: .normal)
        btnSearch.setTitle("", for: .normal)
        
        
        self.tableView.register(UINib.init(nibName:"UserHomeTableViewCell" , bundle: nil), forCellReuseIdentifier: "UserHomeTableViewCell")
      
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        CatagoryListAPI()
        detailsAPI()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
           
      
     
        waitTillConfirmView.isHidden = true
   
        makePaymentView.isHidden = true
 
        OnGoingView.isHidden = true
        
        constHeightMainView.constant = 0
      
    }
    func findDateDiff(time1Str: String, time2Str: String) -> String {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard let time1 = timeformatter.date(from: time1Str),
            let time2 = timeformatter.date(from: time2Str) else { return "" }

        //You can directly use from here if you have two dates

        let interval = time2.timeIntervalSince(time1)
        print(interval)
        
        
        let hour = interval / 3600;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let seconds = minute * 60
        
        print(seconds)
        
        let intervalInt = Int(interval)
        print("\(intervalInt < 0 ? "-" : "+")\(Int(minute)) Minutes")
        difference = "\(intervalInt < 0 ? "-" : "+")\(Int(minute))"
        let minutes = difference.components(separatedBy: "-")
        print(minutes)
        totalDiffrencetime = Int(seconds)
//        let xyz = "00:\(minutes):00".secondFromString
       
        
        return "\(intervalInt < 0 ? "-" : "+")\(Int(minute))"
      
        
    }
    @IBAction func btnClickMakePayment(_ sender: Any) {
        print("make payment")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProceedToPaymentVC") as! ProceedToPaymentVC
        vc.bokId = bid
        vc.AdvId = AdId
        vc.Totalamount = amount
        vc.userStripeID = self.messageModalClass[0].user_stripe_id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func btnClickOngOing(_ sender: Any) {
        print("OnGoing")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserChatViewController") as! UserChatViewController
        vc.romId = self.messageModalClass[0].room_id ?? ""
        vc.photo = self.messageModalClass[0].profile_image ?? ""
        vc.name = self.messageModalClass[0].name ?? ""
        vc.advisorId = "\(self.messageModalClass[0].adviser_id ?? 0)"
        vc.bookingType = "\(self.messageModalClass[0].b_type ?? 0)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }

        print("9999999999999999999999\(localTimeZoneIdentifier)")

        TimeStampAPI()
        self.hitSocket()
        setupSideMenu()
        self.model.delegate = self
        self.model1.delegate = self
        btnMenu.setTitle("", for: .normal)
        btnSearch.setTitle("", for: .normal)
        
        
        self.tableView.register(UINib.init(nibName:"UserHomeTableViewCell" , bundle: nil), forCellReuseIdentifier: "UserHomeTableViewCell")
      
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        CatagoryListAPI()
        detailsAPI()
        
     //   SocketHelperss.shared.establishConnection()
       
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
           
      
     
        waitTillConfirmView.isHidden = true
   
        makePaymentView.isHidden = true
 
        OnGoingView.isHidden = true
        
        constHeightMainView.constant = 0
    
    }
    
    //MARK- Timer_for_schedule
    
    func startTimerForScheduleRequest() {
        stopTimer()
        guard self.timer == nil else { return }
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    //MARK- Timer_for_makepayment
    
    func startTimerForMakePayment() {
        stopTimer()
        guard self.timer == nil else { return }
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateForMakepayment), userInfo: nil, repeats: true)
    }
    
    //MARK- Timer for OnGoing
    
    func startTimerForOnGoing() {
        stopTimer()
        guard self.timer == nil else { return }
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateForOnGoing), userInfo: nil, repeats: true)
    }
    
    

    func stopTimer() {
        guard timer != nil else { return }
        timer?.invalidate()
        timer = nil
    }
    func hitSocket(){

        SocketHelperss.shared.emitHomeRequest(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", role: "1"){
            print("Donesssss")
        }
        
        SocketHelperss.shared.onAdvHomeRequest(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", role: "1"){(model) in
            
            self.messageModalClass = model ?? []
                      print("Done")
        
                      if self.messageModalClass.count == 0{
          
                      }else if self.messageModalClass.count == 1{
          
                          //self.tableView.reloadData()
                          self.constHeightMainView.constant = 300
                          
                          let viewStatus = self.messageModalClass[0].b_status ?? 0
                          
                          self.bid = self.messageModalClass[0].booking_id ?? 0
                          self.AdId = self.messageModalClass[0].adviser_id ?? 0
                          self.amount = self.messageModalClass[0].b_amount ?? 0
                          self.UId = "\(self.messageModalClass[0].id ?? 0)"
                        
                          if viewStatus == 1 {
                              
                              self.TimeStampAPI()
                              self.viewName = "confirm"
                              
                              self.constHeightMainView.constant = 300
                             
                              self.waitTillConfirmView.isHidden = false
                              self.makePaymentView.isHidden = true
                              self.OnGoingView.isHidden = true
                              
                              self.startTimerForScheduleRequest()
                              
//                              Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UserHomeVC.update), userInfo: nil, repeats: true)

                              self.lblAdvNameWaitTillView.text =  self.messageModalClass[0].name ?? ""
                              self.lblAdvLocationWaitTillView.text = self.messageModalClass[0].email ?? ""
                              let url = URL(string:(imageBaseUrl + (self.messageModalClass[0].profile_image ?? "" )))
                              self.imgAdvWaitTillView.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))

                          }else if viewStatus == 3 {
                              
                              
                              self.viewName = "payment"
                              
                              self.timer?.invalidate()
                              self.timer = nil
                              
                              self.TimeStampAPI()
                              self.startTimerForMakePayment()
                              
                              
                              self.constHeightMainView.constant = 300
                             
                              self.makePaymentView.isHidden = false
                              
                              self.waitTillConfirmView.isHidden = true
                             
                              self.OnGoingView.isHidden = true
                              
                              self.lblmakePaymentAdvName.text =  self.messageModalClass[0].name ?? ""
                              self.lblMakePaymentLocationView.text = self.messageModalClass[0].email ?? ""
                              let url = URL(string:(imageBaseUrl + (self.messageModalClass[0].profile_image ?? "" )))
                              self.imgMakePaynebtView.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
                            
                          }else if viewStatus == 5{
                              
                              self.viewName = "OnGoing"
                              
                              self.startTimerForOnGoing()
                              
                              self.constHeightMainView.constant = 300
                              self.OnGoingView.isHidden = false
                              
                              self.waitTillConfirmView.isHidden = true
                              
                              self.makePaymentView.isHidden = true
                              
                              self.lblOngoingName.text = self.messageModalClass[0].name ?? ""
                              
                              let cTime = self.messageModalClass[0].b_minute ?? 0
                              
                              self.TimeForCall = cTime * 60
                              
                              self.bookCurrenTimestamp = self.messageModalClass[0].booking_current_timestamp ?? ""
                              
                              self.lblOngoimgLocation.text = self.messageModalClass[0].email ?? ""
                              let url = URL(string:(imageBaseUrl + (self.messageModalClass[0].profile_image ?? "" )))
                              self.imgOngoingView.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
                              
                              
                          }
                          
                          
                          else{
                              self.constHeightMainView.constant = 0
                             // self.waitConfirmHeightConstraint.constant = 0
                             // self.waitTillConfirmView.isHidden = true
                          }
                          
                      }
//                      LoaderClass.shared.stopAnimation()
                  }
        
//        LoaderClass.shared.stopAnimation()

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
        
        SocketHelperss.shared.emitHomeStatusUpdate(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", status: "2", booking_id: "\(bid)", id: UId, b_current_timestamp: currentdate){
            print("Done")
        }
        
        SocketHelperss.shared.onHomeStatusUpdate(user_id: UserDefaults.standard.string(forKey: "Uid")  ?? "", status: "2", booking_id: "\(bid)", id: UId, b_current_timestamp: currentdate){(model) in
            
            self.messageModalClass = model ?? []
                      print("Done on")
        
                      if self.messageModalClass.count == 0{
          
                      }else if self.messageModalClass.count == 1{
                         
            
                          
                      }
//            self.view.reloadInputViews()
      //      SocketHelperss.shared.establishConnection()
            
                      LoaderClass.shared.stopAnimation()
                  }
        LoaderClass.shared.stopAnimation()

        }
    
    
    
//    @objc func UpdateTime(){
//        
//        print("Updarted")
//    }
    
    
        
    func setupSideMenu() {
           
               SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
               SideMenuManager.default.addPanGestureToPresent(toView: view)
           }
    
    func detailsAPI(){
        
        waitTillConfirmView.isHidden = true
   
        makePaymentView.isHidden = true
 
        OnGoingView.isHidden = true
        
        constHeightMainView.constant = 0
        
        
//    let otheruser = [Param.device_token: UserDefaults.standard.string(forKey: "deviceToken")!] as [String : Any]
       
        self.model1.myDetailsdApi(onSucssesMsg:  CustomeAlertMsg.myDetails)
        
    }
    
    
    func CatagoryListAPI(){
        
        self.model.callCatagoryListApi(param: [:], onSucssesMsg:  CustomeAlertMsg.catagoryListFetched)
        
    }
    func TimeStampAPI(){
        
        self.model.callTimeStampApi(param: [:], onSucssesMsg:  CustomeAlertMsg.timeStampMessage)
        
    }
    @IBAction func btnClickMenu(_ sender: Any) {
        print("Menu")
    }
    @IBAction func btnClickSearch(_ sender: Any) {
        print("Search")
    }
    
    //MARK - Timer
    
    func timeFormatted(_ totalSeconds: Int) -> String {
            let seconds: Int = totalSeconds % 60
            let minutes: Int = (totalSeconds / 60) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    
    @objc func update() {
        
        print(currenttime)
        
        if currenttime == 0{
            
//            currenttime = 0
            
            //HIT Api
            timer?.invalidate()
            timer = nil
           
           hitSocketStatusUopdate()
            
            detailsAPI()
            
            print("hit api")
           
            
            
        }else{
            currenttime = currenttime - 1
        }
        
            
        
        self.waitTillConfirmTimer.text = "\(self.timeFormatted(currenttime))"
 
        }
    
    
    @objc func updateForMakepayment() {
        
        print(currenttime)
        if currenttime == 0{
            //HIT Api
            timer?.invalidate()
            timer = nil
           hitSocketStatusUopdate()
            detailsAPI()
            print("hit api")
        }else{
            currenttime = currenttime - 1
        }
        self.lblTimer.text = "\(self.timeFormatted(currenttime))"
        }
    
    
    
    
    @objc func updateForOnGoing() {
        
        print(TimeForCall)
        
        if TimeForCall == 0{
            
//            currenttime = 0
            
            //HIT Api
            timer?.invalidate()
            timer = nil
           
          // hitSocketStatusUopdate()
            
          //  detailsAPI()
            
            print("booking complete")
           
            
            
        }else{
            TimeForCall = TimeForCall - 1
        }
        
            
        self.lblOngoingTimer.text = "\(self.timeFormatted(TimeForCall))"
  
 
        }
    
    
    
 
}
extension UserHomeVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return catList?.count ?? 0
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserHomeTableViewCell", for: indexPath) as! UserHomeTableViewCell
        cell.selectionStyle = .none
        cell.lblCatName.text = catList?[indexPath.row].cat_name ?? ""
        cell.lblCatDisc.text = catList?[indexPath.row].cat_desc ?? ""

        let url = URL(string:(imageBaseUrl2 + (catList?[indexPath.row].cat_image ?? "")))
        cell.catImage.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
        
      
        
        if self.isSelected == indexPath.row{
            if self.rowNo == true{
                cell.lblCatDisc.numberOfLines = 0
                cell.btnSeeMore.setTitle("Show less <<", for: .normal)
            }else{
                cell.lblCatDisc.numberOfLines = 3
                cell.btnSeeMore.setTitle("Show more >>", for: .normal)
            }
        }else{
            cell.lblCatDisc.numberOfLines = 3
            cell.btnSeeMore.setTitle("Show more >>", for: .normal)
        }
        
        cell.btnSeeMore.tag = indexPath.row
        cell.btnSeeMore.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        
        
        cell.selectionStyle = .none
            return cell
        }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserAdvisorListVC") as! UserAdvisorListVC
        vc.topName = catList?[indexPath.row].cat_name ?? ""
        vc.catagoryId = catList?[indexPath.row].cat_id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func buttonAction(_ sender:UIButton!)
    {
        self.isSelected = sender.tag
        
        if rowNo == true{
            rowNo = false
           }else{
            rowNo = true
           }
        tableView.reloadData()
       }

    
           
}
        
extension UserHomeVC:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        if  msg == CustomeAlertMsg.catagoryListFetched {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let encodedJson = try JSONDecoder().decode(CatagorySaveData.self, from: jsondata)
                print(encodedJson)

                self.catList = encodedJson.body
      
                tableView.reloadData()
                
            }catch {
            }
            
        }else if  msg == CustomeAlertMsg.myDetails {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response["body"], options: .prettyPrinted)
                let encodedJson = try JSONDecoder().decode(userProfileDataSave.self, from: jsondata)
                print(encodedJson)

                nameProfileUser = encodedJson.name ?? ""
                emailUser = encodedJson.email ?? ""
                imgProfileUser = encodedJson.profile_image
               
                SocketHelperss.shared.establishConnection()
                self.hitSocket()
    //        }

            }catch {
            }
            
        } else if msg == CustomeAlertMsg.timeStampMessage{
            if let body = response["body"] as? [String: Any]{
                let timezone = body["timezone"] as? String ?? ""
                let time = body["booking_current_timestamp"] as? String ?? ""
                let payTime = body["payment_timestamp"] as? String ?? ""
                
                print(payTime)
                print("------> \(time)")
                
                //MARK:- FOR CONFIRM
                let t = time.components(separatedBy: ".")
                let tt = t.first ?? ""
                
                
                //MARK:- FOR PAYMENT
                let pt = payTime.components(separatedBy: ".")
                let paytt = pt.first ?? ""
                
                print("-------> \(timezone)")
                let utcDateFormatter = DateFormatter()
                utcDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
     
                utcDateFormatter.timeZone = TimeZone(abbreviation: timezone)
                // Printing a Date
                let date = Date()
                print("1111111111111111---->\(utcDateFormatter.string(from: date))")
                
                if viewName == "confirm"{
                    if utcDateFormatter.string(from: date) < tt{
                        findDateDiff(time1Str: "\(utcDateFormatter.string(from: date))", time2Str: "\(tt)")
                        print("vikas------->\(totalDiffrencetime)")
                        let totalCount = totalDiffrencetime
                        print(totalCount)

                        if totalCount > 300{

                        }else{
                            currenttime = totalCount
                            print(currenttime)
9
                        }
                    }
                }else if viewName == "payment"{
                    
                    if utcDateFormatter.string(from: date) < tt{
                        findDateDiff(time1Str: "\(utcDateFormatter.string(from: date))", time2Str: "\(tt)")
                        print("vikas------->\(totalDiffrencetime)")
                        let totalCount = totalDiffrencetime
                        print(totalCount)

                        if totalCount > 300{

                        }else{
                            currenttime = totalCount
                            print(currenttime)
9
                        }
                    }
                    
                    else{
                    
                }
               
                }
        }
        }
    }
    
    func onFailure(msg: String) {
        print(msg)
        Alert.showSimple(msg)
    }
        }

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}
extension String {
     public enum DateFormatType {
    
    /// The ISO8601 formatted year "yyyy" i.e. 1997
    case isoYear
    
    /// The ISO8601 formatted year and month "yyyy-MM" i.e. 1997-07
    case isoYearMonth
    
    /// The ISO8601 formatted date "yyyy-MM-dd" i.e. 1997-07-16
    case isoDate
    
    /// The ISO8601 formatted date and time "yyyy-MM-dd'T'HH:mmZ" i.e. 1997-07-16T19:20+01:00
    case isoDateTime
    
    /// The ISO8601 formatted date, time and sec "yyyy-MM-dd'T'HH:mm:ssZ" i.e. 1997-07-16T19:20:30+01:00
    case isoDateTimeSec
    
    /// The ISO8601 formatted date, time and millisec "yyyy-MM-dd'T'HH:mm:ss.SSSZ" i.e. 1997-07-16T19:20:30.45+01:00
    case isoDateTimeMilliSec
    
    /// The dotNet formatted date "/Date(%d%d)/" i.e. "/Date(1268123281843)/"
    case dotNet
    
    /// The RSS formatted date "EEE, d MMM yyyy HH:mm:ss ZZZ" i.e. "Fri, 09 Sep 2011 15:26:08 +0200"
    case rss
    
    /// The Alternative RSS formatted date "d MMM yyyy HH:mm:ss ZZZ" i.e. "09 Sep 2011 15:26:08 +0200"
    case altRSS
    
    /// The http header formatted date "EEE, dd MM yyyy HH:mm:ss ZZZ" i.e. "Tue, 15 Nov 1994 12:45:26 GMT"
    case httpHeader
    
    /// A generic standard format date i.e. "EEE MMM dd HH:mm:ss Z yyyy"
    case standard
    
    /// A custom date format string
    case custom(String)
    
    /// The local formatted date and time "yyyy-MM-dd HH:mm:ss" i.e. 1997-07-16 19:20:00
    case localDateTimeSec
    
    /// The local formatted date  "yyyy-MM-dd" i.e. 1997-07-16
    case localDate
    
    /// The local formatted  time "hh:mm a" i.e. 07:20 am
    case localTimeWithNoon
    
    /// The local formatted date and time "yyyyMMddHHmmss" i.e. 19970716192000
    case localPhotoSave
    
    case birthDateFormatOne
    
    case birthDateFormatTwo
    
    ///
    case messageRTetriveFormat
    
    ///
    case emailTimePreview
    
    var stringFormat:String {
      switch self {
      //handle iso Time
      case .birthDateFormatOne: return "dd/MM/YYYY"
      case .birthDateFormatTwo: return "dd-MM-YYYY"
      case .isoYear: return "yyyy"
      case .isoYearMonth: return "yyyy-MM"
      case .isoDate: return "yyyy-MM-dd"
      case .isoDateTime: return "yyyy-MM-dd'T'HH:mmZ"
      case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ssZ"
      case .isoDateTimeMilliSec: return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      case .dotNet: return "/Date(%d%f)/"
      case .rss: return "EEE, d MMM yyyy HH:mm:ss ZZZ"
      case .altRSS: return "d MMM yyyy HH:mm:ss ZZZ"
      case .httpHeader: return "EEE, dd MM yyyy HH:mm:ss ZZZ"
      case .standard: return "EEE MMM dd HH:mm:ss Z yyyy"
      case .custom(let customFormat): return customFormat
        
      //handle local Time
      case .localDateTimeSec: return "yyyy-MM-dd HH:mm:ss"
      case .localTimeWithNoon: return "hh:mm a"
      case .localDate: return "yyyy-MM-dd"
      case .localPhotoSave: return "yyyyMMddHHmmss"
      case .messageRTetriveFormat: return "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
      case .emailTimePreview: return "dd MMM yyyy, h:mm a"
      }
    }
}
    func toDate(_ format: DateFormatType = .isoDateTimeMilliSec) -> Date?{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format.stringFormat
            let date = dateFormatter.date(from: self)
            return date
      }
    
     }

extension Date {
    func withAddedMinutes(minutes: Double) -> Date {
         addingTimeInterval(minutes * 60)
    }

    func withAddedHours(hours: Double) -> Date {
         withAddedMinutes(minutes: hours * 60)
    }
}
extension Date {
    
   public func addMinute(_ minute: Int) -> Date? {
       var comps = DateComponents()
       comps.minute = minute
       let calendar = Calendar.current
       let result = calendar.date(byAdding: comps, to: self)
       return result ?? nil
   }

}
