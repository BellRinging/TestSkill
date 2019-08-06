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
    

    static func getAllItem() -> Promise<[Game]> {
        let p = Promise<[Game]> { (resolve, reject) in
            let db = Firestore.firestore()
            let ref = db.collection("games")
            var groups : [Game] = []
            ref.getDocuments { (snap, err) in
                //                print("err : \(err)")
                guard let documents = snap?.documents else {return}
                for doc in documents {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                        let  group = try JSONDecoder.init().decode(Game.self, from: data)
                        groups.append(group)
                    }catch{
                        reject(error)
                    }
                }
                resolve(groups)
            }
        }
        return p
    }
    
    func save() -> Promise<Game> {
             
          return Promise<Game> { (resolve , reject) in
              let db = Firestore.firestore()
              
              let encoded = try! JSONEncoder.init().encode(self)
              let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
              let ref = db.collection("games").document(self.game_id)
              ref.setData(data as! [String : Any]) { (err) in
                  guard err == nil  else {
                      return reject(err!)
                  }
                  resolve(self)
              }
         
          }
      }
}
