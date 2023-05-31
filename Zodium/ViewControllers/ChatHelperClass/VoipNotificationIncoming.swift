//
//  VoipNotificationIncoming.swift
//  Zodium
//
//  Created by tecH on 22/11/21.
//

import Foundation
import Foundation


enum CallStatus: Int {
    case start = 1
    case reject = 2
    case end = 3
}

class VoipNotificationIncoming {
    
    init() {
        //print("NotificationIncoming Object Created")
    }
    deinit {
        //print("NotificationIncoming Object Destroyed")
    }
        
     var room_id: String?
     var sender_id : String?
     var receiever_id : String?
     var type: String?
     var sender_name: String?
     var chat_id: Int?
    
    var receieverId : String{
        set{
            receiever_id = newValue
        }
        get{
            if receiever_id == nil{
                receiever_id = ""
            }
            return receiever_id!
        }
    }
  
    
    var roomId : String{
        set{
            room_id = "\(newValue)"
        }
        get{
            if room_id == nil{
                room_id = ""
            }
            return room_id ?? ""
        }
    }
  
    var callType : String{
        set{
            type = newValue
        }
        get{
            if type == nil{
                type = ""
            }
            return type!
        }
    }
    
    var chatId : String{
        set{
            chat_id = Int(newValue)
        }
        get{
            if chat_id == nil{
                chat_id = 0
            }
            return "\(chat_id ?? 0)"
        }
    }
}
