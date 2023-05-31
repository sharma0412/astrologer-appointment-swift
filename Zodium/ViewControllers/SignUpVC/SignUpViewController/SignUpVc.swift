//
//  SignUpVc.swift
//  Zodium
//
//  Created by tecH on 11/10/21.
//

import UIKit
import DropDown
import IBAnimatable
import RSSelectionMenu

class SignUpVc: UIViewController, UIImagePickerControllerDelegate {

    @IBOutlet weak var btnSelectImgUser: UIButton!
    
    @IBOutlet weak var verifyImg: UIImageView!
    @IBOutlet weak var selectImageUser: UIPhotosButton!
    @IBOutlet weak var selectImagAdvisor: UIPhotosButton!
    @IBOutlet weak var btnAdvUploadPhot: UIPhotosButton!
    @IBOutlet weak var btnConnectStripe: UIButton!
    
    var imgPath = [UIImage]()
    var imgPathUser = [UIImage]()
    var selectedImageView = 0
    
    var flag = true
    var Uflag = true
    var selected = 0
    var dropDown = DropDown()
    var type = 0
    var catList = [String]()
    var selectedList = [String]()
    var selectedListID = [String]()

    var dropDownArray: [CatBody]?
    var selectedUser : [CatBody]?
    var val = true
    var Uval = true
    let datePicker = UIDatePicker()
    let todaysDate = Date()
    let datePicker1 = UIDatePicker()
    
    var controller = UIImagePickerController()
    var imagePicker : ImagePicker!
    
    var droupDownCityArray = ["chandigarh","Mohali","Panchkula","Saharanpur"]
    
    @IBOutlet weak var btnAdvisor: UIButton!
    @IBOutlet weak var btnUser: UIButton!
    @IBOutlet weak var lblLogin: UILabel!
    
    @IBOutlet weak var imgProfileAdvisor: AnimatableImageView!
    @IBOutlet weak var imgProfileUser: AnimatableImageView!
    
    @IBOutlet weak var btnTickAdvisor: UIButton!
    @IBOutlet weak var btnTickUser: UIButton!
    
    var model = SignUpViewModelClass()
    
    @IBOutlet weak var btnCatDrop: UIButton!
    @IBOutlet weak var droupDownView: AnimatableView!
    @IBOutlet weak var droupDownCityView: AnimatableView!
    
    @IBOutlet weak var btnHideShowPass: UIButton!
    @IBOutlet weak var btnHideShowPasswordUser: UIButton!
    
    @IBOutlet weak var btnCountryDroupDown: UIButton!
    @IBOutlet weak var btnCityDroupDown: UIButton!
    @IBOutlet weak var UseerView: UIView!
    @IBOutlet weak var DvisorView: UIView!
    @IBOutlet weak var lblSignUp: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtEmsil: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCatagory: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtUserDateOfBirth: UITextField!
    @IBOutlet weak var txtUserEmail: UITextField!
    @IBOutlet weak var txtUserPassword: UITextField!
    
    var catID = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verifyImg.isHidden = true
//        self.lblLogin.font = .boldSystemFont(ofSize: 22)
        
        let image = UIImage(named: "select")
        btnAdvisor.setImage(image, for: .normal)
        
        self.model.delegate = self
        
        showDatePicker()
        showDatePicker1()
        
        btnAdvisor.setTitle("", for: .normal)
        btnUser.setTitle("", for: .normal)
        btnTickAdvisor.setTitle("", for: .normal)
        btnTickUser.setTitle("", for: .normal)
        btnCityDroupDown.setTitle("", for: .normal)
        btnCountryDroupDown.setTitle("", for: .normal)
       
        selectImagAdvisor.setTitle("", for: .normal)
        selectImageUser.setTitle("", for: .normal)
        
        btnCatDrop.setTitle("", for: .normal)
        
        uiSetUp()
        UseerView.isHidden = true
        self.lblSignUp.isUserInteractionEnabled = true
        self.lblLogin.isUserInteractionEnabled = true
        bottomLabelTextLogin()
        bottomLabelText()
        
        getCatagoryList()
        //getCityList()
        
