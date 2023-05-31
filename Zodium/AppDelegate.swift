//
//  AppDelegate.swift
//  Zodium
//
//  Created by tecH on 11/10/21.
//

import UIKit
import UserNotifications
import Firebase
import CallKit
import Firebase
import FirebaseMessaging
import FirebaseAnalytics
import JitsiMeetSDK


var appDeviceToken = "111"
@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {
    
    
    var window: UIWindow?
    var senderName = ""
    var senderID = ""
    var recevierId = ""
    var chatId = 0
    var roomIdd = ""
    var type = ""
    var image = ""
    var jitsiMeetView: JitsiMeetView?
    var pipViewCoordinator: PiPViewCoordinator?
    var notificationIncoming: VoipNotificationIncoming?
    var callerID = 0
    var channelFinalId = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        SocketHelperss.shared.establishConnection()

        Callkit.sharedInstance.uuid = UUID()
//        notificationSection(application)

        let center = UserNotifications.UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
//        UNUserNotificationCenter.current().delegate = self

        application.registerForRemoteNotifications()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                
                appDeviceToken = token
                
                print("TOKEN-------\(token)")
                //self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
            }
        }
        return true
        || JitsiMeet.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions ?? [:] )
    }



    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("userNotificationCenter: didReceive")
        let userInfo = notification.request.content.userInfo

        guard let json = userInfo[AnyHashable("message")] as? String else { return }
        print("FINAL RESPONSE IS HERE===============\(json)")
        if json.contains("room_id"){
            let dict = convertToDictionary(text: json)
            if let channelID = dict{
                if let callID = channelID["receiver_id"] as? String {
                    recevierId = callID
                }
                if let callID = channelID["sender_id"] as? String {
                    senderID = callID
                }
                if let callID = channelID["chat_id"] as? Int {
                    chatId = callID
                    SocketHelperss.shared.getCallAcceptReject(call_id: callID) { (response) in
                        print(response)
                        if response.count > 0 {
                            if let data = response as? [[String:Any]]{
                                print("calling api is here \(data)")
                                if let status = data[0]["success"] as? Int{
                                    if status == 200{
                                        if let body = data[0]["body"] as? String{
                                            if body == "2" || body == "3"{
                                                self.jitsiMeetView?.leave()
                                                self.pipViewCoordinator?.hide()
                                                Callkit.sharedInstance.dismissCallkitUIOnEndCall()
                                            }
                                        }
                                    }else{
                                        self.jitsiMeetView?.leave()
                                        self.pipViewCoordinator?.hide()
                                        Callkit.sharedInstance.dismissCallkitUIOnEndCall()
                                    }
                                }
                            }
                        }
                    }
                }
                
                if let chanalId = channelID["room_id"] as? String{
                    roomIdd = chanalId
                    let notificationIncoming = Singleton.shared.addVoipNotToNotificationModel(dictResp: dict!)
                    self.notificationIncoming = notificationIncoming
                    self.checkOpponentEndCallOrNot(notificationContent: notificationIncoming)
                    Callkit.sharedInstance.notificationContent = notificationIncoming
                    Callkit.sharedInstance.sendCall(notification: notificationIncoming)
                    Callkit.sharedInstance.closureDidAnswerCall = { notification in
                        DispatchQueue.main.async {
                            self.onCallAccept(notificationIncoming: notification)
                            print(notification)
                        }
                    }
                    Callkit.sharedInstance.closureDidCutOpponentCall = { [self] notification in
                        print(notification)
                        self.onCallReject(notificationIncoming: notification, callstatus: "2")
                    }
                    
                }else{
                    return completionHandler([.alert, .sound, .badge])
                }
            }
        }else{
            return completionHandler([.alert, .sound, .badge])

        }

