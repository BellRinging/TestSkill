import UIKit
import SwiftyJSON

struct GameRecord {
    var game_id : String
    var value: Int
    
    init(dict : Dictionary<String, Any>){
        self.game_id = dict["game_id"] as? String ?? ""
        self.value = dict["value"] as? Int ?? 0
    }
    
   init(json : JSON) {
        self.value = json["value"] as? Int ?? 0
        self.game_id = json["game_id"] as? String ?? ""
    }
 
}
