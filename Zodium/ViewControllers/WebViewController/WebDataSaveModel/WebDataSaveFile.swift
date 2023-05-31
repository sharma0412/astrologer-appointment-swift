//
//  WebDataSaveFile.swift
//  Zodium
//
//  Created by tecH on 07/12/21.
//

import Foundation
import Foundation
import SwiftUI

struct WebDataSaveFile:Codable{
    
    var data: Data1
    
}
struct Data1: Codable{
 
    var stripe_publishable_key : String?
    var stripe_user_id : String?
}

typealias webDataSaveModel = WebDataSaveFile