//        let homeVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "callReciveScreenVC") as! callReciveScreenVC
//        homeVC.callId = "\(chatId)"
//        homeVC.senderId = senderID
//        homeVC.receiverId = recevierId
//        homeVC.type = type
//        homeVC.name = senderName
//        homeVC.image = image
//        let navC = UINavigationController(rootViewController: homeVC)
//        navC.navigationBar.isHidden = true
//        UIApplication.shared.windows.first?.rootViewController = navC
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        let userInfo = userInfo

        guard let json = userInfo[AnyHashable("message")] as? String else { return }
        print("FINAL RESPONSE IS HERE===============\(json)")
            let dict = convertToDictionary(text: json)
            if let channelID = dict{
                if let callID = channelID["receiver_id"] as? String {
                    recevierId = callID
                }
                if let callID = channelID["sender_id"] as? String {
                    senderID = callID
                }
                if let callID = channelID["chat_id"] as? Int {

                    callerID = callID
                    SocketHelperss.shared.getCallAcceptReject(call_id: callID) { (response) in
                        print(response)
                        if response.count > 0 {
                            if let data = response as? [[String:Any]]{
                                print("calling api is here \(data)")
                                if let status = data[0]["success"] as? Int{
                                    if status == 200{
                                        if let body = data[0]["body"] as? String{
                                            if body == "2" || body == "3"{
                                                self.jitsiMeetView?.leave()
                                                self.pipViewCoordinator?.hide()
                                                Callkit.sharedInstance.dismissCallkitUIOnEndCall()
                                            }
                                        }
                                    }else{
                                        self.jitsiMeetView?.leave()
                                        self.pipViewCoordinator?.hide()
                                        Callkit.sharedInstance.dismissCallkitUIOnEndCall()
                                    }
                                }
                            }
                        }
                    }
                }
                if let chanalId = channelID["channel_id"] as? String{
                    channelFinalId = chanalId
                    let notificationIncoming = Singleton.shared.addVoipNotToNotificationModel(dictResp: dict!)
                    self.notificationIncoming = notificationIncoming
                    self.checkOpponentEndCallOrNot(notificationContent: notificationIncoming)
                    Callkit.sharedInstance.notificationContent = notificationIncoming
                    Callkit.sharedInstance.sendCall(notification: notificationIncoming)
                    Callkit.sharedInstance.closureDidAnswerCall = { notification in
                        DispatchQueue.main.async {
                            self.onCallAccept(notificationIncoming: notification)
                            print(notification)
                            self.makeCallFromJitsi(randomChannel:  "\(String(describing: notification.room_id))" )
                        }
                    }
                    Callkit.sharedInstance.closureDidCutOpponentCall = { [self] notification in
                        print(notification)
                        self.onCallReject(notificationIncoming: notification, callstatus: "2")
                    }
                    
                }else{
                    print("no hit")
                }
            }
        
        return completionHandler(.noData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        guard let json = userInfo[AnyHashable("data")] as? String else { return }
        print("FINAL RESPONSE IS HERE===============\(json)")
        let dict = convertToDictionary(text: json)
        if let channelID = dict{
            if let callID = channelID["receiver_id"] as? String {
                recevierId = callID
            }
            if let callID = channelID["sender_id"] as? String {
                senderID = callID
            }
            if let callID = channelID["chat_id"] as? Int {
                callerID = callID
                SocketHelperss.shared.getCallAcceptReject(call_id: callID) { (response) in
                    print(response)
                    if response.count > 0 {
                        if let data = response as? [[String:Any]]{
                            print("calling api is here \(data)")
                            if let status = data[0]["success"] as? Int{
                                if status == 200{
                                    if let body = data[0]["body"] as? String{
                                        if body == "2" || body == "3"{
                                            self.jitsiMeetView?.leave()
                                            self.pipViewCoordinator?.hide()
                                            Callkit.sharedInstance.dismissCallkitUIOnEndCall()
                                        }
                                    }
                                }else{
                                    self.jitsiMeetView?.leave()
                                    self.pipViewCoordinator?.hide()
                                    Callkit.sharedInstance.dismissCallkitUIOnEndCall()
                                }
                            }
                        }
                    }
                }
            }
            if let chanalId = channelID["channel_id"] as? String{
                channelFinalId = chanalId
                let notificationIncoming = Singleton.shared.addVoipNotToNotificationModel(dictResp: dict!)
                self.notificationIncoming = notificationIncoming
                self.checkOpponentEndCallOrNot(notificationContent: notificationIncoming)
                Callkit.sharedInstance.notificationContent = notificationIncoming
                Callkit.sharedInstance.sendCall(notification: notificationIncoming)
                Callkit.sharedInstance.closureDidAnswerCall = { notification in
                    DispatchQueue.main.async {
                        self.onCallAccept(notificationIncoming: notification)
                        print(notification)
                        self.makeCallFromJitsi(randomChannel:  "\(notification.room_id)" )
                    }
                }
                Callkit.sharedInstance.closureDidCutOpponentCall = { [self] notification in
                    print(notification)
                    self.onCallReject(notificationIncoming: notification, callstatus: "2")
                }
                
            }else{
                print("no hit")
            }
        }
        
        completionHandler()
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    func getViewController(viewControllerName identifier : String)->UIViewController
    {
        let controller:UIViewController = storyBoard.instantiateViewController(withIdentifier: identifier)as UIViewController
        return controller
    }
    lazy var storyBoard:UIStoryboard = {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }()
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // Getting device token
    
    //    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    //        print("Firebase registration token: \(String(describing: fcmToken))")
    //        let dataDict:[String: String] = ["token": fcmToken ?? ""]
    //
    //        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    //        // TODO: If necessary send token to application server.
    //        // Note: This callback is fired at each app startup and whenever a new token is generated.
    //    }
    
    //func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    //
    //    let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
    //    print(deviceTokenString)
    //
    //    UserDefaults.standard.setValue(deviceTokenString, forKey: UserDefaultKey.deviceToken)
    //
    //    UserDefaults.standard.string(forKey: "deviceToken")
    //
    //  //  print(UserDefaults.standard.string(forKey: "deviceToken"))
    //}
    
    // In case of error
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
    }
    
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}
extension AppDelegate {
    // MARK: - Linking delegate methods
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return JitsiMeet.sharedInstance().application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
    
}
@available(iOS 10, *)

