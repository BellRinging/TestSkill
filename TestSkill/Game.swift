import UIKit
import Firebase
import Promises

struct Game: Codable ,Identifiable{
    var id : String
    var groupId : String
    var location : String
    var date : String
    var period : String
    var result : [String:Int]
    var playersMap : [String:String]
    var playersId : [String]
    var createDateTime : String
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
    
    static func getItemById(gameId : String) -> Promise<Game> {
        let p = Promise<Game> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("games").document(gameId)
            ref.getDocument{ (doc, err) in
                guard err == nil  else {
                    return reject(err!)
                }
                do {
                    let data = try JSONSerialization.data(withJSONObject: doc?.data(), options: .prettyPrinted)
                    let  game = try JSONDecoder.init().decode(Game.self, from: data)
                    resolve(game)
                }catch{
                    reject(error)
                }
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
    
    static func getItemWithUserId(userId : String ,pagingSize:Int=4, lastDoc:DocumentSnapshot? = nil) -> Promise<([Game],DocumentSnapshot?)> {
        let p = Promise<([Game],DocumentSnapshot?)> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("games")
            var query = ref.limit(to: pagingSize)
            query = query.order(by: "date", descending: true)
            query = query.whereField("playersId", arrayContains: userId)
            if let lastDoc = lastDoc {
                query = query.start(afterDocument: lastDoc)
            }
            var groups : [Game] = []
            query.addSnapshotListener  { (snap, err) in
                guard err == nil  else {
                    return reject(err!)
                }
                guard let documents = snap?.documents else {return}
                print("Result count : \(documents.count)")
                let lastDoc : DocumentSnapshot? = documents.last
                print("last Doc id : \(lastDoc?.documentID)")
                for doc in documents {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                        let  group = try JSONDecoder.init().decode(Game.self, from: data)
                        groups.append(group)
                    }catch{
                        reject(error)
                    }
                }
                resolve((groups,lastDoc))
            }
        }
        return p
    }
    
    func save() -> Promise<Game> {
             
          return Promise<Game> { (resolve , reject) in
              let db = Firestore.firestore()
              let encoded = try! JSONEncoder.init().encode(self)
              let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
              let ref = db.collection("games").document(self.id)
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
              let ref = db.collection("games").document(self.id)
              ref.updateData(data ) { (err) in
                  guard err == nil  else {
                      return reject(err!)
                  }
                  resolve(self)
              }
          }
      }
}
