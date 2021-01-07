import UIKit
import Promises
import Firebase
import FirebaseFirestore

struct Big2GameDetail : Codable {
    var id : String
    var gameId : String
    var winnerId : String
    var whoBig2 : String?
    var actualNum : [String:Int]
    var refValue : [String:Int]
    var multipler : [String:Int]
    var period : String
    var createDateTime : String
    var detailNo : Int
    var playerId : [String]
}


extension Big2GameDetail {
    
    func delete() -> Promise<Void> {
        let p = Promise<Void> { (resolve , reject) in
            let db = Firestore.firestore()
            db.collection("big2GameDetails").document(self.id).delete { (err) in
                guard err == nil  else {
                     return reject(err!)
                 }
                print("delete big2Details: \(self.id)")
                return resolve(())
            }
        }
        return p
    }
    
    
    static func getLastDetailByGameId(gameId: String , detailNo : Int) -> Promise<Big2GameDetail?>  {
        let p = Promise<Big2GameDetail?> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("big2GameDetails").whereField("gameId",isEqualTo: gameId).whereField("detailNo",isEqualTo: detailNo).limit(to: 1)
            ref.getDocuments { (snapshot, err) in
                if let err = err{
                    reject(err)
                }
                
                let data = snapshot?.documents.first
           
                if let data = data {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: data.data(), options: .prettyPrinted)
                        let  group = try JSONDecoder.init().decode(Big2GameDetail.self, from: data)
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
            let ref = db.collection("big2GameDetails").document(id)
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
    
    static func getAllItem() -> Promise<[Big2GameDetail]> {
        let p = Promise<[Big2GameDetail]> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("big2GameDetails")
            var groups : [Big2GameDetail] = []
            ref.getDocuments { (snap, err) in
                guard let documents = snap?.documents else {return}
                for doc in documents {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                        let  group = try JSONDecoder.init().decode(Big2GameDetail.self, from: data)
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
    
    static func getAllItemById(gameId : String ) -> Promise<([Big2GameDetail])> {
         let p = Promise<([Big2GameDetail])> { (resolve , reject) in
             let db = Firestore.firestore()
             let ref = db.collection("big2GameDetails")
            let query = ref.whereField("gameId", isEqualTo: gameId).order(by: "createDateTime")
             var groups : [Big2GameDetail] = []
             query.getDocuments  { (snap, err) in
                print(err?.localizedDescription)
                 guard let documents = snap?.documents else {return}
                print("item??")
                 for doc in documents {
                     do {
                         let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                         let  group = try JSONDecoder.init().decode(Big2GameDetail.self, from: data)
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
    
    func save() -> Promise<Big2GameDetail> {
           
        return Promise<Big2GameDetail> { (resolve , reject) in
            let db = Firestore.firestore()
            let encoded = try! JSONEncoder.init().encode(self)
            let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
            let ref = db.collection("big2GameDetails").document(self.id)
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
