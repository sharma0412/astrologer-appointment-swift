//
//  callReciveScreenVC.swift
//  Zodium
//
//  Created by tecH on 25/11/21.
//

import UIKit
import IBAnimatable
import JitsiMeetSDK
import AVKit
class callReciveScreenVC: UIViewController,JitsiMeetViewDelegate {

    @IBOutlet weak var lblCallingType: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: AnimatableImageView!
    var messageModalClass = [UserModel]()
    var callId = String()
    var name = ""
    var senderId = ""
    var receiverId = ""
    var type = ""
    var image = ""
    var randomChannel = ""
    var jitsiMeetView: JitsiMeetView?
    var pipViewCoordinator: PiPViewCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == "3"{
            lblCallingType.text = "Audio Calling..."
        }
       else if type == "4"{
            lblCallingType.text = "Video Calling..."
        }else{
            lblCallingType.text = "Calling..."
        }
        lblName.text = name
        let url = URL(string:(imageBaseUrl + image))
        imgProfile.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnGreenAction(_ sender: Any) {
        self.makeCallFromJitsi()
      // hitSocket()
    }
    @IBAction func btnRedAction(_ sender: Any) {
        self.makeCallFromJitsi()
        //hitSocketDisconnect()
        
    }
    func makeCallFromJitsi(){
       cleanUp()
        randomChannel = randomString(length: 10)
        print(randomChannel)
        if(randomChannel.count < 1) {
            return
        }
        let jitsiMeetView = JitsiMeetView()
        jitsiMeetView.delegate = self
        self.jitsiMeetView = jitsiMeetView
        
        let defaultOptions = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.welcomePageEnabled = false
            builder.room = self.randomChannel
            builder.setAudioOnly(false)
            builder.setVideoMuted(true)//            builder.videoMuted = true
            builder.setFeatureFlag("overflow-menu.enabled", withBoolean: false)
            builder.setFeatureFlag("chat.enabled", withBoolean: false)
            builder.setFeatureFlag("invite.enabled", withBoolean: false)
        }
        jitsiMeetView.join(defaultOptions)
        pipViewCoordinator = PiPViewCoordinator(withView: jitsiMeetView)
        if let navVC = UIApplication.shared.keyWindow!.rootViewController! as? UINavigationController {
            let view1 = navVC.viewControllers[navVC.viewControllers.count - 1].view
            pipViewCoordinator?.configureAsStickyView(withParentView: view1)
        }
        jitsiMeetView.alpha = 0
        pipViewCoordinator?.show()
    }
    fileprivate func cleanUp() {
        jitsiMeetView?.removeFromSuperview()
        jitsiMeetView = nil
        pipViewCoordinator = nil
    }
    func conferenceJoined(_ data: [AnyHashable : Any]!) {
        print("CONFERENCE CALL IS JOINED SUCCESSFULLY")
    }
    func conferenceWillJoin(_ data: [AnyHashable : Any]!) {
        Callkit.sharedInstance.dismissCallkitUIOnEndCall()
    }
    
    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        self.jitsiMeetView?.leave()
        self.pipViewCoordinator?.hide()
        Callkit.sharedInstance.dismissCallkitUIOnEndCall()
    }
    func enterPicture(inPicture data: [AnyHashable : Any]!) {
        DispatchQueue.main.async {
            self.pipViewCoordinator?.enterPictureInPicture()
        }
    }
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

    //MARK:- Socket for call recive
    
//    func hitSocket(){
//        SocketHelperss.shared.emitCallRequest(call_type: "1", call_id: callId){
//
//        }
//
//        SocketHelperss.shared.onCallRequest(call_type: "1", call_id: callId){(model) in
//
//            self.messageModalClass = model ?? []
//                      print("Done")
//
//
//            if model?.count ?? 0 > 0 {
//                                 if let data = model as? [[String:Any]]{
//                                     print("calling api is here \(data)")
//                                     if let status = data[0]["success"] as? Int{
//                                         if status == 200{
//                                             if let body = data[0]["body"] as? String{
//                                                 if body == "2" || body == "3"{
//                                                     self.jitsiMeetView?.leave()
//                                                     self.pipViewCoordinator?.hide()
//                                                     Callkit.sharedInstance.dismissCallkitUIOnEndCall()
//                                                 }
//                                             }
//                                         }else{
//                                             self.jitsiMeetView?.leave()
//                                             self.pipViewCoordinator?.hide()
//                                             Callkit.sharedInstance.dismissCallkitUIOnEndCall()
//                                         }
//                                     }
//                                 }
//                             }
//
//
//
//
//
//
//                      if self.messageModalClass.count == 0{
//
//                      }else if self.messageModalClass.count == 1{
//
//                          //self.tableView.reloadData()
//
//                      }
//                      LoaderClass.shared.stopAnimation()
//                  }
//        LoaderClass.shared.stopAnimation()
//
//        }
    
    //MARK:- SOCKET FOR DISCONNECT CALL
    
//    func hitSocketDisconnect(){
//        SocketHelperss.shared.emitCallRequest(call_type: "2", call_id: callId){
//            
//        }
//        
//        SocketHelperss.shared.onCallRequest(call_type: "2", call_id: callId){(model) in
//            
//            self.messageModalClass = model ?? []
//                      print("Done")
//        
//                      if self.messageModalClass.count == 0{
//          
//                      }else if self.messageModalClass.count == 1{
//          
//                          //self.tableView.reloadData()
//                             
//                      }
//                      LoaderClass.shared.stopAnimation()
//                  }
//        LoaderClass.shared.stopAnimation()
//
//        }
    
}
