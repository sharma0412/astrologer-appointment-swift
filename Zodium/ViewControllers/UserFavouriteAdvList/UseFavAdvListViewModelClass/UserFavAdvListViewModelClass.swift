//
//  UserFavAdvListViewModelClass.swift
//  Zodium
//
//  Created by tecH on 27/10/21.
//

import Foundation
class UserFavAdvListViewModelClass{
    
    var delegate : ResponseProtocol?
    
    func userFavAdvListApi(onSucssesMsg:String){
        LoaderClass.shared.loadAnimation()
        APIClient.postAuth(url: .userFavAdv, parameters: [:], method: .get, contentType: .applicationJson, authorizationToken: true) { (response) in
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