       // self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        
        
        selectImagAdvisor.closureDidFinishPickingAnUIImage = { (image) in
                              if let uploadImage = image {
                               self.imgProfileAdvisor.image = uploadImage
                               self.imgPath = [uploadImage]
                           
                              }
        }
        selectImageUser.closureDidFinishPickingAnUIImage = { (image) in
                                  if let uploadImage = image {
                                   self.imgProfileUser.image = uploadImage
                                   self.imgPathUser = [uploadImage]
                               
                                  }
        }
        
            btnAdvUploadPhot.closureDidFinishPickingAnUIImage = { (image) in
                if let uploadImage = image {
                 self.imgProfileAdvisor.image = uploadImage
                 self.imgPath = [uploadImage]
             
                }
            
        
        
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserIdStripe == ""{
            verifyImg.isHidden = true
        }else{
            verifyImg.isHidden = false
        }
        
        
    }
    
    @IBAction func btnClickConnectStripe(_ sender: Any) {
        print("WebView")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewControllerVC") as! WebViewControllerVC
    
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func uiSetUp(){
        txtName.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtDOB.attributedPlaceholder = NSAttributedString(string: "Date of Birth", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtEmsil.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtCatagory.attributedPlaceholder = NSAttributedString(string: "Category", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtLocation.attributedPlaceholder = NSAttributedString(string: "House|Flat|Office", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtCountry.attributedPlaceholder = NSAttributedString(string: "Country", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtCity.attributedPlaceholder = NSAttributedString(string: "City", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        
        txtUserName.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtUserDateOfBirth.attributedPlaceholder = NSAttributedString(string: "Date of birth", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtUserEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtUserPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    }
    
    func bottomLabelText(){
            let text = "Already have an account? "
        let secondText = "LogIn"
        lblSignUp.text = text.appending(secondText)
            self.lblSignUp.textColor =  UIColor.white

            let underlineAttriString = NSMutableAttributedString(string: text)
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)] as [NSAttributedString.Key : Any]

        let underlineAttriStringg = NSMutableAttributedString(string: secondText , attributes: underlineAttribute)


            let range1 = (secondText as NSString).range(of: "Log In")
           let data = underlineAttriString.append(underlineAttriStringg)
        
        lblSignUp.attributedText = underlineAttriString
        lblSignUp.isUserInteractionEnabled = true
        lblSignUp.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        }
    
    func bottomLabelTextLogin(){
            let text = "Already have an account? "
        let secondText = "LogIn"
        
        lblLogin.text = text
            self.lblLogin.textColor =  UIColor.white
        
            let underlineAttriString = NSMutableAttributedString(string: text)
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)] as [NSAttributedString.Key : Any]
//        let font = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        
//        let underlineAttriStringt = NSMutableAttributedString(string: secondText , attributes: font)
        let underlineAttriStringtt = NSMutableAttributedString(string: secondText , attributes: underlineAttribute)

            let range1 = (text as NSString).range(of: " Log In")
//         let data = underlineAttriString.append(underlineAttriStringt)
        let d = underlineAttriString.append(underlineAttriStringtt)
//            let doo =
        
        
        lblLogin.attributedText = underlineAttriString
      
        lblLogin.isUserInteractionEnabled = true
        lblLogin.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabelLogin(gesture:))))
        }
    
    func showDatePicker(){
           //Formate Date
           datePicker.datePickerMode = .date
           if #available(iOS 13.4, *) {
               datePicker.preferredDatePickerStyle = .wheels
           } else {
               
           }
           
