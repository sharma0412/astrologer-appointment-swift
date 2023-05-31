//
//  MyProfileModelClass.swift
//  Zodium
//
//  Created by tecH on 19/10/21.
//

import Foundation
struct UserProfileDataSave : Codable {
    var name,email,dob,profile_image,gender,desc,other,city,country,created_at,device_token,device_type,password,password_resets,permission,phone,updated_at,user_stripe_id,uuid : String?
    var chat_audio_price,chat_price,chat_video_price,id,login_type,role,user_status,is_online,total_customer,total_earning,total_rating,total_review: Int?
    var adviser_cats:[AdviserCats]?
}
struct AdviserCats : Codable {
    var category,created_at:String?
    var add_c_id,cat_id,user_id:Int?
}
   typealias userProfileDataSave = UserProfileDataSave
