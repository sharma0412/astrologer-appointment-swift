//
//  SocketHelperss.swift
//  FAF
//
//  Created by tech on 09/09/21.
//

import UIKit
import Foundation
import SocketIO
import SwiftyJSON

//let kHost = "http://zodium.deploywork.com:4033/"
let kHost = "http://zodiumastro.com:4022/"

let kConnectUser = "7"
let kUserList = "employeeUsers"
let kReciveerList = "returnEmployeeUsers"
let kExitUser = "exitUser"
let chatRoom = "connectChatRoom"
let userLocation = "userLocation"

let allChats = "fav_adviserList"
let allMessage = "adviserList"
let sendemit = "SendMessage"
let homeRequest = "homeRequest"
let callUpdateStatus = "callUpdateStatus"

let callRequest = "callRequest"
let messageList = "roomMessageList"
let sendMessage = "SendMessage"
let makePayment = "makePayment"
let homeStatusUpdate = "update_homeRequest_status"

final class SocketHelperss: NSObject {
    
    static let shared = SocketHelperss()
    
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    override init() {
        super.init()
        configureSocketClient()
    }
    
    private func configureSocketClient() {
        
        guard let url = URL(string: kHost) else {
            return
        }
        
        manager = SocketManager(socketURL: url, config: [.log(false), .compress])
        
        
        guard let manager = manager else {
            return
        }
        
        socket = manager.socket(forNamespace: "/")
    }
    
    func establishConnection() {
        guard let socket = manager?.defaultSocket else{
            return
        }
        
        socket.connect()
        print("Socket is connected")
    }
    
    func closeConnection() {
        
        guard let socket = manager?.defaultSocket else{
            return
        }
        
        socket.disconnect()
        print("Socket is disconnected")
    }
    
    func joinChatRoom(employID: String,receiverID:String, completion: () -> Void) {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        let param = ["empId":employID ,"receiverID" : receiverID]
        socket.emit(chatRoom, param)
        completion()
    }
    
    func sendUserLocation(lat: String,long:String, completion: () -> Void) {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        let param = ["lat":lat ,"long" :long]
        socket.emit(userLocation, param)
        completion()
    }
    

    func leaveChatRoom(employID: String, completion: () -> Void) {
        
        guard let socket = manager?.defaultSocket else{
            return
        }
        socket.emit(kExitUser, employID)
        completion()
    }

}

extension UIApplication {
    
