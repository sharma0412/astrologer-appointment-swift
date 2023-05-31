//
//  Constants.swift
//  TakeChargeNxt
//
//  Created by IOS on 07/01/20.
//  Copyright © 2020 tecHangouts. All rights reserved.
//

import Foundation
import UIKit

var offset : Int = 0
var earningOffset : Int = 0

struct NotificationName {
    static let kSideMenuOpen = "SideMenuOpen"
}

struct UserDefaultKey {
    static let kDeviceToken = "DeviceToken"
    static let kLoginSwitch = "LoginSwitch"
    static let kUserID      = "kUserID"
    static let kUserToken   = "Token"
    static let deviceToken = "deviceToken"
    static let kUserRefreshToken   = "refreshToken"
    static let kUserName    = "user_name"
    static let kUserMobile  = "user_mobile"
    static let kUserEmail   = "user_email"
    static let kUserMobCode = "user_country_code"
    static let kUserRole    = "role"
}



struct CustomeAlertMsg {

   // static let singleRecipieReview = "single recipie Review Fetched"
    
    static let catagoryListFetched = "Catagory List Fetched"
    static let timeStampMessage = "Time stamp get successfully"
    static let searchCityListFetched = "City List Fetched"
    static let searchCountryListFetched = "Country List Fetched"
    static let signupFetched = "SignUp Sucessfully"
    static let forgotPassword = "forgot password fetched"
    static let logIn = "LogIn Sucessfully"
    static let history = "History fetched sucessfully"
    static let logOut = "LogOut Sucessfully"
    static let favUn = "fav/unfav sucessfully"
    static let reset = "Password reset sucessfully"
    static let booking = "booked Sucessfully"
    static let stripeFetched = "stripe fetched"
    static let myDetails = "My Details Fetched"
    static let favAdvList = "FavUserListFetched"
    static let userProfileUpdate = "profile update sucessfully"
    static let advImgUpdate = "profile photo updated sucessfully"
    static let horoscopeFetched = "horoscope data save"
    
    
    
}



