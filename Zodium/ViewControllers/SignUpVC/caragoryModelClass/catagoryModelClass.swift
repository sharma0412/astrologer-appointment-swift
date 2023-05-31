//
//  catagoryModelClass.swift
//  Zodium
//
//  Created by tecH on 12/10/21.
//

import Foundation
 
struct CatagorySaveData : Codable {
    let success : Bool?
    let code : Int?
    let message : String?
    let body : [CatBody]?

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
        body = try values.decodeIfPresent([CatBody].self, forKey: .body)
    }

}

struct CatBody : Codable {
    let cat_id : Int?
    let cat_name : String?
    let cat_desc : String?
    let cat_image : String?
    let created_at : String?

    enum CodingKeys: String, CodingKey {

        case cat_id = "cat_id"
        case cat_name = "cat_name"
        case cat_desc = "cat_desc"
        case cat_image = "cat_image"
        case created_at = "created_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cat_id = try values.decodeIfPresent(Int.self, forKey: .cat_id)
        cat_name = try values.decodeIfPresent(String.self, forKey: .cat_name)
        cat_desc = try values.decodeIfPresent(String.self, forKey: .cat_desc)
        cat_image = try values.decodeIfPresent(String.self, forKey: .cat_image)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
    }

}