    static func jsonString(from object:Any) -> String? {
        
        guard let data = jsonData(from: object) else {
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    static func jsonData(from object:Any) -> Data? {
        
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        
        return data
    }
}

struct User: Codable {
    
    var id: String?
    var isConnected: Bool?
    var nickname: String?
    var firstname : String?
    var lastname : String?
    var email : String?
    var account_type : String?
    var profile_image : String?
    var isOnline: Int?
}
class UserModel1 : NSObject{
    
}

class UserModel : NSObject{

    var created_at : String?
    var image: String?
    var name: String?
    var city: String?
    var email: String?
    var user_id: String?
    var b_minute: Int?
    var b_status: Int?
    var booking_current_timestamp: String?
    var booking_id: Int?
    var adviser_id: Int?
    var b_amount: Int?
    
    var total_customer: Int?
    var total_earning: Int?
    var total_rating: Int?
    var total_review: Int?
    
    var room_id: String?
    var isOnline: Int?
    var user_stripe_id: String?
    var joinerId : String?
    var userId : Int?
    var b_type:Int?
    var profile_image:String?

    var chatId : Int?
    var message: String?
   
    var lastMsgSenderId : Int?
    
    var chat_price : Double?
    var chat_audio_price : Double?
    var chat_video_price : Double?
    var add_c_id : Int?
    var id: Int?
    
    var is_fav: String?
    var cat_id: Int?
    
//    var unreadMsg: Int?
    var lastMessaage: String?
    var receiver_Id : Int?
    var updatedAt: String?

    convenience init(param : [String:Any]) {
        self.init()
        let json = JSON(param)
        
        self.adviser_id = json["adviser_id"].intValue
        self.is_fav = json["is_fav"].stringValue
        self.chat_price = json["chat_price"].doubleValue
        self.chat_audio_price = json["chat_audio_price"].doubleValue
        self.chat_video_price = json["chat_video_price"].doubleValue
        self.add_c_id = json["add_c_id"].intValue
        self.city = json["city"].stringValue
        self.b_minute = json["b_minute"].intValue
        self.b_status = json["b_status"].intValue
        self.booking_current_timestamp = json["booking_current_timestamp"].stringValue
        self.booking_id = json["booking_id"].intValue
        self.email = json["email"].stringValue
        self.message = json["message"].stringValue
        self.b_type = json["b_type"].intValue
        self.user_stripe_id = json["user_stripe_id"].stringValue

        self.id = json["id"].intValue
        self.b_amount = json["b_amount"].intValue
        
        self.total_customer = json["total_customer"].intValue
        self.total_earning = json["total_earning"].intValue
        self.total_rating = json["total_rating"].intValue
        self.total_review = json["total_review"].intValue
        
        
        self.created_at = json["created_at"].stringValue
        self.chatId = json["id"].intValue
        self.joinerId = json["joiner_id"].stringValue
        self.cat_id = json["cat_id"].intValue
        
        self.profile_image = json["profile_image"].stringValue
        
        self.isOnline = json["is_online"].intValue
        
        self.userId = json["user_id"].intValue
        self.room_id = json["room_id"].stringValue
        self.image = json["sender_image"].stringValue
//        self.unreadMsg = json["unread_msg"].intValue
        self.name = json["name"].stringValue
        self.lastMessaage = json["last_msg"].stringValue
        self.receiver_Id = json["receiver_id"].intValue
        self.lastMsgSenderId = json["last_msg_sender_id"].intValue
        self.updatedAt = json["updated_at"].stringValue

    }
}

class Message : NSObject{
    
    var adviser_id: Int?
    var call_type : Int?
    var chat_id: Int?
    var created_at: String?
    var end_call : Int?
    var message : String?
    var room_id: String?
    var start_call: String?
    var type : Int?
    var user_id: Int?
    var user_name : String?
    var user_picture : String?

    
    convenience init(param : [String:Any]) {
        self.init()
        let json = JSON(param)
        self.adviser_id = json["adviser_id"].intValue
        self.call_type = json["call_type"].intValue
        self.chat_id = json["chat_id"].intValue
        self.created_at = json["created_at"].stringValue
        self.end_call = json["end_call"].intValue
        self.message = json["message"].stringValue
        self.room_id = json["room_id"].stringValue
        self.start_call = json["start_call"].stringValue
        self.type = json["type"].intValue
        self.user_id = json["user_id"].intValue
        self.user_name = json["user_name"].stringValue
        self.user_picture = json["user_picture"].stringValue
        
        

    }
}

extension SocketHelperss{
  
  
    func emitChatList(cat_id: String,completion: () -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }
        let param = ["cat_id":cat_id,"user_id": UserDefaults.standard.string(forKey: "Uid")]
        socket.emit("adviserList", param)
        completion()
    }
    

    
    func onChatList(cat_id:String,completion: @escaping (_ userList: [UserModel]?) -> Void) {
        var modelData = [UserModel]()
        guard let socket = manager?.defaultSocket else {
            return
        }
        socket.on("returnAdviserList\(cat_id)") { [weak self] (result, ack) -> Void in
            
            guard result.count > 0,
                let _ = self,
                let user = result[0] as? [String: Any],let mainData = user["body"] as? [[String: Any]]
//                let data = UIApplication.jsonData(from: mainData)
            else {
                    return
            }
            print(result)

            if mainData.count > 0 {
                modelData.removeAll()
                for index in mainData{
                    let model = UserModel.init(param: index)
                    modelData.append(model)
                }
                completion(modelData)
            }else{
                completion(nil)
            }
        }
        
    }
    
    
    func emitAdvFavList(user_id: String,completion: () -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }
        let param = ["user_id": UserDefaults.standard.string(forKey: "Uid")]
        socket.emit("fav_adviserList", param)
        completion()
    }
    

