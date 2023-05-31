//
//  Singletone.swift
//  TakeChargeNxt
//
//  Created by IOS on 14/01/20.
//  Copyright © 2020 tecHangouts. All rights reserved.
//

import Foundation

class Singleton: NSObject {
   
    static let shared = Singleton()
    var isSetting : Bool?
    
    var recipieTitle: String?
    var recipieDescription: String?
    var recipieServes:String?
    var recipieImage:String?
    var recipieVideo:String?
    var recipiePrepareTime:String?
    var recipieCookingTime:String?
    var recipieCalories:Int?
    var recipieDifficulty:String?
    var recipieCusine:Int?
    var chatPrice:Int?
    var chatAudioPrice: Int?
    var chatVideoPrice: Int?
   // var recipieIngredients:[ingredients]
   // var recipieSteps:[String?]
    
//    struct ingredients {
//
//     let ingredient_name : String?
//     let ingredient_quantity : String?
//
//    }
    
    func addVoipNotToNotificationModel(dictResp: [String:Any]) -> VoipNotificationIncoming {
        
        print(dictResp)
        
        let notificationModel = VoipNotificationIncoming()
        if let room_id = dictResp["room_id"] as? String {
            notificationModel.room_id = room_id
        }
        if let sender_id = dictResp["sender_id"] as? String {
                notificationModel.sender_id = sender_id
        }
        if let receiver_id = dictResp["reciever_id"] as? String {
                notificationModel.receieverId = receiver_id
        }
        if let call_type = dictResp["call_type"] as? String {
            notificationModel.callType = call_type
        }
        if let sender_name = dictResp["sender_name"] as? String {
            notificationModel.sender_name = sender_name
        }
        if let chat_id = dictResp["chat_id"] as? Int {
            notificationModel.chat_id = chat_id
        }

        return notificationModel
    }
    
    private override init() {
        super.init()
        
    }
    
    // MARK:- Variables
 
    
}