           //ToolBar
           let toolbar = UIToolbar();
           toolbar.sizeToFit()
           let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donedatePicker))
           let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
           let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
           
           toolbar.setItems([doneButton,spaceButton,cancelButton], animated: true)
           
           txtDOB.inputAccessoryView = toolbar
        txtDOB.inputView = datePicker
           
       }
       
       @objc func donedatePicker(){
   //        let string = "01/02/2016"
           let inputFormatter = DateFormatter()
           inputFormatter.dateFormat = "MM/dd/YYYY"
           let outputFormatter = DateFormatter()
           outputFormatter.dateFormat = "dd/MM/YYYY"
           txtDOB.text = outputFormatter.string(from: datePicker.date)
           
         //  datePicker.minimumDate = todaysDate
   
           self.view.endEditing(true)
       }
       
       @objc func cancelDatePicker(){
           self.view.endEditing(true)
       }
    
    
    func showDatePicker1(){
           //Formate Date
           datePicker1.datePickerMode = .date
           if #available(iOS 13.4, *) {
               datePicker1.preferredDatePickerStyle = .wheels
           } else {
               
           }
           
           //ToolBar
           let toolbar = UIToolbar();
           toolbar.sizeToFit()
           let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donedatePicker1))
           let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
           let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
           
           toolbar.setItems([doneButton,spaceButton,cancelButton], animated: true)
           
        txtUserDateOfBirth.inputAccessoryView = toolbar
        txtUserDateOfBirth.inputView = datePicker1
           
       }
       
       @objc func donedatePicker1(){
   //        let string = "01/02/2016"
           let inputFormatter = DateFormatter()
           inputFormatter.dateFormat = "MM/dd/YYYY"
           let outputFormatter = DateFormatter()
           outputFormatter.dateFormat = "dd/MM/YYYY"
           txtUserDateOfBirth.text = outputFormatter.string(from: datePicker1.date)
           
          // datePicker1.minimumDate = todaysDate
   
           self.view.endEditing(true)
       }
    
    
    
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let termsRange = (lblSignUp.text as! NSString).range(of: " LogIn")
    // comment for now
    //let privacyRange = (text as NSString).range(of: "Privacy Policy")

    if gesture.didTapAttributedTextInLabel(label: lblSignUp, inRange: termsRange) {
        print("Tapped terms")
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController

        self.navigationController?.pushViewController(vc!, animated: true)
    }  else {
        print("Tapped none")
    }
    }
    
    @IBAction func tapLabelLogin(gesture: UITapGestureRecognizer) {
        let termsRange = (lblLogin.text as! NSString).range(of: " LogIn")
        

    if gesture.didTapAttributedTextInLabel(label: lblLogin, inRange: termsRange) {
        print("Tapped terms")
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController

        self.navigationController?.pushViewController(vc!, animated: true)
    }  else {
        print("Tapped none")
    }
    }
    
    //MARK:- API's
    
    
    func getCatagoryList(){
        
        
        self.model.callCatagoryListApi(param: [:], onSucssesMsg:  CustomeAlertMsg.catagoryListFetched)
        
    }
    
