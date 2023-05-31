//
//  chatExtensionJitsi.swift
//  RG Online
//
//  Created by Apple on 23/03/21.
//

import Foundation
import UIKit
import JitsiMeetSDK
import AVKit


extension UserChatViewController: JitsiMeetViewDelegate {
    
    func makeCallFromJitsi(){
       cleanUp()
        romId = randomString(length: 10)
        print(romId)
        if(romId.count < 1) {
            return
        }
        let jitsiMeetView = JitsiMeetView()
        jitsiMeetView.delegate = self
        self.jitsiMeetView = jitsiMeetView
        
        let defaultOptions = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.welcomePageEnabled = false
            builder.room = self.romId
            builder.setAudioOnly(false)
            builder.setVideoMuted(true)

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
}
