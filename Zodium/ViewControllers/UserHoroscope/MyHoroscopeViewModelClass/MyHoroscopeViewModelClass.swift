//
//  MyHoroscopeViewModelClass.swift
//  Zodium
//
//  Created by tecH on 21/10/21.
//

import Foundation
class MyHoroscopeViewModelClass{
    
    var delegate : ResponseProtocol?
    
    func horoscopeListdApi(onSucssesMsg:String){
        LoaderClass.shared.loadAnimation()
        APIClient.postAuth(url: .horoscopeList, parameters: [:], method: .get, contentType: .applicationJson, authorizationToken: true) { (response) in
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
