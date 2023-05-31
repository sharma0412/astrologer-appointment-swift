//
//  WebViewModelClass.swift
//  Zodium
//
//  Created by tecH on 07/12/21.
//

import Foundation
import Foundation
class WebViewModelClass{
    
    var delegate : ResponseProtocol?
    
    func callStripApi(param: [String:Any],onSucssesMsg:String){
        LoaderClass.shared.loadAnimation()
        APIClient.postAuthNew(url: .stripeEnd, parameters: param, method: .post, contentType: .applicationJson, authorizationToken: true) { (response) in
            print(response)
            LoaderClass.shared.stopAnimation()
          
                self.delegate?.onSucsses(msg: onSucssesMsg, response: response)
        
        }
        failureHandler: { (response) in
            print(response)
            LoaderClass.shared.stopAnimation()
            if let msg = response["error"] as? String{
                self.delegate?.onFailure(msg: msg)
            }
        }
    }
    
    func callStripApiTTT(param: [String:Any],onSucssesMsg:String){
        LoaderClass.shared.loadAnimation()
        APIClient.postAuthUser(url: .stripeEndUser, parameters: param, method: .post, contentType: .applicationJson, authorizationToken: true) { (response) in
            print(response)
            LoaderClass.shared.stopAnimation()
          
                self.delegate?.onSucsses(msg: onSucssesMsg, response: response)
        
        }
        failureHandler: { (response) in
            print(response)
            LoaderClass.shared.stopAnimation()
            if let msg = response["error"] as? String{
                self.delegate?.onFailure(msg: msg)
            }
        }
    }
    
      
}
