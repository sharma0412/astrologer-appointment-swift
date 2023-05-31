//
//  CommonParam.swift
//  WorkPlace
//
//  Created by tech on 24/02/21.
//

import Foundation
import UIKit

struct Param {
    
    static let action = "action"
    static let search = "search"
    static let email = "email"
    static let code = "code"
    static let type = "type"
    static let cardNo = "card[number]"
    static let cardMonth = "card[exp_month]"
    static let cardYear = "card[exp_year]"
    static let cardCvv = "card[cvc]"
    
    static let grant_type = "grant_type"
    
    static let is_fav = "is_fav"
    
    static let old_pass = "old_pass"
    static let new_pass = "new_pass"
    
    static let password = "password"
    static let role = "role"
    static let device_type = "device_type"
    static let device_token = "device_token"
    static let user_stripe_id = "user_stripe_id"
    static let name = "name"
    static let gender = "gender"
    static let desc = "desc"
    
    static let dob = "dob"
    static let other = "other"
    static let city = "city"
    static let country = "country"
    static let cat_id = "cat_id"
    static let chat_price = "chat_price"
    static let chat_audio_price = "chat_audio_price"
    static let chat_video_price = "chat_video_price"
    
    static let adviser_id = "adviser_id"
    static let b_type = "b_type"
    static let req_time = "req_time"
    static let b_minute = "b_minute"
    static let b_amount = "b_amount"
    static let b_timezone = "timezone"
    static let b_current_timestamp = "booking_current_timestamp"
    
}

struct ConstatntWord {
    static let languages = "languages"
    static let Skill_Cloud = "Skills Cloud"
    static let qualification = "Qualification"
    
}


struct Actions {
    static let register = "register"
    static let login = "login"
    static let fetch_restaurants = "fetch_restaurants"
    static let fetch_cuisine = "fetch_cuisine"
    static let me_data = "me_data"
    static let cuisine_dish = "cuisine_dish"
    
}
