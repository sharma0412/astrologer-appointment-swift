//
//  UserFavAdvModel.swift
//  Zodium
//
//  Created by tecH on 27/10/21.
//

import Foundation
struct UserFavAdvModel : Codable {
    let success : Bool?
    let code : Int?
    let message : String?
    let body : [UserFavAdvBody]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case code = "code"
        case message = "message"
        case body = "body"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        body = try values.decodeIfPresent([UserFavAdvBody].self, forKey: .body)
    }

}
struct UserFavAdvBody : Codable {
    let id : Int?
    let user_id : Int?
    let adviser_id : Int?
    let cat_id : Int?
    let created_at : String?
    let user : AdvUser?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case adviser_id = "adviser_id"
        case cat_id = "cat_id"
        case created_at = "created_at"
        case user = "user"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        adviser_id = try values.decodeIfPresent(Int.self, forKey: .adviser_id)
        cat_id = try values.decodeIfPresent(Int.self, forKey: .cat_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        user = try values.decodeIfPresent(AdvUser.self, forKey: .user)
    }
    struct AdvUser : Codable {
        let id : Int?
        let uuid : String?
        let name : String?
        let email : String?
        let password : String?
        let device_type : String?
        let device_token : String?
        let role : Int?
        let login_type : Int?
        let created_at : String?
        let dob : String?
        let country : String?
        let city : String?
        let other : String?
        let profile_image : String?
        let is_online : Int?
        let user_status : Int?
        let phone : String?
        let remember_token : String?
        let updated_at : String?
        let chat_price : Double?
        let chat_audio_price : Double?
        let chat_video_price : Double?

        enum CodingKeys: String, CodingKey {

            case id = "id"
            case uuid = "uuid"
            case name = "name"
            case email = "email"
            case password = "password"
            case device_type = "device_type"
            case device_token = "device_token"
            case role = "role"
            case login_type = "login_type"
            case created_at = "created_at"
            case dob = "dob"
            case country = "country"
            case city = "city"
            case other = "other"
            case profile_image = "profile_image"
            case is_online = "is_online"
            case user_status = "user_status"
            case phone = "phone"
            case remember_token = "remember_token"
            case updated_at = "updated_at"
            case chat_price = "chat_price"
            case chat_audio_price = "chat_audio_price"
            case chat_video_price = "chat_video_price"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decodeIfPresent(Int.self, forKey: .id)
            uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
            name = try values.decodeIfPresent(String.self, forKey: .name)
            email = try values.decodeIfPresent(String.self, forKey: .email)
            password = try values.decodeIfPresent(String.self, forKey: .password)
            device_type = try values.decodeIfPresent(String.self, forKey: .device_type)
            device_token = try values.decodeIfPresent(String.self, forKey: .device_token)
            role = try values.decodeIfPresent(Int.self, forKey: .role)
            login_type = try values.decodeIfPresent(Int.self, forKey: .login_type)
            created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
            dob = try values.decodeIfPresent(String.self, forKey: .dob)
            country = try values.decodeIfPresent(String.self, forKey: .country)
            city = try values.decodeIfPresent(String.self, forKey: .city)
            other = try values.decodeIfPresent(String.self, forKey: .other)
            profile_image = try values.decodeIfPresent(String.self, forKey: .profile_image)
            is_online = try values.decodeIfPresent(Int.self, forKey: .is_online)
            user_status = try values.decodeIfPresent(Int.self, forKey: .user_status)
            phone = try values.decodeIfPresent(String.self, forKey: .phone)
            remember_token = try values.decodeIfPresent(String.self, forKey: .remember_token)
            updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
            chat_price = try values.decodeIfPresent(Double.self, forKey: .chat_price)
            chat_audio_price = try values.decodeIfPresent(Double.self, forKey: .chat_audio_price)
            chat_video_price = try values.decodeIfPresent(Double.self, forKey: .chat_video_price)
        }

    }
}
