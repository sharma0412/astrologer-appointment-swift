//
//  SearchModel.swift
//  Zodium
//
//  Created by tecH on 12/10/21.
//

import Foundation
struct CitySearchModelDataSave : Codable {
    let success : Bool?
    let code : Int?
    let message : String?
    let body : [CitySeachBody]?

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
        body = try values.decodeIfPresent([CitySeachBody].self, forKey: .body)
    }

}
struct CitySeachBody : Codable {
    let city_id : Int?
    let country_id : Int?
    let city_name : String?

    enum CodingKeys: String, CodingKey {

        case city_id = "city_id"
        case country_id = "country_id"
        case city_name = "city_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        city_id = try values.decodeIfPresent(Int.self, forKey: .city_id)
        country_id = try values.decodeIfPresent(Int.self, forKey: .country_id)
        city_name = try values.decodeIfPresent(String.self, forKey: .city_name)
    }

}
