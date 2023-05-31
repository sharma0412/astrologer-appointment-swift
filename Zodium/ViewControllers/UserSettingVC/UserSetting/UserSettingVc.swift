//
//  UserSettingVc.swift
//  Zodium
//
//  Created by tecH on 22/10/21.
//

import UIKit

class UserSettingVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnClickChangePassword(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPassword") as! ResetPassword
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnClickHowItWorks(_ sender: Any) {
        Alert.showSimple("Under Development")
    }
    @IBAction func btnClickCustomerSupport(_ sender: Any) {
        Alert.showSimple("Under Development")
    }
    @IBAction func btnClickAbout(_ sender: Any) {
        Alert.showSimple("Under Development")
    }
}
