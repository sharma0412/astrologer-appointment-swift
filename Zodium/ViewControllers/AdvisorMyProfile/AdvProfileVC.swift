//
//  AdvProfileVC.swift
//  Zodium
//
//  Created by tecH on 26/10/21.
//

import UIKit
import IBAnimatable
import DropDown

class AdvProfileVC: UIViewController, UIImagePickerControllerDelegate {

    @IBOutlet weak var btnGender: UIButton!
    
    var type = 0
    
    @IBOutlet weak var imgProfileAdvisor: UIPhotosButton!
    var imgPath = [UIImage]()
    
    @IBOutlet weak var imgProfile: AnimatableImageView!
    @IBOutlet weak var lblAdvTopName: UILabel!
    @IBOutlet weak var lblAdvTopEmail: UILabel!
    
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAdvName: UITextField!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var txtAdvEmail: UITextField!
    
   
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
    @IBOutlet weak var droupDownView: AnimatableView!
    
    var droupDownArray = ["Male","Female","Others"]
    
    var dropDown = DropDown()
    
    var model = MyProfileViewModelClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetUp()
        self.model.delegate = self
        
        detailsAPI()
        
        
        imgProfileAdvisor.closureDidFinishPickingAnUIImage = { (image) in
                                  if let uploadImage = image {
                                   self.imgProfile.image = uploadImage
                                   self.imgPath = [uploadImage]
                               
                                  }
        
        
        }
        
        
        
    }
    
    @IBAction func btnClickSelectCity(_ sender: Any) {
        print("clicked")
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchCityVC") as? SearchCityVC
        vc?.name = "Select City"
        self.type = 2
        vc?.controllerNo = self.type
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    @IBAction func btnClickSelectCountry(_ sender: Any) {
        print("clicked")
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchCityVC") as? SearchCityVC
        vc?.name = "Select Country"
            self.type = 1
            vc?.controllerNo = self.type
            vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    
    
    func UpdateAdvisorProfileAPI(){
        
        let otheruser = [Param.name: txtAdvName.text ?? "",Param.email: txtAdvEmail.text ?? "",Param.dob: txtDob.text ?? "",Param.gender: txtGender.text ?? "",Param.desc: txtDescription.text ?? "",Param.city: txtCity.text ?? "",Param.country: txtCountry.text ?? "",Param.other: txtAddress.text ?? ""] as [String : Any]
       
        self.model.updateProfileApi(param: otheruser, onSucssesMsg:  CustomeAlertMsg.userProfileUpdate)
        
    }
    
    
    func uiSetUp(){
        txtAdvName.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtDob.attributedPlaceholder = NSAttributedString(string: "Date of birth", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtAdvEmail.attributedPlaceholder = NSAttributedString(string: "Date of birth", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
//        txtAddress.attributedPlaceholder = NSAttributedString(string: "Your Address", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtGender.attributedPlaceholder = NSAttributedString(string: "Gender", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    }
    
    func detailsAPI(){
       
        self.model.myDetailsdApi(onSucssesMsg:  CustomeAlertMsg.myDetails)
        
    }
    
    func updateProfilePhoto(){
        
        self.model.updateProfilePhoto(image: imgPath, onSucssesMsg: CustomeAlertMsg.advImgUpdate)
    }
    
    
    @IBAction func btnClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnClickGender(_ sender: Any) {
        selectGender()
    }
    
    func selectGender(){
        
        let reason = self.droupDownArray
        let reasondata = reason.map({$0 })
   
        self.showDropDown(view: self.droupDownView, stringArray: reasondata, textFeild: self.txtGender)
        
             }
    
    
    
    func showDropDown(view:UIView,stringArray:[String],textFeild:UITextField){
            dropDown.anchorView = view
            dropDown.dataSource = stringArray
            dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
            dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
            dropDown.direction = .bottom
            dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            textFeild.text = stringArray[index]
         
            }
        }
    
    @IBAction func btnUpdateProfile(_ sender: Any) {
        //Alert.showSimple("Under Development")
        UpdateAdvisorProfileAPI()
        updateProfilePhoto()
    }
    
}
extension AdvProfileVC:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        if  msg == CustomeAlertMsg.myDetails {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response["body"], options: .prettyPrinted)
                let encodedJson = try JSONDecoder().decode(userProfileDataSave.self, from: jsondata)
                print(encodedJson)
                
                lblAdvTopName.text = encodedJson.name ?? ""
                lblAdvTopEmail.text = encodedJson.email ?? ""
                
                txtAdvName.text = encodedJson.name ?? ""
                txtAdvEmail.text = encodedJson.email ?? ""
                txtDob.text = encodedJson.dob ?? ""
                txtGender.text = encodedJson.gender ?? ""
                txtDescription.text = encodedJson.desc ?? ""
                txtAddress.text = (encodedJson.other ?? "")
                txtCity.text = encodedJson.city ?? ""
                txtCountry.text = encodedJson.country ?? ""
                
                let url = URL(string:(imageBaseUrl + (encodedJson.profile_image ?? "")))
                imgProfile.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
                
                
    
                
            }catch {
            }
            
        }else if  msg == CustomeAlertMsg.userProfileUpdate {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response["body"], options: .prettyPrinted)
               // let encodedJson = try JSONDecoder().decode(userProfileDataSave.self, from: jsondata)
            
                let dic = (response["message"] as? String)!
                
                Alert.showSimple(dic){
                    
                }
                
                detailsAPI()
                
            }catch {
            }
            
        }else if  msg == CustomeAlertMsg.advImgUpdate {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response["body"], options: .prettyPrinted)
//                let encodedJson = try JSONDecoder().decode(userProfileDataSave.self, from: jsondata)
//                print(encodedJson)
                
            
                
                
            }catch {
            }
            
        }
        
    }
    
    func onFailure(msg: String) {
        print(msg)
        Alert.showSimple(msg)
    }
    
    
    
}
extension AdvProfileVC: GetData {
    func getcity(data: String?) {
        if type == 2 {
            
            txtCity.text = data
            
        }else if type == 1 {
            txtCountry.text = data
        }
    }
    
    
}
