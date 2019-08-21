import UIKit
import Firebase
import Promises

struct Game: Codable{
    var game_id : String
    var group_id : String
    var location : String
    var date : String
    var period : String
    var result : [String:Int]
    var players : [String:String]
}

extension Game {
    
    static func delete(id : String ) -> Promise<Void> {
        let p = Promise<Void> { (resolve , reject) in
            let db = Firestore.firestore()
            db.collection("games").document(id).delete { (err) in
                guard err == nil  else {
                     return reject(err!)
                 }
                print("delete : \(id)")
                return resolve(())
            }
        }
        return p
    }
    
    static func getAllItem() -> Promise<[Game]> {
        let p = Promise<[Game]> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("games")
            var groups : [Game] = []
            ref.getDocuments { (snap, err) in
                guard err == nil  else {
                    return reject(err!)
                }
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
    
     func updateResult(playerId : String , value : Int ) -> Promise<Game> {
             
          return Promise<Game> { (resolve , reject) in
              let db = Firestore.firestore()
              let data = ["result.\(playerId)": FieldValue.increment(Int64(value))]
              let ref = db.collection("games").document(self.game_id)
              ref.updateData(data ) { (err) in
                  guard err == nil  else {
                      return reject(err!)
                  }
                  resolve(self)
              }
          }
      }
}
