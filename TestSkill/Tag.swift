import UIKit
import SwiftyJSON

struct Tag {
    var id : String
    var name : String
    var imageUrl : String
    
    
    init(dict : Dictionary<String, Any>){
        self.id = dict["id"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.imageUrl = dict["img_url"] as? String ?? ""
    }
    
    
    init(json : JSON) {
        self.id = json["id"].string ?? ""
        self.name = json["name"].string ?? ""
        self.imageUrl = json["picture"]["data"]["url"].string ?? ""
    }
    
}

