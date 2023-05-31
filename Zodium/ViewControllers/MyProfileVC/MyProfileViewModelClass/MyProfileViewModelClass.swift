//
//  MyProfileViewModelClass.swift
//  Zodium
//
//  Created by tecH on 15/10/21.
//

import Foundation
import UIKit

class MyProfileViewModelClass{
    
    var delegate : ResponseProtocol?
    func notificationApi(onSucssesMsg:String){
        LoaderClass.shared.loadAnimation()
        APIClient.postAuth(url: .notification, parameters: [:], method: .get, contentType: .applicationJson, authorizationToken: true) { (response) in
            print(response)
            LoaderClass.shared.stopAnimation()
            if isSuccess(json: response){
                self.delegate?.onSucsses(msg: "Notification Fetch", response: response)
            }else{
                self.delegate?.onFailure(msg: response["message"]  as? String ?? "")
            }
        } failureHandler: { (response) in
            print(response)
            LoaderClass.shared.stopAnimation()
            if let msg = response["error"] as? String{
                self.delegate?.onFailure(msg: msg)
            }
        }
    }
    func myDetailsdApi(onSucssesMsg:String){
        LoaderClass.shared.loadAnimation()
        APIClient.postAuth(url: .myDetails, parameters: [:], method: .get, contentType: .applicationJson, authorizationToken: true) { (response) in
            print(response)
            LoaderClass.shared.stopAnimation()
            if isSuccess(json: response){
                self.delegate?.onSucsses(msg: onSucssesMsg, response: response)
            }else{
                self.delegate?.onFailure(msg: response["message"]  as? String ?? "")
            }
        } failureHandler: { (response) in
            print(response)
            LoaderClass.shared.stopAnimation()
            if let msg = response["error"] as? String{
                self.delegate?.onFailure(msg: msg)
            }
        }
    }
    
    func updateProfileApi(param: [String:Any],onSucssesMsg:String){
        LoaderClass.shared.loadAnimation()
        APIClient.postAuth(url: .userUpdateProfile, parameters: param, method: .post, contentType: .applicationJson, authorizationToken: true) { (response) in
            print(response)
            LoaderClass.shared.stopAnimation()
            if isSuccess(json: response){
                self.delegate?.onSucsses(msg: onSucssesMsg, response: response)
            }else{
                self.delegate?.onFailure(msg: response["message"]  as? String ?? "")
            }
        } failureHandler: { (response) in
            print(response)
            LoaderClass.shared.stopAnimation()
            if let msg = response["error"] as? String{
                self.delegate?.onFailure(msg: msg)
            }
        }
    }
    
    func updateProfilePhoto( image: [UIImage],onSucssesMsg:String){
        APIClient.postMultiPartAuth3(url: .updateProfilePicture,jsonObject: [:], files: image, authorizationToken: true, refreshToken: false) { (response) in
                print(response)
                if isSuccess(json: response){
                    self.delegate?.onSucsses(msg: onSucssesMsg, response: response)
                }else{
                    self.delegate?.onFailure(msg: response["imageUploadDone"]  as? String ?? "")
                }
            } failureHandler: { (response) in
                print(response)
                if let msg = response["message"] as? String{
                self.delegate?.onFailure(msg: msg)
                }
            }

        }
    
    
    
}
