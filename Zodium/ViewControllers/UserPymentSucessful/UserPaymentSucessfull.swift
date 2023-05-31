//
//  UserPaymentSucessfull.swift
//  Zodium
//
//  Created by tecH on 25/10/21.
//

import UIKit

class UserPaymentSucessfull: UIViewController {

    var roomId = ""
    override func viewDidLoad() {
        super.viewDidLoad()

       print(roomId)
    }
    

    @IBAction func btnClickCall(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserChatViewController") as! UserChatViewController
        vc.romId = roomId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
