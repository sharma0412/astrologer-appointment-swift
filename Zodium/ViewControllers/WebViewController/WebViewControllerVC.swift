//
//  WebViewControllerVC.swift
//  Zodium
//
//  Created by tecH on 03/12/21.
//

import UIKit
import WebKit

var UserIdStripe = ""
var PublishableKey = ""

class WebViewControllerVC: UIViewController {

    var model = WebViewModelClass()
    
    @IBOutlet weak var myWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.model.delegate = self
        
        let myURL = URL(string:"https://connect.stripe.com/express/oauth/authorize?redirect_uri=https://connect.stripe.com/connect/default/oauth/test&client_id=ca_Khem7YofP1KJsM7pAx6jCFYy2xxVaUOG&state=initial")
          let myRequest = URLRequest(url: myURL!)
        myWebView.navigationDelegate = self
        myWebView.load(myRequest)
        
    }
    


    
    @IBAction func btnClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}


extension WebViewControllerVC: WKNavigationDelegate{
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print(#function)
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(#function)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
        
        print("Finished navigating to url \(webView.url?.absoluteString ?? "")")
        if webView.url?.absoluteString.contains("code") == true{
         
            
            
            let neCode = webView.url?.absoluteString ?? ""
            let tex = neCode.split(separator: "=")
              print(tex)
            let final = tex[1].split(separator: "&")
            
            print(final[0])
             
            let newCode = final[0]

            let otheruser = [Param.code: newCode, Param.grant_type: "authorization_code"] as [String : Any]
            
            self.model.callStripApi(param: otheruser, onSucssesMsg: CustomeAlertMsg.stripeFetched)
         
                
        }else{
            
        }
    }
 

    
    func separateByString(String wholeString: String, byChar char:String) -> [String] {

        let resultArray = wholeString.components(separatedBy: char)
        return resultArray
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(#function)
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(#function)
    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print(#function)
        completionHandler(.performDefaultHandling,nil)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(#function)
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print(#function)
        decisionHandler(.allow)
    }
}

extension WebViewControllerVC:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        if  msg == CustomeAlertMsg.stripeFetched {

            let stripeUserId = response["stripe_user_id"] as? String ?? ""
            let stripeUblishableKey = response["stripe_publishable_key"] as? String ?? ""
            
            UserIdStripe = response["stripe_user_id"] as? String ?? ""
            PublishableKey = response["stripe_publishable_key"] as? String ?? ""
            
            print(stripeUserId)
            print(stripeUblishableKey)
            
            navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    func onFailure(msg: String) {
        print(msg)
        Alert.showSimple(msg)
    }
    
    
    
}
