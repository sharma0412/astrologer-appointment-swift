//
//  Callkit.swift
//  RG Online
//
//  Created by Apple on 22/03/21.
//

import Foundation
import CallKit
import AVFoundation
import UIKit

class Callkit : NSObject {

    static let sharedInstance = Callkit()

    var config: CXProviderConfiguration!
    var provider : CXProvider?
    var uuid: UUID!
    var closureDidAnswerCall : ((VoipNotificationIncoming) -> Void)?
    var closureDidEndCall : ((VoipNotificationIncoming) -> Void)?
    var closureDidCallMute : ((Bool) -> ())?
    var closureDidCutOpponentCall: ((VoipNotificationIncoming) -> Void)?
    var notificationContent : VoipNotificationIncoming!
    var isCallMute : Bool = false
    var isVideoCall : Bool = false
    let cxCallController = CXCallController()

    override init() {
        super.init()
        config = CXProviderConfiguration(localizedName: "Zodium")
        config.iconTemplateImageData = UIImage(named: "master_car")!.pngData()
        config.ringtoneSound = "ringtone.caf"
        config.includesCallsInRecents = false;
        config.supportsVideo = isVideoCall;
    }

    func sendCall(notification: VoipNotificationIncoming) {
        self.notificationContent = notification
        provider = CXProvider(configuration: config)
        if let provider = provider {
            provider.setDelegate(self, queue: nil)
            let update = CXCallUpdate()
            let name = notification.sender_name ?? ""
//                notification.caller_name.replacingOccurrences(of: "{", with: " ")
            update.remoteHandle = CXHandle(type: .generic, value: name)
            provider.reportNewIncomingCall(with: uuid, update: update, completion: { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        }
    }

    func receiveCall(uuid: UUID) {
        print(closureDidAnswerCall)
        if let provider = provider {
            provider.setDelegate(self, queue: nil)
            let transaction = CXTransaction(action: CXStartCallAction(call: uuid, handle: CXHandle(type: .generic, value: "Lawyer")))
            DispatchQueue.main.async {
            }
            cxCallController.request(transaction, completion: { error in
                self.closureDidAnswerCall!(self.notificationContent)
            })
        }
    }

}

extension Callkit: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        print("*****************")
        print("PROVIDER RESET")
        print("*****************")
    }

    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
        receiveCall(uuid: uuid)
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        // When opponent cut the call from Callkit UI
        action.fulfill()
        self.closureDidCutOpponentCall!(self.notificationContent)


//        SocketHelper.shared.emitCallAcceptReject(call_id: self.notificationContent.callId, call_status: "2") {
//            print("Done")
//        }
    }

    
    func providerDidBegin(_ provider: CXProvider) {
        print("*****************")
        print("PROVIDER BEGIN")
        print("*****************")
    }

    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        print("*****************")
        print("PROVIDER MUTED")
        print("*****************")
        isCallMute = action.isMuted
        //self.closureDidCallMute!(action.isMuted)
    }

    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("*****************")
        print("AVAudioSession BEGIN")
        print("*****************")
    }

    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        print("*****************")
        print("AVAudioSession END")
        print("*****************")
    }
}

extension Callkit {
    func dismissCallkitUIOnEndCall() {
        if uuid == nil {return}
        provider?.reportCall(with: uuid!, endedAt: Date(), reason: .remoteEnded)
    }
}