    func onAdvFavList(user_id:String,completion: @escaping (_ userList: [UserModel]?) -> Void) {
        var modelData = [UserModel]()
        guard let socket = manager?.defaultSocket else {
            return
        }
        socket.on("returnFav_adviserList") { [weak self] (result, ack) -> Void in
            
            guard result.count > 0,
                let _ = self,
                let user = result[0] as? [String: Any],let mainData = user["body"] as? [[String: Any]]
//                let data = UIApplication.jsonData(from: mainData)
            else {
                    return
            }
            print(result)

            if mainData.count > 0 {
                modelData.removeAll()
                for index in mainData{
                    let model = UserModel.init(param: index)
                    modelData.append(model)
                }
                completion(modelData)
            }else{
                completion(nil)
            }
        }
        
    }
    
    //MARK:- SOCKET FOR Calling
    func getCallAcceptReject(call_id:Int,completion: @escaping (_ response: [Any?]) -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }
        socket.on("returnCallStatus\(call_id)") { [weak self] (result, ack  ) -> Void in
            print(result)
            print(ack)
            
            completion(result)
        }
    }
    func emitCallAcceptReject(call_id: String,call_type:String, completion: () -> Void) {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        let param = ["call_id":call_id,"call_type" : call_type]
        socket.emit("callUpdateStatus", param)
        completion()
    }
    
    //MARK:- SOCKET FOR Calling
    func onAdvisorStatus(completion: @escaping (_ response: [Any?]) -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }
        socket.on("returnUpdate_adviser_online_offlineStatus") { [weak self] (result, ack  ) -> Void in
            print(result)
            print(ack)
            
            completion(result)
        }
    }
    func emitAdvisorStatus(adviser_id: String,status:String, completion: () -> Void) {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        let param = ["adviser_id":adviser_id,"status" : status]
        socket.emit("update_adviser_online_offlineStatus", param)
        completion()
    }
    
    
    
    func emitHomeRequest(user_id: String,role: String, completion: () -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }
        let param = ["user_id": user_id,"role": role ]
        socket.emit(homeRequest, param)
        completion()
    }
    
    
    func onAdvHomeRequest(user_id:String, role: String, completion: @escaping (_ userList: [UserModel]?) -> Void) {
        var modelData = [UserModel]()
        guard let socket = manager?.defaultSocket else {
            return
        }
        socket.on("returnHomeRequest" + (user_id)) { [weak self] (result, ack) -> Void in
            
            guard result.count > 0,
                let _ = self,
                let user = result[0] as? [String: Any],let mainData = user["body"] as? [[String: Any]]
//                let data = UIApplication.jsonData(from: mainData)
            else {
                    return
            }
            print(result)

            if mainData.count > 0 {
                modelData.removeAll()
                for index in mainData{
                    let model = UserModel.init(param: index)
                    modelData.append(model)
                }
                completion(modelData)
            }else{
                completion(nil)
            }
        }
        
    }
    
    //MARK:- hitting call request socket
    
    func getCall(receiver_id:String,completion: @escaping (_ response: [Any]?) -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }
        socket.on("returnCallRequest\(receiver_id)") { [weak self] (result,ack) -> Void in
            print(result)
            print(ack)
            completion(result)
        }
   
    }
    func emitCall(room_id: String,receiver_id:String,sender_id:String ,type : String,start_call: String, completion: () -> Void) {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        let param = ["room_id":room_id,"receiver_id" : receiver_id,"sender_id":sender_id ,"type" : type,"start_call": start_call]
        socket.emit("callRequest", param)
        
        completion()
    }
    
    

    
    
    //MARK:- message List socket
    
    func emitMessageList(user_id: String,room_id: String, completion: () -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }
        let param = ["user_id": user_id,"room_id": room_id ]
        socket.emit(messageList, param)
        completion()
    }
    
    func onMessageList(user_id:String,room_id: String, completion: @escaping (_ userList: [Message]?) -> Void) {
        var modelData = [Message]()
        guard let socket = manager?.defaultSocket else {
            return
        }
        socket.on("returnRoomMessageList") { [weak self] (result, ack) -> Void in
            
            guard result.count > 0,
                let _ = self,
                let user = result[0] as? [String: Any],let mainData = user["body"] as? [[String: Any]]
//                let data = UIApplication.jsonData(from: mainData)
            else {
                    return
            }
            print(result)

            if mainData.count > 0 {
                modelData.removeAll()
                for index in mainData{
                   // let model = UserModel.init(param: index)
                    let model = Message.init(param: index)
                    
                    modelData.append(model)
                }
                completion(modelData)
            }else{
                completion(nil)
            }
        }
        
    }
    
    //MARK:- send Message
    
    func emitSendMessage(user_id: String,room_id: String,adviser_id: String,message: String,type: String, completion: () -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }
        let param = ["user_id": user_id,"room_id": room_id,"adviser_id": adviser_id,"message": message,"type": type]
        socket.emit(sendMessage, param)
        completion()
    }
    
    func onSendMessage(user_id:String,room_id: String,adviser_id: String,message: String,type: String, completion: @escaping (_ userList: [Message]?) -> Void) {
        var modelData = [Message]()
        guard let socket = manager?.defaultSocket else {
            return
        }
        socket.on("returnSendMessage"+"\(room_id)") { [weak self] (result, ack) -> Void in
            
            guard result.count > 0,
                let _ = self,
                let user = result[0] as? [String: Any],let mainData = user["body"] as? [[String: Any]]
//                let data = UIApplication.jsonData(from: mainData)
            else {
                    return
            }
            print(result)

            if mainData.count > 0 {
                modelData.removeAll()
                for index in mainData{
                    let model = Message.init(param: index)
                    modelData.append(model)
                }
                completion(modelData)
            }else{
                completion(nil)
            }
        }
        
    }
    
    
    
    //MARK- advisor status Update
    
    func emitHomeStatusUpdate(user_id: String,status: String,booking_id: String,id: String,b_current_timestamp: String, completion: () -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }
        let param = ["user_id": user_id,"status": status,"booking_id": booking_id,"id": id,"booking_current_timestamp": b_current_timestamp]
        socket.emit(homeStatusUpdate, param)
        completion()
    }

    func onHomeStatusUpdate(user_id: String,status: String,booking_id: String,id: String,b_current_timestamp: String, completion: @escaping (_ userList: [UserModel]?) -> Void) {
        var modelData = [UserModel]()
        guard let socket = manager?.defaultSocket else {
            return
        }
        socket.on("returnUpdate_homeRequest_status" + booking_id) { [weak self] (result, ack) -> Void in
            
            guard result.count > 0,
                let _ = self,
                let user = result[0] as? [String: Any],let mainData = user["body"] as? [[String: Any]]
//                let data = UIApplication.jsonData(from: mainData)
            else {
                    return
            }
            print(result)

            if mainData.count > 0 {
                modelData.removeAll()
                for index in mainData{
                    let model = UserModel.init(param: index)
                    modelData.append(model)
                }
                completion(modelData)
            }else{
                completion(nil)
            }
        }
        
    }
    
    //MARK:- make Payment Socket
    
    func emitMakePayment(user_id: String,status: String,booking_id: String,payment_id: String,curr_time: String,adviser_id: String,user_stripe_id:String,booking_amount: String, completion: () -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }
        let param = ["user_id": user_id,"status": status,"booking_id": booking_id,"payment_id": payment_id,"curr_time": curr_time,"adviser_id": adviser_id,"user_stripe_id":user_stripe_id,"booking_amount":booking_amount]
        socket.emit("makePayment", param)
        completion()
    }
    
    
    func onMakePayment(booking_id: String,completion: @escaping (_ userList: String,_ success:Int) -> Void) {
        var modelData = String()
        var succ = Int()
        guard let socket = manager?.defaultSocket else {
            return
        }
        socket.on("returnMakePayment" + booking_id) { [weak self] (result, ack) -> Void in
print(result)
            let user = result[0] as? [String:Any]
            let mssssg = user?["body"] as? String

            let msssg = user?["success"] as? Int
                    if msssg == 200 {
                        modelData = mssssg ?? ""
                        succ = msssg ?? 0
                        completion(modelData,succ)
                    }else{
                        completion("",0)
                    }
        
            print(result)

        }
        
    }
    
    
}
