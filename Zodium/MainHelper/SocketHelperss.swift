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

let kHost = "http://zodium.deploywork.com:4033/"
let kConnectUser = "7"
let kUserList = "employeeUsers"
let kReciveerList = "returnEmployeeUsers"
let kExitUser = "exitUser"
let chatRoom = "connectChatRoom"
let userLocation = "userLocation"

//let allChats = "adviserList"
let allMessage = "adviserList"
//let sendemit = "SendMessage"
    

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
}

class UserModel : NSObject{

    var createAt : String?
    var image: String?
    var name: String?
    var joinerId : String?
    var userId : Int?
    var chatId : Int?
    var room_id : Int?
    var lastMsgSenderId : Int?
//    var unreadMsg: Int?
    var lastMessaage: String?
    var receiver_Id : Int?
    var updatedAt: String?
    var cat_id: Int?

    convenience init(param : [String:Any]) {
        self.init()
        let json = JSON(param)
//        self.createAt = json["created_at"].stringValue
//        self.chatId = json["id"].intValue
//        self.joinerId = json["joiner_id"].stringValue
//        self.userId = json["user_id"].intValue
        self.cat_id = json["cat_id"].intValue
//        self.image = json["sender_image"].stringValue
////        self.unreadMsg = json["unread_msg"].intValue
//        self.name = json["chat_user_name"].stringValue
//        self.lastMessaage = json["last_msg"].stringValue
//        self.receiver_Id = json["receiver_id"].intValue
//        self.lastMsgSenderId = json["last_msg_sender_id"].intValue
//        self.updatedAt = json["updated_at"].stringValue

    }
}

class Message : NSObject{
    
    var cat_id: Int?
    var message: String?
    var senderId: Int?
    var createdAt: String?
    var msgStatus: Int?
    var updatedAt: String?
    var msg_id: Int?
    var msgType: Int?
    var back_favour_project_id: Int?
    var favour_project_id: Int?
    var p_date: String?
    var p_image: String?
    var p_title: String?
    var req_status: Int?
    var sender_id: Int?
    var receiver_id: Int?

    convenience init(param : [String:Any]) {
        self.init()
        let json = JSON(param)
        self.cat_id = json["cat_id"].intValue
        self.message = json["message"].stringValue
        self.senderId = json["sender_id"].intValue
        self.createdAt = json["created_at"].stringValue
        self.msgStatus = json["status"].intValue
        self.updatedAt = json["updated_at"].stringValue
        self.msg_id = json["id"].intValue
        self.msgType = json["msg_type"].intValue
        self.back_favour_project_id = json["back_favour_project_id"].intValue
        self.favour_project_id = json["favour_project_id"].intValue
        self.p_date = json["p_date"].stringValue
        self.p_image = json["p_image"].stringValue
        self.p_title = json["p_title"].stringValue
        self.req_status = json["req_status"].intValue
        self.sender_id = json["sender_id"].intValue
        self.receiver_id = json["receiver_id"].intValue
        

    }
}

extension SocketHelperss{

//    func emitChatList(cat_id: String,completion: () -> Void) {
//        guard let socket = manager?.defaultSocket else {
//            return
//        }
//        let param = ["cat_id": cat_id]
//        socket.emit(allChats, param)
//        completion()
//    }
//
//    func onChatList(cat_id:String,completion: @escaping (_ userList: [UserModel]?) -> Void) {
//        var modelData = [UserModel]()
//        guard let socket = manager?.defaultSocket else {
//            return
//        }
//        socket.on( "returnAdviserList" + cat_id) { [weak self] (result, ack) -> Void in
//
//            guard result.count > 0,
//                let _ = self,
//                let user = result[0] as? [String: Any],let mainData = user["body"] as? [[String: Any]]
////                let data = UIApplication.jsonData(from: mainData)
//            else {
//                    return
//            }
//            print(result)
//
//            if mainData.count > 0 {
//                modelData.removeAll()
//                for index in mainData{
//                    let model = UserModel.init(param: index)
//                    modelData.append(model)
//                }
//                completion(modelData)
//            }else{
//                completion(nil)
//            }
//        }
//
//    }

    
    
    func emitMessageList(cat_id: Int,completion: () -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }
        let param = ["cat_id": cat_id]
        socket.emit(allMessage, param)
        completion()
    }
    
    func onMessageList(cat_id:Int,completion: @escaping (_ userList: [Message]?) -> Void) {
        var messageModalClass = [Message]()
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
                messageModalClass.removeAll()
                for index in mainData{
                    let model = Message.init(param: index)
                    messageModalClass.append(model)
                }
                completion(messageModalClass)
            }else{
                completion(nil)
            }
        }
    }
  
//    func emitSendMessage(message: String, room_id:String,withNickname sender_id: String, receiver_id: String) {
//
//        guard let socket = manager?.defaultSocket else {
//            return
//        }
//        let param = ["sender_id":sender_id ,"room_id" : room_id,"message":message, "receiver_id": receiver_id]
//        print(param)
//        socket.emit("SendMessage", param)
//    }
//    func onSendMessage(room_id:String,completion: @escaping (_ messageInfo: Message?) -> Void) {
//
//        guard let socket = manager?.defaultSocket else {
//            return
//        }
//        print("outinside")
//        socket.on("returnSendMessage" + room_id) { (dataArray, socketAck) -> Void in
//
//            var messageInfo = [Message]()
//            print("inside")
//            print(dataArray)
//            guard dataArray.count > 0,
//                let user = dataArray[0] as? [String: Any],let mainData = user["body"] as? [[String: Any]]
////                let data = UIApplication.jsonData(from: mainData)
//            else {
//                    return
//            }
//
//            if mainData.count > 0 {
//                for index in mainData{
//                    let model  = Message.init(param: index)
//                    messageInfo.append(model)
//                }
//                completion(messageInfo[0])
//            }else{
//                completion(nil)
//            }
//        }
//    }
    
}