//    func SignUpAdvisorAPI(){
//
//        let otheruser = [Param.name: txtName.text!,Param.dob: txtDOB.text!,Param.email: txtEmsil.text!,Param.password: txtPassword.text!,Param.cat_id: catID,Param.other: txtLocation.text!,Param.country: txtCountry.text!,Param.city: txtCity.text!,Param.role: 2,Param.device_type: "iOS",Param.device_token: UserDefaults.standard.string(forKey: "deviceToken")!] as [String : Any]
//        self.model.callSignUpApi(param: otheruser, image: imgPath, onSucssesMsg:  CustomeAlertMsg.signupFetched)
//
//    }
    
    
    func SignUpUserAPI(){
         
        let otheruser = [Param.name: txtUserName.text!,Param.dob: txtUserDateOfBirth.text!,Param.email: txtUserEmail.text!,Param.password: txtUserPassword.text!,Param.role: 1,Param.device_type: "iOS",Param.device_token: appDeviceToken] as [String : Any]
        
    
        self.model.callSignUpApi(param: otheruser, image: imgPathUser, onSucssesMsg:  CustomeAlertMsg.signupFetched)
    }
    
    //    MARK: - FUNCTION DROPDOWN
        func showAsMultiSelectPopover(sender: UIView) {
            let reason = self.dropDownArray ?? []
            let reasondata = reason.map({$0.cat_name ?? ""})
            let reasondata1 = reason.map({$0.cat_id ?? 0})

            // selection type as multiple with subTitle Cell
            let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: reasondata, cellType: .subTitle) { (cell, name, indexPath) in
            
                cell.textLabel?.text = name.components(separatedBy: " ").first
                cell.detailTextLabel?.text = name.components(separatedBy: " ").last
            }
            
            // selected items
            
            selectionMenu.setSelectedItems(items: selectedList) { [weak self] (text, index, selected, selectedList) in
                
                // update list
                
                self?.selectedList = selectedList
                for id in self?.dropDownArray ?? [] {
                    if self?.selectedList.contains(id.cat_name ?? "") == true{
                        if self?.selectedListID.contains("\(id.cat_id ?? 0)") == true{
                            let id = "\(id.cat_id ?? 0)"
                            let i1 = self?.selectedListID.firstIndex(where: {$0 == id})
                            self?.selectedListID.remove(at: i1 ?? 0)

                           // 0
                        }else{
                            self?.selectedListID.append("\(id.cat_id ?? 0)")

                        }

                    }
//                    if ((self?.selectedList.contains(id.cat_name ?? "")) == nil){
//                        self?.selectedListID.append(id.cat_id ?? 0)
//                    }
                }
                self?.txtCatagory.text = selectedList.joined(separator: ",")
                /// do some stuff...
                
                // update value label
               
            }
            
            // search bar
            selectionMenu.showSearchBar { [weak self] (searchText) -> ([String]) in
                return self?.selectedList.filter({ $0.lowercased().starts(with: searchText.lowercased()) }) ?? []
            }
            
            // show empty data label - provide custom text (if needed)
            selectionMenu.showEmptyDataLabel(text: "No Category Found")
            
            // cell selection style
            selectionMenu.cellSelectionStyle = .tickmark
            
            // show as popover
            // specify popover size if needed
            // size = nil (auto adjust size)
            selectionMenu.show(style: .popover(sourceView: sender, size: nil), from: self)
        }
    
    
    
    
    
    