extension UIApplication {
    class func topViewController() -> UIViewController? {
        var topVC = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        while true {
            if let presented = topVC?.presentedViewController {
                topVC = presented
            } else if let nav = topVC as? UINavigationController {
                topVC = nav.visibleViewController
            } else if let tab = topVC as? UITabBarController {
                topVC = tab.selectedViewController
            }else {
                break
            }
        }
        return topVC
    }
}
extension AppDelegate : JitsiMeetViewDelegate{
    
    func makeCallFromJitsi(randomChannel : String){
        cleanUp()
        let jitsiMeetView = JitsiMeetView()
        jitsiMeetView.delegate = self
        self.jitsiMeetView = jitsiMeetView
        
        let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.welcomePageEnabled = false
            builder.room = randomChannel
            //builder.subject = self.notificationIncoming.caller_name
            builder.setAudioOnly(false)
           // builder.videoMuted = false
           // builder.subject = self.notificationIncoming.caller_name
            builder.setFeatureFlag("close-captions.enabled", withBoolean: false)
            builder.setFeatureFlag("pip.enabled", withBoolean: false)
            builder.setFeatureFlag("overflow-menu.enabled", withBoolean: false)
            builder.setFeatureFlag("chat.enabled", withBoolean: false)
            builder.setFeatureFlag("invite.enabled", withBoolean: false)
        }
        jitsiMeetView.join(options)
        pipViewCoordinator = PiPViewCoordinator(withView: jitsiMeetView)
        if let navVC = UIApplication.shared.keyWindow!.rootViewController! as? UINavigationController {
            let view1 = navVC.viewControllers[navVC.viewControllers.count - 1].view
            pipViewCoordinator?.configureAsStickyView(withParentView: view1)
        }
        jitsiMeetView.alpha = 0
        pipViewCoordinator?.show()
    }

    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    fileprivate func cleanUp() {
            jitsiMeetView?.removeFromSuperview()
            jitsiMeetView = nil
            pipViewCoordinator = nil
        }
    func conferenceJoined(_ data: [AnyHashable : Any]!) {
        print("CONFERENCE CALL IS JOINED SUCCESSFULLY")
        //self.stopConnectionTimer()
    }
    func onCallAccept(notificationIncoming: VoipNotificationIncoming) {
        let callId = notificationIncoming.chatId
       let call_status = "1"
        SocketHelperss.shared.emitCallAcceptReject(call_id: callId, call_type: call_status ){
            print("Call Accept Emit Done")
            self.makeCallFromJitsi(randomChannel:  "\(notificationIncoming.roomId)" )

        }
    }
    func onCallReject(notificationIncoming: VoipNotificationIncoming, callstatus: String) {
        let callId = notificationIncoming.chatId
        _ = callstatus
        SocketHelperss.shared.emitCallAcceptReject(call_id: callId, call_type: "2") {
            print("Call Reject Emit Done")
            self.jitsiMeetView?.leave()
            self.pipViewCoordinator?.hide()
            Callkit.sharedInstance.dismissCallkitUIOnEndCall()
        }
    }
    func conferenceWillJoin(_ data: [AnyHashable : Any]!) {
        Callkit.sharedInstance.dismissCallkitUIOnEndCall()
    }
    func enterPicture(inPicture data: [AnyHashable : Any]!) {
        DispatchQueue.main.async {
            self.pipViewCoordinator?.enterPictureInPicture()
        }
    }
    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        self.onCallReject(notificationIncoming: notificationIncoming!, callstatus: "2")
        self.jitsiMeetView?.leave()
        self.pipViewCoordinator?.hide()
        Callkit.sharedInstance.dismissCallkitUIOnEndCall()
    }
        
      func checkOpponentEndCallOrNot(notificationContent: VoipNotificationIncoming) {
          SocketHelperss.shared.getCallAcceptReject(call_id: notificationContent.chat_id ?? 0 ) { (dict) in
              print(dict)
            print(dict)
          }
      }
}
