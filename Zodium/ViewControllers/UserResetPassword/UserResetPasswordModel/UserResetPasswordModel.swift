//
//  UserResetPasswordModel.swift
//  Zodium
//
//  Created by tecH on 25/10/21.
//

import Foundation
struct resetPaswordSave : Codable {
    let success : Bool?
    let code : Int?
    let message : String?
    let body : ResetPBody?

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
        body = try values.decodeIfPresent(ResetPBody.self, forKey: .body)
    }

}
struct ResetPBody : Codable {

    enum CodingKeys:  CodingKey {

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
    }

}
