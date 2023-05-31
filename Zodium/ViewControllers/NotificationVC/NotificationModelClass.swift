//
//  NotificationModelClass.swift
//  Zodium
//
//  Created by DR.MAC on 08/12/21.
//

import Foundation
struct NotificationModelClass : Codable {
    var created_at,msg : String?
    var id,sender_id,user_id: Int?
}
  typealias notificationModelClass = [NotificationModelClass]
