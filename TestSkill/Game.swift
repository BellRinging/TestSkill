import UIKit
import SwiftyJSON
//import FirebaseStorage
import Firebase
import Promises
//import FirebaseAuth
//import FirebaseDatabase
//import FirebaseStorage

struct Game: Codable{
    var game_id : String
    var group_id : String
    var location : String
    var date : Date
    var result : [String:Int]
    
}

extension Game {
    
    static func promise(id: String) -> Promise<Game> {
        let p = Promise<Game> { (resolve, reject) in
            let db = Firestore.firestore()
            let ref = db.collection("games").document(id)
            ref.getDocument { (snapshot, err) in
                guard let dict = snapshot?.data() else {return}
                let data = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                var game = try! JSONDecoder.init().decode(Game.self, from: data)
                let background = DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
                background.async {
                    resolve(game)
                }
            }
        }
        return p
    }
}
