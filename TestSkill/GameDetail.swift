import UIKit
import Promises
import Firebase

struct GameDetail : Codable {
    var id : String
    var gameId : String
    var fan : Int
    var value  : Int
    var winnerAmount  : Int
    var loserAmount  : Int
    var whoLose : [String]
    var whoWin  : [String]
    var winType : String
    var byErrorFlag : Int
    var repondToLose : Int
    var playerList : [String:String]
    var period : String
    var createDateTime : String
    var detailNo : Int
    
}


extension GameDetail {
    
    func delete() -> Promise<Void> {
        let p = Promise<Void> { (resolve , reject) in
            let db = Firestore.firestore()
            db.collection("gameDetails").document(self.id).delete { (err) in
                guard err == nil  else {
                     return reject(err!)
                 }
                print("delete gameDetail: \(self.id)")
                return resolve(())
            }
        }
        return p
    }
    
    
    static func getLastDetailByGameId(gameId: String , detailNo : Int) -> Promise<GameDetail?>  {
        let p = Promise<GameDetail?> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("gameDetails").whereField("gameId",isEqualTo: gameId).whereField("detailNo",isEqualTo: detailNo).limit(to: 1)
            ref.getDocuments { (snapshot, err) in
                if let err = err{
                    reject(err)
                }
                
                let data = snapshot?.documents.first
           
                if let data = data {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: data.data(), options: .prettyPrinted)
                        let  group = try JSONDecoder.init().decode(GameDetail.self, from: data)
//                         print(group)
                        resolve(group)
                    }catch{
                        print(error)
                        reject(error)
                    }
                }else{
                    print("no record")
                    resolve(nil)
                }
                
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
    
    static func getAllItemById(gameId : String ) -> Promise<([GameDetail])> {
         let p = Promise<([GameDetail])> { (resolve , reject) in
             let db = Firestore.firestore()
             let ref = db.collection("gameDetails")
            let query = ref.whereField("gameId", isEqualTo: gameId).order(by: "createDateTime")
             var groups : [GameDetail] = []
             query.getDocuments  { (snap, err) in
//                print(err?.localizedDescription)
                 guard let documents = snap?.documents else {return}
//                print("item??")
                 for doc in documents {
                     do {
                         let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                         let  group = try JSONDecoder.init().decode(GameDetail.self, from: data)
                         groups.append(group)
                     }catch{
                        print(error)
                         reject(error)
                     }
                 }
                 resolve((groups))
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
