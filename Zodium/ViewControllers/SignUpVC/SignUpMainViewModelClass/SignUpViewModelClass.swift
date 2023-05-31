//
//  SignUpViewModelClass.swift
//  Zodium
//
//  Created by tecH on 12/10/21.
//

import Foundation
import UIKit

class SignUpViewModelClass{
    
    var delegate : ResponseProtocol?
    
    func callCatagoryListApi(param: [String:Any],onSucssesMsg:String){
        LoaderClass.shared.loadAnimation()
        APIClient.postAuth(url: .catagoryList, parameters: param, method: .get, contentType: .applicationJson, authorizationToken: true) { (response) in
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
    
    func callSearchCityListApi(param: [String:Any],onSucssesMsg:String){
        LoaderClass.shared.loadAnimation()
        APIClient.postAuth(url: .cityList, parameters: param, method: .post, contentType: .applicationJson, authorizationToken: true) { (response) in
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
    
    func callSearchCountryListApi(param: [String:Any],onSucssesMsg:String){
        LoaderClass.shared.loadAnimation()
        APIClient.postAuth(url: .countryList, parameters: param, method: .post, contentType: .applicationJson, authorizationToken: true) { (response) in
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
    
//    func callSignUpApi(param: [String:Any],onSucssesMsg:String){
//        LoaderClass.shared.loadAnimation()
//        APIClient.postAuth(url: .signUp, parameters: param, method: .post, contentType: .applicationJson, authorizationToken: true) { (response) in
//            print(response)
//            LoaderClass.shared.stopAnimation()
//            if isSuccess(json: response){
//                self.delegate?.onSucsses(msg: onSucssesMsg, response: response)
//            }else{
//                self.delegate?.onFailure(msg: response["message"]  as? String ?? "")
//            }
//        } failureHandler: { (response) in
//            print(response)
//            LoaderClass.shared.stopAnimation()
//            if let msg = response["error"] as? String{
//                self.delegate?.onFailure(msg: msg)
//            }
//        }
//    }
//
//}

func callSignUpApi(param:[String:Any], image: [UIImage],onSucssesMsg:String){
        APIClient.postMultiPartAuth1(url: .signUp, jsonObject: param, files: image, authorizationToken: false, refreshToken: false) { (response) in
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

