//
//  MyProfileViewController.swift
//  Zodium
//
//  Created by tecH on 15/10/21.
//

import UIKit
import IBAnimatable
import DropDown
import SwiftUI

class MyProfileViewController: UIViewController {

    @IBOutlet weak var btnGender: UIButton!
    @IBOutlet weak var lblMail: UITextField!
    @IBOutlet weak var lblGender: UITextField!
    @IBOutlet weak var lblEditDOB: UITextField!
    @IBOutlet weak var lblEditName: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblUseEmail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgProfile: AnimatableImageView!
    @IBOutlet weak var btnImageSelect: UIPhotosButton!
    
    @IBOutlet weak var droupDownView: AnimatableView!
    
    var model = MyProfileViewModelClass()
    
    var imgPath = [UIImage]()
    
    var droupDownArray = ["Male","Female","Others"]
    
    var dropDown = DropDown()
    
    let datePicker = UIDatePicker()
    let todaysDate = Date()
    
    var controller = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.model.delegate = self
        
        btnBack.setTitle("", for: .normal)
        btnGender.setTitle("", for: .normal)
        uiSetUp()
        showDatePicker()
        
        detailsAPI()
        
        btnImageSelect.closureDidFinishPickingAnUIImage = { (image) in
                                  if let uploadImage = image {
                                   self.imgProfile.image = uploadImage
                                   self.imgPath = [uploadImage]
                               
                                  }
        
        
        }
        
        
    }
  
    
    func uiSetUp(){
        lblEditName.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        lblEditDOB.attributedPlaceholder = NSAttributedString(string: "Date of birth", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        lblGender.attributedPlaceholder = NSAttributedString(string: "Gender", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        lblMail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
    }
    
    // MARK:-api's
    
    func detailsAPI(){
       
        self.model.myDetailsdApi(onSucssesMsg:  CustomeAlertMsg.myDetails)
        
    }
    
    func UpdateProfiledetailsAPI(){
        
        let otheruser = [Param.name: lblEditName.text ?? "",Param.email: lblMail.text ?? "",Param.dob: lblEditDOB.text ?? "",Param.gender: lblGender.text ?? ""] as [String : Any]
       
        self.model.updateProfileApi(param: otheruser, onSucssesMsg:  CustomeAlertMsg.userProfileUpdate)
        
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
           
        lblEditDOB.inputAccessoryView = toolbar
        lblEditDOB.inputView = datePicker
           
       }
    
    @objc func donedatePicker(){
//        let string = "01/02/2016"
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MM/dd/YYYY"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/YYYY"
        lblEditDOB.text = outputFormatter.string(from: datePicker.date)
        
        datePicker.minimumDate = todaysDate
//        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @IBAction func btnClickGender(_ sender: Any) {
        
        selectGender()
        
    }
    
    
    func updateProfilePhoto(){
        
        self.model.updateProfilePhoto(image: imgPath, onSucssesMsg: CustomeAlertMsg.advImgUpdate)
    }
    
    func selectGender(){
        
        let reason = self.droupDownArray
        let reasondata = reason.map({$0 })
   
        

        self.showDropDown(view: self.droupDownView, stringArray: reasondata, textFeild: self.lblGender)
        
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
    
    
    
    @IBAction func btnClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnClickUpdate(_ sender: Any) {
        
        UpdateProfiledetailsAPI()
        updateProfilePhoto()
       // Alert.showSimple("Under Development")
    }
    
}
extension MyProfileViewController:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        if  msg == CustomeAlertMsg.myDetails {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response["body"], options: .prettyPrinted)
                let encodedJson = try JSONDecoder().decode(userProfileDataSave.self, from: jsondata)
                print(encodedJson)
                

                lblUserName.text = encodedJson.name ?? ""
                lblUseEmail.text = encodedJson.email ?? ""
                lblEditName.text = encodedJson.name ?? ""
                lblEditDOB.text = encodedJson.dob ?? ""
                lblMail.text = encodedJson.email ?? ""
                lblGender.text = encodedJson.gender ?? ""
                
                let url = URL(string:(imageBaseUrl + (encodedJson.profile_image ?? "")))
                imgProfile.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
                
                
    
                
            }catch {
            }
            
        }else if  msg == CustomeAlertMsg.userProfileUpdate {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response["body"], options: .prettyPrinted)
                
                let dic = (response["message"] as? String)!
                
                Alert.showSimple(dic){
                    
                }
                
               // let encodedJson = try JSONDecoder().decode(userProfileDataSave.self, from: jsondata)
            
                detailsAPI()
                
            }catch {
            }
            
        }
            
            
            
        }
 
    
    func onFailure(msg: String) {
        print(msg)
        Alert.showSimple(msg)
    }
    
    
}

