import UIKit
import SwiftyJSON

struct History {
    var id : String
    var name: String
    var firstName: String
    var lastName: String
    var email: String
    var imageUrl : String
    
    init(dict : Dictionary<String, Any>){
        self.id = dict["id"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.imageUrl = dict["img_url"] as? String ?? ""
        self.firstName = dict["first_name"] as? String ?? ""
        self.lastName = dict["last_name"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
    }
    
    
   init(json : JSON) {
        self.id = json["id"].string ?? ""
        self.name = json["name"].string ?? ""
        self.imageUrl = json["picture"]["data"]["url"].string ?? ""
        self.firstName = json["first_name"].string ?? ""
        self.lastName = json["last_name"].string ?? ""
        self.email = json["email"].string ?? ""
    }
 
}
