//
//  HistoryDataSave.swift
//  Zodium
//
//  Created by tecH on 09/12/21.
//

import Foundation
struct HistoryDataSave: Codable {
    
    var created_at,payment_id,req_time: String?
    var adviser_id,b_amount,b_minute,b_status,b_type,is_rating,rating,user_id: Int?
    var user: Users?
    
}

struct Users: Codable {
    
    var city,country,created_at,desc,device_token,device_type,dob,email,gender,name,other,password,password_resets,permission,phone,profile_image,remember_token,updated_at,uuid: String?
    var chat_audio_price,chat_price,chat_video_price,id,is_online,login_type,role,user_status,user_stripe_id: Int?
    
}

typealias historyDataSave = [HistoryDataSave]?
