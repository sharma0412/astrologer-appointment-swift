//
//  WebDataSaveModel.swift
//  Zodium
//
//  Created by tecH on 07/12/21.
//

import Foundation
import SwiftUI

struct WebDataSave:Codable{
    
    var data: Data
    
}
struct Data: Codable{
 
    var stripe_publishable_key = ""
    var stripe_user_id = ""
}

typealias webDataSaveModel = WebDataSave
