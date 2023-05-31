//
//  UserHoroscopeFullDetails.swift
//  Zodium
//
//  Created by tecH on 21/10/21.
//

import UIKit

class UserHoroscopeFullDetails: UIViewController {

    var Udate = ""
    var yourSign = ""
    var Udescription = ""
    
    let startWeek = Date().startOfWeek
    let endWeek = Date().endOfWeek

    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblYourSign: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lblYourSign.text = yourSign
        lblDescription.text = Udescription
        
       // let newDate = Udate.date(format: "dd/M/yyyy")
        
     //   let newDate = Udate.convertUTCDateToLocal(format: "MMMM dd,yyyy")
        
        let startdate = "\(startWeek!)"
        let startDate = startdate.convertUTCDateToLocal2(format: "MMMM dd,yyyy")
        let enddate = "\(endWeek!)"
        let endDate = enddate.convertUTCDateToLocal2(format: "MMMM dd,yyyy")
        
        lblDate.text = "\(startDate)" + " - " + "\(endDate)"
    }
    

    
    @IBAction func btnClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
}
