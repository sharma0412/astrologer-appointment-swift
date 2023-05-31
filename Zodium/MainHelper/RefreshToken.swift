//
//  RefreshToken.swift
//  WorkPlace
//
//  Created by tech on 24/02/21.
//

import Foundation
import UIKit
import Alamofire

struct APIClient {
    
    enum ContentType : String {
        case applicationJson = "application/json"
        case textPlain = "text/plain"
        case form = "application/x-www-form-urlencoded"
    }
    
    static var manager = Alamofire.SessionManager.default
    
    
    static func postMultiPartAuth3( url : Api,jsonObject: [String : Any] , files :[UIImage] ,authorizationToken : Bool?  = nil,refreshToken : Bool?  = nil, completionHandler: CompletionBlock? = nil, failureHandler: FailureBlock? = nil) {
        
        var headers = HTTPHeaders()
       if refreshToken == true{
            headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserRefreshToken) ?? "")"
        }else{
            if authorizationToken == true{
                headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserToken) ?? "")"
            }
        }
        
        let urlString = url.baseURl()
        let parameters: Parameters = jsonObject
        print("******URL*****\(urlString) *****Parameters*****\(parameters)")
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            for (index , file) in files.enumerated() {
                
                if ((file as? UIImage) != nil) {
                        let data = (file as? UIImage)?.jpegData(compressionQuality: 0.5)
                    multipartFormData.append(data!, withName: "profile_image", fileName:"\(NSUUID().uuidString).jpeg", mimeType: "image/jpeg")
                    
                } else  {
                  
                    let url = URL(string: (file as? String) ?? "")
                                if FileManager.default.fileExists(atPath: url?.path ?? "") {
                                    if url?.pathExtension == "MOV" {
                                        multipartFormData.append(url!, withName: "profile_image", fileName: "\(NSUUID().uuidString).mp4", mimeType: "video/mp4")
                                    }
                                } else if url?.pathExtension == "MOV" {
                                    
                                    multipartFormData.append(url!, withName: "profile_image", fileName: "\(NSUUID().uuidString).mp4", mimeType: "video/mp4")

                                    
                                //    let str = ((file as? String) ?? "").getCleanedURL()
                                  //  let sttr = str.replacingOccurrences(of: "file://", with: "")
                                  //  let data = sttr.data(using: String.Encoding.utf32)
                                //    multipartFormData.append(str!, withName: "upload_image", fileName: "\(NSUUID().uuidString).mp4", mimeType: "video/mp4")
 
                                   
                              
                    }
                }
            
                
            }
          
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            
        },
        to: urlString, headers: headers) { result  in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { _ in
                    // Print progress
                    
                })
                
                upload.responseJSON { response in
                    switch (response.result) {
                    case .success(let value):
                        
                        print("********ddf*" , value)
                        
                        if let responseData = value as? [String:Any]{
                            if let successCode = responseData["code"] as? Int{
                                if successCode == 200{
                                    completionHandler!(value as! [String : Any] )

//                                    self.refreshToken { (status) in
//                                        if status == true{
////                                            self.postMultiPartAuth(url: url, jsonObject: jsonObject, files: files, authorizationToken: authorizationToken, refreshToken: false, completionHandler: completionHandler, failureHandler: failureHandler)
//                                        }else{
////                                            let error = [Param.error : CustomeAlertMsg.someThingWentWorng]
////                                            failureHandler?(error)
//                                        }
//                                    }
//                                }else{
//                                    completionHandler!(value as! [String : Any] )
                                }
                           // }
                            }
                        }
                    case .failure(let error):
                            print(error)
                            failureHandler?([:] )
                    }
                    
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
            
        }
    }
    
    
    static func postMultiPartAuth1( url : Api,jsonObject: [String : Any] , files :[Any] ,authorizationToken : Bool?  = nil,refreshToken : Bool?  = nil, completionHandler: CompletionBlock? = nil, failureHandler: FailureBlock? = nil) {
        
        var headers = HTTPHeaders()
       if refreshToken == true{
            headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserRefreshToken) ?? "")"
        }else{
            if authorizationToken == true{
                headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserToken) ?? "")"
            }
        }
        
        let urlString = url.baseURl()
        let parameters: Parameters = jsonObject
        print("******URL*****\(urlString) *****Parameters*****\(parameters)")
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            for (index , file) in files.enumerated() {
                
                if ((file as? UIImage) != nil) {
                        let data = (file as? UIImage)?.jpegData(compressionQuality: 0.5)
                    multipartFormData.append(data!, withName: "image", fileName:"\(NSUUID().uuidString).jpeg", mimeType: "image/jpeg")
                    
                } else  {
                  
                    let url = URL(string: (file as? String) ?? "")
                                if FileManager.default.fileExists(atPath: url?.path ?? "") {
                                    if url?.pathExtension == "MOV" {
                                        multipartFormData.append(url!, withName: "image", fileName: "\(NSUUID().uuidString).mp4", mimeType: "video/mp4")
                                    }
                                } else if url?.pathExtension == "MOV" {
                                    
                                    multipartFormData.append(url!, withName: "image", fileName: "\(NSUUID().uuidString).mp4", mimeType: "video/mp4")

                                    
                                //    let str = ((file as? String) ?? "").getCleanedURL()
                                  //  let sttr = str.replacingOccurrences(of: "file://", with: "")
                                  //  let data = sttr.data(using: String.Encoding.utf32)
                                //    multipartFormData.append(str!, withName: "upload_image", fileName: "\(NSUUID().uuidString).mp4", mimeType: "video/mp4")
 
                                   
                              
                    }
                }
            
                
            }
          
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            
        },
        to: urlString, headers: headers) { result  in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { _ in
                    // Print progress
                    
                })
                
                upload.responseJSON { response in
                    switch (response.result) {
                    case .success(let value):
                        
                        print("********ddf*" , value)
                        
                        if let responseData = value as? [String:Any]{
                            if let successCode = responseData["code"] as? Int{
                                if successCode == 200{
                                    completionHandler!(value as! [String : Any] )

//                                    self.refreshToken { (status) in
//                                        if status == true{
////                                            self.postMultiPartAuth(url: url, jsonObject: jsonObject, files: files, authorizationToken: authorizationToken, refreshToken: false, completionHandler: completionHandler, failureHandler: failureHandler)
//                                        }else{
////                                            let error = [Param.error : CustomeAlertMsg.someThingWentWorng]
////                                            failureHandler?(error)
//                                        }
//                                    }
//                                }else{
//                                    completionHandler!(value as! [String : Any] )
                                }
                           // }
                            }
                        }
                    case .failure(let error):
                            print(error)
                            failureHandler?([:] )
                    }
                    
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
            
        }
    }
    static func postMultiPartAuth2( url : Api,jsonObject: [String : Any] , profilePic: (key: String,type: UIImage)? = nil,authorizationToken : Bool?  = nil,refreshToken : Bool?  = nil, completionHandler: CompletionBlock? = nil, failureHandler: FailureBlock? = nil) {
        
        var headers = HTTPHeaders()
        if refreshToken == true{
            headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserRefreshToken) ?? "")"
        }else{
            if authorizationToken == true{
                headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserToken) ?? "")"
            }
        }
        
        let urlString = url.baseURl()
        let parameters: Parameters = jsonObject
        print("******URL*****\(urlString) *****Parameters*****\(parameters)")
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
//            if profilePic?.type == Param.video{
//            multipartFormData.append(profilePic!.data, withName: profilePic!.key, fileName: "\(UUID().uuidString).mp4", mimeType: "video/mp4")
//            }else{
//                multipartFormData.append(profilePic!.data, withName: profilePic!.key, fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
//            }
            if profilePic?.key == "Upload_file"{
                
            }else{
                let data = profilePic?.type.jpegData(compressionQuality: 0.5)
                multipartFormData.append(data!, withName: profilePic?.key ?? "", fileName:"\(NSUUID().uuidString).jpeg", mimeType: "image/jpeg")
            }
     
