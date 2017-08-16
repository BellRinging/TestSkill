import UIKit

struct Post {
    let id : String
    let caption: String
    let imageUrl : String
    let creationDate : Date
    var hasLiked = false
    
    
    init(dict : Dictionary<String, Any>){
        self.id = dict["id"] as? String ?? ""
        self.caption = dict["caption"] as? String ?? ""
        self.imageUrl = dict["imageUrl"] as? String ?? ""
        let dateSince1970 = dict["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: dateSince1970)
    }
}