//    @IBAction func btnClickSelectImage(_ sender: Any) {
//
//        self.selectedImageView = 1
//
//        self.imagePicker.present(from: self.view)
//    }
    
    @IBAction func btnClickSelectImgUserProfile(_ sender: Any) {
        
        self.selectedImageView = 2
        
        self.imagePicker.present(from: self.view)
    }
    

    @IBAction func btnAdvisor(_ sender: Any) {
        UseerView.isHidden = true
        DvisorView.isHidden = false
        
        let image = UIImage(named: "select")
        btnAdvisor.setImage(image, for: .normal)
        
        let image2 = UIImage(named: "unfill")
        btnUser.setImage(image2, for: .normal)
    }
    
    
    
    @IBAction func btnUser(_ sender: Any) {
        UseerView.isHidden = false
        DvisorView.isHidden = true
        
        let image = UIImage(named: "select")
        btnUser.setImage(image, for: .normal)
        
        let image2 = UIImage(named: "unfill")
        btnAdvisor.setImage(image2, for: .normal)
   
    }
    
    @IBAction func btnClickTickAdvisor(_ sender: Any) {
        
        if val == true{
            let image = UIImage(named: "check")
            btnTickAdvisor.setImage(image, for: .normal)
            val = false
        }else{
            let image = UIImage(named: "Rectangle 141")
            btnTickAdvisor.setImage(image, for: .normal)
            val = true
        }
   
    }
    
    @IBAction func btnTickUser(_ sender: Any) {
        if Uval == true{
            let image = UIImage(named: "check")
            btnTickUser.setImage(image, for: .normal)
            Uval = false
        }else{
            let image = UIImage(named: "Rectangle 141")
            btnTickUser.setImage(image, for: .normal)
            Uval = true
        }
        
    }
    
    
    
    @IBAction func btnHideShowPassword(_ sender: Any) {
        
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
    
    @IBAction func btnHideShowPasswordUser(_ sender: Any) {
        
        if flag == true{
            let image = UIImage(named: "hidden")
              btnHideShowPasswordUser.setImage(image, for: .normal)
            
            txtUserPassword.isSecureTextEntry = false
            
            flag = false
        }else{
            let image = UIImage(named: "Icon feather-eye-off")
            btnHideShowPasswordUser.setImage(image, for: .normal)
            
            txtUserPassword.isSecureTextEntry = true
            flag = true
        }
        
    }
    
    
    @IBAction func BtnCliVkDropDownCat(_ sender: Any) {
       // self.selectCatagoryist()
        self.showAsMultiSelectPopover(sender: self.txtCatagory)
    }
    
    
    
    @IBAction func btnClickCatDroupDown(_ sender: Any) {
        print("Catagory droupdown")
//        self.selectCatagoryist()
    }
    
    
    @IBAction func btnClickSelectCountry(_ sender: Any){
        print("country")
    
    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchCityVC") as? SearchCityVC
    vc?.name = "Select Country"
        self.type = 1
        vc?.controllerNo = self.type
        vc?.delegate = self
    self.present(vc!, animated: true, completion: nil)
    
    }
    
    @IBAction func btnClickCityDroupDown(_ sender: Any) {
        print("City Drop Down")
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchCityVC") as? SearchCityVC
        vc?.name = "Select City"
        self.type = 2
        vc?.controllerNo = self.type
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
            }
    
    func selectCatagoryist(){
        
        self.selected = 1
        
        
        let reason = self.dropDownArray ?? []
        let reasondata = reason.map({$0.cat_name ?? ""})
   
        
             self.showDropDown(view: self.droupDownView, stringArray: reasondata, textFeild: self.txtCatagory)
        
             }
    
    
    func selectCitylist(){
        
        self.selected = 2
             self.showDropDown(view: self.droupDownCityView, stringArray: droupDownCityArray, textFeild: self.txtCity)
             }
    
    func showDropDown(view:UIView,stringArray:[String],textFeild:UITextField){
            dropDown.anchorView = view
            dropDown.dataSource = stringArray
            dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
            dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
            dropDown.direction = .bottom
            dropDown.show()
            dropDown.multiSelectionAction = { [unowned self] (index: [Int], item: [String]) in
                
                
                print("Selected item: \(item) at index: \(index)")
                print(index)
      
                if selected == 1{
                    txtCatagory.text = item.joined(separator: ",")
                    catList = item

                    self.catID.removeAll()

                    for i in dropDownArray!{
                        if item.contains(i.cat_name ?? ""){
                            self.catID.append("\(i.cat_id ?? 0)")
                        }else{
                        }
                    }



                }else if selected == 2 {
                    
//                    txtCity.text = stringArray[index]
                }
         
            }
        }
    
    @IBAction func btnNext(_ sender: Any) {
        
        if txtName.text == ""{
            Alert.showSimple("Please enter name")
           // showToast(message: "Please enter name")
        }else if txtDOB.text == ""{
             Alert.showSimple("Please enter DOB")
            //showToast(message: "Please enter DOB")
        }else if txtEmsil.text == ""{
             Alert.showSimple("Please enter E-mail")
           // showToast(message: "Please enter E-mail")
        }else if txtPassword.text == ""{
            Alert.showSimple("Please enter Password")
            //showToast(message: "Please enter Password")
        }else if txtPassword.text?.count ?? 0 < 6{
            Alert.showSimple("Password must be of 6 chracters")
        }else if txtCatagory.text == ""{
            Alert.showSimple("Please select atleast one catagory")
           // showToast(message: "Please select atleast one catagory")
        }else if txtLocation.text == ""{
            Alert.showSimple("Please enter your Address")
            //showToast(message: "Please enter your Address")
        }else if txtCountry.text == ""{
            Alert.showSimple("Please select atleast one country")
          // showToast(message: "Please select atleast one country")
        }else if txtCity.text == ""{
            Alert.showSimple("Please select atleast one city")
           // showToast(message: "Please select atleast one city")
        }else if UserIdStripe == ""{
            Alert.showSimple("please connect with stripe for signUp")
        }else if val == true{
            Alert.showSimple("Before signing please check the Terms and Conditons box")
        }else if ((txtEmsil.text?.isValidEmail) != true) {
            showToast(message: "E-mail nor valid")
        }else{
 //           SignUpAdvisorAPI()
//            print("Signin")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddServicesViewController") as! AddServicesViewController
            vc.advName = txtName.text!
            vc.advDOB = txtDOB.text!
            vc.advEmail = txtEmsil.text!
            vc.advPassword = txtPassword.text!
            vc.advCat = selectedListID
            vc.advHouse = txtLocation.text!
            vc.advCountry = txtCountry.text!
            vc.advCity = txtCity.text!
            vc.advImage = imgPath
            vc.come = "SignUp"
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
    }
    
    @IBAction func btnClickUserSignUp(_ sender: Any) {
        
        if txtUserName.text == ""{
            Alert.showSimple("Please enter Name")
        }else if txtUserDateOfBirth.text == ""{
            Alert.showSimple("Please enter DOB")
        }else if txtUserEmail.text == ""{
            Alert.showSimple("Please enter Email")
        }else if txtUserPassword.text == ""{
            Alert.showSimple("Please enter Password")
        }else if txtUserPassword.text?.count ?? 0 < 6{
            Alert.showSimple("Password must be of 6 chracters")
        }else if Uval == true{
            Alert.showSimple("Before signing please check the Terms and Conditons box")
        }
        
        else if((txtUserEmail.text?.isValidEmail) != true) {
            showToast(message: "E-mail nor valid")
        }else{
            SignUpUserAPI()
        }
    }
    
    
}
extension SignUpVc:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        if  msg == CustomeAlertMsg.catagoryListFetched {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let encodedJson = try JSONDecoder().decode(CatagorySaveData.self, from: jsondata)
                print(encodedJson)
//                if let arrRecipients = encodedJson.body ?? []{
//                    for item in arrRecipients{
//
//                    }
//                }
                self.dropDownArray = encodedJson.body ?? []
      
            }catch {
            }
            
        }else if msg == CustomeAlertMsg.searchCityListFetched {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
//                let encodedJson = try JSONDecoder().decode(RecipieReviewData.self, from: jsondata)
//                print(encodedJson)
          

            }catch {
            }
            
        }else if msg == CustomeAlertMsg.signupFetched {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
//                let encodedJson = try JSONDecoder().decode(RecipieReviewData.self, from: jsondata)
//                print(encodedJson)
                
                if let body = response["body"] as? [String: Any]{
                               let token = body["token"] as? String ?? ""
                               UserDefaults.standard.setValue(token, forKey: UserDefaultKey.kUserToken)
                    
                    
                    let role = body["role"]
                    let userId = body["user_id"] as? Int ?? 0
                    print(role)
                    UserDefaults.standard.set(body["role"], forKey: "role")

                    print(UserDefaultKey.kUserToken)
                    
                    UserDefaults.standard.setValue(userId, forKey: "Uid")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserHomeVC") as! UserHomeVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
//                    if role as! String != "2" {
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserHomeVC") as! UserHomeVC
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }else{
//                        Alert.showSimple("Under development")
//                    }
                
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
extension SignUpVc: GetData {
    func getcity(data: String?) {
        if type == 2 {
            
            txtCity.text = data
            
        }else if type == 1 {
            txtCountry.text = data
        }
    }
    
    
}
extension String {
   var isValidEmail: Bool {
      let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
      return testEmail.evaluate(with: self)
   }
   var isValidPhone: Bool {
      let regularExpressionForPhone = "^\\d{3}-\\d{3}-\\d{4}$"
      let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
      return testPhone.evaluate(with: self)
   }
}


extension SignUpVc : ImagePickerDelegate{
    func didSelect(image: UIImage?) {
        if image != nil {
            
            if selectedImageView == 1 {
                imgProfileAdvisor.image = image
            }else if selectedImageView == 2 {
                imgProfileUser.image = image
            }
            
            
            
            
//
//            btnUploadPhotoPlus.isHidden = true
//            lblUploadLabel.isHidden = true
            
//            let data = image!.jpegData(compressionQuality: 0.2)! as Data
//                       imgDataToUpload = data
//                       self.profileUpdateApi()
            
            print(image)
            
            
            
           
        }
        
    }
}
