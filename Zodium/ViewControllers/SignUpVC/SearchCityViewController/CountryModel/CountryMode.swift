//
//  CountryMode.swift
//  Zodium
//
//  Created by tecH on 12/10/21.
//

import Foundation
struct  CountrySearchModelDataSave: Codable {
    let success : Bool?
    let code : Int?
    let message : String?
    let body : [CountrySearchBody]?

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
        body = try values.decodeIfPresent([CountrySearchBody].self, forKey: .body)
    }

}
struct CountrySearchBody : Codable {
    let country_id : Int?
    let country_name : String?
    let nicename : String?

    enum CodingKeys: String, CodingKey {

        case country_id = "country_id"
        case country_name = "country_name"
        case nicename = "nicename"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        country_id = try values.decodeIfPresent(Int.self, forKey: .country_id)
        country_name = try values.decodeIfPresent(String.self, forKey: .country_name)
        nicename = try values.decodeIfPresent(String.self, forKey: .nicename)
    }

}
