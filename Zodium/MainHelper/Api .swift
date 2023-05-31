
import Foundation

//let baseUrl  = "http://zodium.deploywork.com:4033/app/v1/"
//let imageBaseUrl = "http://zodium.deploywork.com/"
//let stripeUrl = "https://connect.stripe.com/"


let baseUrl  = "http://zodiumastro.com:4022/app/v1/"
let imageBaseUrl = "http://zodiumastro.com"
let imageBaseUrl2 = "http://zodiumastro.com/"
let stripeUrl = "https://connect.stripe.com/"


extension Api {
    func baseURl() -> String {
        
        return  baseUrl + self.rawValued()
    }
}

extension Api1 {
    func baseURl() -> String {
        
        return  "https://connect.stripe.com/" + self.rawValued()
    }
}
enum Api1: Equatable {
    
    case stripeEnd
    case stripeEndUser
    
    func rawValued() -> String {
        switch self {
        case .stripeEnd:
            return "oauth/token"
            
        case .stripeEndUser:
            return "v1/payment_methods"
      
        }
    }
}
enum Api: Equatable {
    
   
    case catagoryList
    case resetPassword
    case logIn
    case logOut
    case forgotPassword
    case myDetails
    case history
    case userFavAdv
    case userUpdateProfile
    case horoscopeList
    case create_booking
    case makeRequest
    case favUnfav
    case cityList
    case countryList
    case signUp
    case updateProfilePicture
    case editProfile
    case favList
    case refreshToken
    case sendImage
    case notification
    case timeStamp
    
    func rawValued() -> String {
        switch self {
       
        case .catagoryList:
            return "users/categoryList"
        case .userFavAdv:
            return "users/fav_adviserList"
        case .logOut:
            return "users/logout"
        case .history:
            return "users/bookingHistory"
        case .userUpdateProfile:
            return "users/updateProfile"
        case .resetPassword:
            return "users/resetPassword"
        case .updateProfilePicture:
            return "users/updateMyProfilePicture"
        case .makeRequest:
            return "users/makeRequest"
        case .myDetails:
            return "users/myDetail"
        case .favUnfav:
            return "users/is_fav_adviser"
        case .cityList:
            return "users/cityList"
        case .create_booking:
            return "users/create_booking"
        case .forgotPassword:
            return "users/forgotPassword"
        case .horoscopeList:
            return "users/horoscopeList"
        case .logIn:
            return "users/login"
        case .countryList:
            return "users/countryList"
        case .signUp:
            return "users/signUp"
        case .favList:
            return "home/favouriteList"
        case .editProfile:
            return "users/editProfile"
        case .sendImage:
            return "users/uploadFile"
        case .refreshToken:
            return ""
        case .notification:
            return "users/notificationList"
        case .timeStamp:
            return "users/bookingTimestamp"
       
        }
    }
}

func isSuccess(json : [String : Any]) -> Bool{
    if let isSucess = json["status"] as? Int {
        if isSucess == 200 {
            return true
        }
    }
    if let isSucess = json["status"] as? String {
        if isSucess == "true" {
            return true
        }
    }
    if let isSucess = json["success"] as? String {
        if isSucess == "true" {
            return true
        }
    }
    
    if let isSucess = json["success"] as? Bool {
        if isSucess == true {
            return true
        }
    }
    
    if let isSucess = json["success"] as? Int {
        if isSucess == 1 {
            return true
        }
    }
    if let isSucess = json["success"] as? Int {
        if isSucess == 200 {
            return true
        }
    if let isSucess = json["code"] as? Int {
            if isSucess == 200 {
                return true
            }
        }
    }
    return false
}

func message(json : [String : Any]) -> String{
    if let message = json["message"] as? String {
        return message
    }
    if let message = json["message"] as? [String:Any] {
        if let msg = message.values.first as? [String] {
            return msg[0]
        }
    }
    if let error = json["error"] as? String {
        return error
    }
    
    return " "
}


func isBodyCount(json : [[String : Any]]) -> Int{
    return json.count
}