//
            for (key, type) in parameters {
                multipartFormData.append("\(type)".data(using: String.Encoding.utf8)!, withName: key)

            }
            
        },
        to: urlString, headers: headers) { result  in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { _ in
                    // Print progress
                    
                })
                
                upload.responseJSON { response in
                    switch (response.result) {
                    case .success(let value):
                        
                        print("********ddf*" , value)
                        
                        if let responseData = value as? [String:Any]{
                            if let successCode = responseData["success"] as? Int{
                                if successCode == 498{
//                                    self.refreshToken { (status) in
//                                        if status == true{
////                                            self.postMultiPartAuth(url: url, jsonObject: jsonObject, profilePic: profilePic, authorizationToken: authorizationToken, refreshToken: false, completionHandler: completionHandler, failureHandler: failureHandler)
//                                        }else{
////                                            let error = [Param.error : CustomeAlertMsg.someThingWentWorng]
////                                            failureHandler?(error)
//                                        }
//                                    }
                                }else{
                                    completionHandler!(value as! [String : Any] )
                                }
                            }
                        }                                    case .failure(let error):
                            print(error)
                            failureHandler?([:] )
                    }
                    
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
            
        }
    }
    static func postAuth12( url : Api,
                          parameters  : [String : Any]  ,
                          method : HTTPMethod? = .post ,
                          contentType: ContentType? = .applicationJson,
                          authorization : (user: String, password: String)? = nil,
                          authorizationToken : Bool?  = nil,refreshToken : Bool?  = nil,
                          completionHandler: CompletionBlock? = nil,completionArrHandler: CompletionArrBlock? = nil,failureHandler: FailureBlock? = nil){
        var headers : HTTPHeaders = [
            "Content-Type": contentType!.rawValue,
            "cache-control": "no-cache"//,
//            "username" : "ajay1@marketsflow.com",
//            "password" : "UKengland10"
            ]
        
        
        if contentType! == .applicationJson {
            if authorization != nil {
                if let authorization1 = authorization {
                    if let authorizationHeader = Request.authorizationHeader(user: authorization1.user, password: authorization1.password) {
                        headers[authorizationHeader.key] = authorizationHeader.value
                    }
                }
            }
        }
        if refreshToken == true{
            headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserRefreshToken) ?? "")"
        }else{
            if authorizationToken == true{
                headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserToken) ?? "")"
              //  headers["Authorization"] = "Bearer \(Cookies.getUserToken())"

            }
        }
        
        
        
        let urlString = url.baseURl()
        print("url->",urlString)
        var somString = ""
        
        let dictionary = parameters
        
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: dictionary,
            options: .prettyPrinted
            ), let theJSONText = String(data: theJSONData,
                                        encoding: String.Encoding.ascii) {
            
            somString = theJSONText
        }
        
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.fittingroom.newtimezone.Fitzz")
        configuration.timeoutIntervalForRequest = 60 * 60 * 00
        WebServices.manager = Alamofire.SessionManager(configuration: configuration)
        
        var encodeSting : ParameterEncoding = somString
        
        if method == .get {
            encodeSting = URLEncoding.default
        }
        
        Alamofire.request(urlString, method: method!,parameters: parameters,encoding:encodeSting ,  headers:headers  )
            .responseJSON {
                response in
                switch (response.result) {
                case .success(let value):
                    
                    completionHandler!(value as! [String : Any] )
                case .failure(let error):
                    print(error)
                    failureHandler?([:] )
                }
            }
            .responseString { _ in
            }
            .responseData { response in
                if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
        }
        
        
    }
    static func deleteAuth( url : Api,
                             parameters  : [String : Any]  ,
                             method : HTTPMethod? = .post ,
                             contentType: ContentType? = .applicationJson,
                             authorization : (user: String, password: String)? = nil,
                             authorizationToken : Bool?  = nil,refreshToken : Bool?  = nil,
                             completionHandler: CompletionBlock? = nil,
                             failureHandler: FailureBlock? = nil){
            var headers : HTTPHeaders = [
                "Content-Type": "application/json",
                "cache-control": "no-cache"//,
    //            "username" : "ajay1@marketsflow.com",
    //            "password" : "UKengland10"
                ]
            
            
            if contentType! == .applicationJson {
                if authorization != nil {
                    if let authorization1 = authorization {
                        if let authorizationHeader = Request.authorizationHeader(user: authorization1.user, password: authorization1.password) {
                            headers[authorizationHeader.key] = authorizationHeader.value
                        }
                    }
                }
            }
    //        if let token = authorizationToken {
    //            headers["Authorization"] = "Bearer \(token)"
    //        }
            if refreshToken == true{
                headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserRefreshToken) ?? "")"
            }else{
                if authorizationToken == true{
                    headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserToken) ?? "")"
                }
            }
            
            
            
            let urlString = url.baseURl()
            print("******URL*****\(urlString) *****Parameters*****\(parameters)")
            var somString = ""
            
            let dictionary = parameters
            
            if let theJSONData = try?  JSONSerialization.data(
                withJSONObject: dictionary,
                options: .prettyPrinted
                ), let theJSONText = String(data: theJSONData,
                                            encoding: String.Encoding.ascii) {
                
                somString = theJSONText
            }
            
            
            let configuration = URLSessionConfiguration.background(withIdentifier: "com.fittingroom.newtimezone.Fitzz")
            configuration.timeoutIntervalForRequest = 60 * 60 * 00
            WebServices.manager = Alamofire.SessionManager(configuration: configuration)
            
            var encodeSting : ParameterEncoding = somString
            
            if method == .get {
                encodeSting = URLEncoding.default
            }
        if method == .delete {
            encodeSting = URLEncoding.default
        }
            
            Alamofire.request(urlString, method: method!,parameters: parameters,encoding:encodeSting ,  headers:headers  )
                .responseJSON {
                    response in
                    // Token may have expired. Generate a new one and retry if successful.
                 
                    switch (response.result) {
                    case .success(let value):

                        completionHandler!(value as! [String : Any] )
                        case .failure(let error):
                        print(error)
                        let error = ["error":error.localizedDescription]
                        failureHandler?(error)
                    }
                }
    //            .responseString { _ in
    //                print("YESS")
    //            }
    //            .responseData { response in
    //                if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
    //                    //print("Data: \(utf8Text)")
    //                }
    //        }
        }
    static func postAuthNew( url : Api1,
                          parameters  : [String : Any]  ,
                          method : HTTPMethod? = .post ,
                          contentType: ContentType? = .applicationJson,
                          authorization : (user: String, password: String)? = nil,
                          authorizationToken : Bool?  = nil,refreshToken : Bool?  = nil,
                          completionHandler: CompletionBlock? = nil,completionArrHandler: CompletionArrBlock? = nil,failureHandler: FailureBlock? = nil){
        
        if method == .delete{
            var headers : HTTPHeaders = [
                "Content-Type": "application/json"//,
    //            "username" : "ajay1@marketsflow.com",
    //            "password" : "UKengland10"
                ]
            if refreshToken == true{
                headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserRefreshToken) ?? "")"
            }else{
                if authorizationToken == true{
                    headers["Authorization"] = "Bearer <stripe-key>"
                  //  headers["Authorization"] = "Bearer \(Cookies.getUserToken())"

                }
            }
            
            var urlString = String()
            urlString = url.baseURl()
            print(urlString)
            
            let parameters: Parameters = parameters
            Alamofire.request(urlString, method: method!, parameters: parameters, headers : headers)
          
                .responseJSON {
                    response in
                    print(response.result)
                    switch (response.result) {
                    
                    case .success(let value):
                        if let val = value as? [[String:Any]] {
                            completionArrHandler?(val)
                        } else if let val = value as? [String:Any] {
                            completionHandler?(val)
                        } else {
                            completionHandler!(["success": value])
                        }
                    case .failure(let error):
                        print(error)
                        failureHandler?([:] )
                    }
                }
                .responseString { _ in
                }
                .responseData { response in
                    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                       print(data)
                        print("Data: \(utf8Text)")
                    }
            }
        }else{
            var headers : HTTPHeaders = [:]
            if refreshToken == true{
                headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserRefreshToken) ?? "")"
            }else{
                if authorizationToken == true{
                    headers["Authorization"] = "Bearer <stripe-key>"
                  //  headers["Authorization"] = "Bearer \(Cookies.getUserToken())"

                }
            }
            
            var urlString = String()
            urlString = url.baseURl()
            print(urlString)
            
            let parameters: Parameters = parameters
            Alamofire.request(urlString, method: method!, parameters: parameters, headers : headers)
          
                .responseJSON {
                    response in
                    print(response.result)
                    switch (response.result) {
                    
                    case .success(let value):
                        if let val = value as? [[String:Any]] {
                            completionArrHandler?(val)
                        } else if let val = value as? [String:Any] {
                            completionHandler?(val)
                        } else {
                            completionHandler!(["success": value])
                        }
                    case .failure(let error):
                        print(error)
                        failureHandler?([:] )
                    }
                }
                .responseString { _ in
                }
                .responseData { response in
                    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                       print(data)
                        print("Data: \(utf8Text)")
                    }
            }
        }
         

         
   
 
     }
    
    
    static func postAuthUser( url : Api1,
                          parameters  : [String : Any]  ,
                          method : HTTPMethod? = .post ,
                          contentType: ContentType? = .applicationJson,
                          authorization : (user: String, password: String)? = nil,
                          authorizationToken : Bool?  = nil,refreshToken : Bool?  = nil,
                          completionHandler: CompletionBlock? = nil,completionArrHandler: CompletionArrBlock? = nil,failureHandler: FailureBlock? = nil){
        
        if method == .delete{
            var headers : HTTPHeaders = [
                "Content-Type": "application/json"//,
    //            "username" : "ajay1@marketsflow.com",
    //            "password" : "UKengland10"
                ]
            if refreshToken == true{
                headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserRefreshToken) ?? "")"
            }else{
                if authorizationToken == true{
                    headers["Authorization"] = ""
                  //  headers["Authorization"] = "Bearer \(Cookies.getUserToken())"

                }
            }
            
            var urlString = String()
            urlString = url.baseURl()
            print(urlString)
            
            let parameters: Parameters = parameters
            Alamofire.request(urlString, method: method!, parameters: parameters, headers : headers)
          
                .responseJSON {
                    response in
                    print(response.result)
                    switch (response.result) {
                    
                    case .success(let value):
                        if let val = value as? [[String:Any]] {
                            completionArrHandler?(val)
                        } else if let val = value as? [String:Any] {
                            completionHandler?(val)
                        } else {
                            completionHandler!(["success": value])
                        }
                    case .failure(let error):
                        print(error)
                        failureHandler?([:] )
                    }
                }
                .responseString { _ in
                }
                .responseData { response in
                    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                       print(data)
                        print("Data: \(utf8Text)")
                    }
            }
        }else{
            var headers : HTTPHeaders = [:]
            if refreshToken == true{
                headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserRefreshToken) ?? "")"
            }else{
                if authorizationToken == true{
                    headers["Authorization"] = "Bearer <stripe-key>"
                  //  headers["Authorization"] = "Bearer \(Cookies.getUserToken())"

                }
            }
            
            var urlString = String()
            urlString = url.baseURl()
            print(urlString)
            
            let parameters: Parameters = parameters
            Alamofire.request(urlString, method: method!, parameters: parameters, headers : headers)
          
                .responseJSON {
                    response in
                    print(response.result)
                    switch (response.result) {
                    
                    case .success(let value):
                        if let val = value as? [[String:Any]] {
                            completionArrHandler?(val)
                        } else if let val = value as? [String:Any] {
                            completionHandler?(val)
                        } else {
                            completionHandler!(["success": value])
                        }
                    case .failure(let error):
                        print(error)
                        failureHandler?([:] )
                    }
                }
                .responseString { _ in
                }
                .responseData { response in
                    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                       print(data)
                        print("Data: \(utf8Text)")
                    }
            }
        }
         

         
   
 
     }
    
    static func postAuth( url : Api,
                          parameters  : [String : Any]  ,
                          method : HTTPMethod? = .post ,
                          contentType: ContentType? = .applicationJson,
                          authorization : (user: String, password: String)? = nil,
                          authorizationToken : Bool?  = nil,refreshToken : Bool?  = nil,
                          completionHandler: CompletionBlock? = nil,completionArrHandler: CompletionArrBlock? = nil,failureHandler: FailureBlock? = nil){
        
        if method == .delete{
            var headers : HTTPHeaders = [
                "Content-Type": "application/json"//,
    //            "username" : "ajay1@marketsflow.com",
    //            "password" : "UKengland10"
                ]
            if refreshToken == true{
                headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserRefreshToken) ?? "")"
            }else{
                if authorizationToken == true{
                    headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserToken) ?? "")"
                  //  headers["Authorization"] = "Bearer \(Cookies.getUserToken())"

                }
            }
            
            var urlString = String()
            urlString = url.baseURl()
            print(urlString)
            
            let parameters: Parameters = parameters
            Alamofire.request(urlString, method: method!, parameters: parameters, headers : headers)
          
                .responseJSON {
                    response in
                    print(response.result)
                    switch (response.result) {
                    
                    case .success(let value):
                        if let val = value as? [[String:Any]] {
                            completionArrHandler?(val)
                        } else if let val = value as? [String:Any] {
                            completionHandler?(val)
                        } else {
                            completionHandler!(["success": value])
                        }
                    case .failure(let error):
                        print(error)
                        failureHandler?([:] )
                    }
                }
                .responseString { _ in
                }
                .responseData { response in
                    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                       print(data)
                        print("Data: \(utf8Text)")
                    }
            }
        }else{
            var headers : HTTPHeaders = [:]
            if refreshToken == true{
                headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserRefreshToken) ?? "")"
            }else{
                if authorizationToken == true{
                    headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserToken) ?? "")"
                  //  headers["Authorization"] = "Bearer \(Cookies.getUserToken())"

                }
            }
            
            var urlString = String()
            urlString = url.baseURl()
            print(urlString)
            
            let parameters: Parameters = parameters
            Alamofire.request(urlString, method: method!, parameters: parameters, headers : headers)
          
                .responseJSON {
                    response in
                    print(response.result)
                    switch (response.result) {
                    
                    case .success(let value):
                        if let val = value as? [[String:Any]] {
                            completionArrHandler?(val)
                        } else if let val = value as? [String:Any] {
                            completionHandler?(val)
                        } else {
                            completionHandler!(["success": value])
                        }
                    case .failure(let error):
                        print(error)
                        failureHandler?([:] )
                    }
                }
                .responseString { _ in
                }
                .responseData { response in
                    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                       print(data)
                        print("Data: \(utf8Text)")
                    }
            }
        }
         

         
   
 
     }
    static func postMultiPartAuth( url : Api,jsonObject: [String : Any] , profilePic: (key: String,type:Any)? = nil,authorizationToken : Bool?  = nil,refreshToken : Bool?  = nil, completionHandler: CompletionBlock? = nil, failureHandler: FailureBlock? = nil) {
        
        var headers = HTTPHeaders()
        if refreshToken == true{
            headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserRefreshToken) ?? "")"
        }else{
            if authorizationToken == true{
                headers["Authorization"] = "Bearer \(UserDefaults.standard.value(forKey: UserDefaultKey.kUserToken) ?? "")"
            }
        }
        
        let urlString = url.baseURl()
        let parameters: Parameters = jsonObject
        print("******URL*****\(urlString) *****Parameters*****\(parameters)")
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
          
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            
        },
        to: urlString, headers: headers) { result  in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { _ in
                    // Print progress
                    
                })
                
                upload.responseJSON { response in
                    switch (response.result) {
                    case .success(let value):
                        
                        print("********ddf*" , value)
                        
                        if let responseData = value as? [String:Any]{
                            if let successCode = responseData["success"] as? Int{
                                if successCode == 498{
//                                    self.refreshToken { (status) in
//                                        if status == true{
//                                            self.postMultiPartAuth(url: url, jsonObject: jsonObject, profilePic: profilePic, authorizationToken: authorizationToken, refreshToken: false, completionHandler: completionHandler, failureHandler: failureHandler)
//                                        }else{
////                                            let error = [Param.error : CustomeAlertMsg.someThingWentWorng]
////                                            failureHandler?(error)
//                                        }
//                                    }
                                }else{
                                    completionHandler!(value as! [String : Any] )
                                }
                            }
                        }                                    case .failure(let error):
                            print(error)
                            failureHandler?([:] )
                    }
                    
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
            
        }
    }
    
    
//    static func refreshToken(completion: @escaping ((Bool) -> Void)){
//
//        APIClient.postAuth(url: .refreshToken, parameters: [:],method: .get,refreshToken: true){ (response) in
//            print(response)
//            if isSuccess(json: response) {
////                if let access_token = response[Param.access_token] as? String{
////                    UserDefaults.standard.setValue(access_token, forKey: UserDefaultKey.kUserToken)
////                }
////                if let refresh_token = response[Param.refresh_token] as? String{
////                    UserDefaults.standard.setValue(refresh_token, forKey: UserDefaultKey.kUserRefreshToken)
////                }
//                completion(true)
//            }else{
//                completion(false)
//            }
//        } failureHandler: { (error) in
//            print(error)
//            completion(false)
//        }
//
//    }
    
}





