//
//  MyHoroscopeModelClass.swift
//  Zodium
//
//  Created by tecH on 21/10/21.
//

import Foundation
struct horoDataSave : Codable {
    let success : Bool?
    let code : Int?
    let message : String?
    let body : [HoroBody]?

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
        body = try values.decodeIfPresent([HoroBody].self, forKey: .body)
    }

}
import Foundation
struct HoroBody : Codable {
    let id : Int?
    let h_image : String?
    let h_name : String?
    let h_description : String?
    let created_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case h_image = "h_image"
        case h_name = "h_name"
        case h_description = "h_description"
        case created_at = "created_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        h_image = try values.decodeIfPresent(String.self, forKey: .h_image)
        h_name = try values.decodeIfPresent(String.self, forKey: .h_name)
        h_description = try values.decodeIfPresent(String.self, forKey: .h_description)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
    }

}
