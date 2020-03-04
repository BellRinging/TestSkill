import UIKit
import Firebase
import Promises


public struct UserData   {
    public var id : String?
    public var user_id : String?
    public var user_name: String?
    public var firstName: String?
    public var lastName: String?
    public var email: String?
    public var photoUrl : String?
    var groups : [UserGroup]?
    var gameRecord : [GameRecord]?
    var history : [UserHistory]?
    public var fcmToken : String?
    public var name : String?
    public var balance : Int?
    public var about : String?
    public var birthday : String?
    public var gender : String?
    
    init(){
        id = ""
        user_id = ""
        user_name = "" 
        firstName = ""
        lastName = ""
        email = ""
        photoUrl = ""
        fcmToken = ""
        name = ""
        balance = 0
        about = "" 
        birthday = ""
        gender = ""
    }

}



