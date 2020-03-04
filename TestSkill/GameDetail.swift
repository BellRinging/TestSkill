import UIKit
import Promises
import Firebase

struct GameDetail : Codable {
    let id : String
    let gameId : String
    let fan : Int
    let value  : Int
    let winnerAmount  : Int
    let loserAmount  : Int
    let whoLose : [String]
    let whoWin  : [String]
    let winType : String
    let byErrorFlag : Int
    let repondToLose : Int
    
}


extension GameDetail {
    
    static func delete(id : String ) -> Promise<Void> {
        let p = Promise<Void> { (resolve , reject) in
            let db = Firestore.firestore()
            db.collection("gameDetails").document(id).delete { (err) in
                guard err == nil  else {
                     return reject(err!)
                 }
                print("delete gameDetails: \(id)")
                return resolve(())
            }
        }
        return p
    }
    
    static func getById(id: String) throws -> Promise<GameDetail>  {
        let p = Promise<GameDetail> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("gameDetails").document(id)
            ref.getDocument { (snapshot, err) in
                if let err = err{
                    reject(err)
                }
                guard let dict = snapshot?.data() else {return}
                do {
                    let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    let group = try JSONDecoder.init().decode(GameDetail.self, from: data)
                    resolve(group)
                }catch{
                    reject(error)
                }
            }
        }
        return p
    }
    
    static func getAllItem() -> Promise<[GameDetail]> {
        let p = Promise<[GameDetail]> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("gameDetails")
            var groups : [GameDetail] = []
            ref.getDocuments { (snap, err) in
                guard let documents = snap?.documents else {return}
                for doc in documents {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                        let  group = try JSONDecoder.init().decode(GameDetail.self, from: data)
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
    
    static func getAllItemById(gameId : String ,pagingSize:Int=40, lastDoc:DocumentSnapshot? = nil) -> Promise<([GameDetail],DocumentSnapshot?)> {
         let p = Promise<([GameDetail],DocumentSnapshot?)> { (resolve , reject) in
             let db = Firestore.firestore()
             let ref = db.collection("gameDetails")
            var query = ref.limit(to: pagingSize)
            query = query.order(by: "gameDetails", descending: true)
            query = query.whereField("gameId", arrayContains: gameId)
            if let lastDoc = lastDoc {
                query = query.start(afterDocument: lastDoc)
            }
            
             var groups : [GameDetail] = []
             ref.getDocuments { (snap, err) in
                 guard let documents = snap?.documents else {return}
                let lastDoc : DocumentSnapshot? = documents.last
                 for doc in documents {
                     do {
                         let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                         let  group = try JSONDecoder.init().decode(GameDetail.self, from: data)
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
    
    func save() -> Promise<GameDetail> {
           
        return Promise<GameDetail> { (resolve , reject) in
            let db = Firestore.firestore()
            let encoded = try! JSONEncoder.init().encode(self)
            let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
            let ref = db.collection("gameDetails").document(self.id)
            ref.setData(data as! [String : Any]) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
                print("Save gamedetail \(self.id)")
                resolve(self)
            }
       
        }
    }
}
