//
//  UserAdvisorListPopUpViewModelClass.swift
//  Zodium
//
//  Created by tecH on 25/10/21.
//

import Foundation
class UserAdvisorListPopUpViewModelClass{
    
    var delegate : ResponseProtocol?
    
    func makeReqApi(param: [String:Any],onSucssesMsg:String){
        LoaderClass.shared.loadAnimation()
        APIClient.postAuth(url: .makeRequest, parameters: param, method: .post, contentType: .applicationJson, authorizationToken: true) { (response) in
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
    
    
    
    func callFavUnfavApi(param: [String:Any],onSucssesMsg:String){
        LoaderClass.shared.loadAnimation()
        APIClient.postAuth(url: .favUnfav, parameters: param, method: .post, contentType: .applicationJson, authorizationToken: true) { (response) in
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
    
}
