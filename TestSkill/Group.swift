import UIKit
import SwiftyJSON

struct UserGroup {
    var group_id : String
    var group_name: String
    
    init(dict : Dictionary<String, Any>){
        self.group_id = dict["group_id"] as? String ?? ""
        self.group_name = dict["group_name"] as? String ?? ""
    }
    
    
   init(json : JSON) {
        self.group_id = json["group_id"].string ?? ""
        self.group_name = json["group_name"].string ?? ""
    }
 
}
