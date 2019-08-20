import UIKit
import SwiftyJSON
import Firebase
import Promises

struct GameRecord : Codable {
    let record_id : String
    let game_id : String
    var value: Int
}

extension GameRecord {
    
    func deleteGameRecord(userId : String ,docId : String ) -> Promise<Void> {
        let p = Promise<Void> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("users").document(userId).collection("gameRecords").document(docId).delete { (err) in
                guard err == nil  else {
                     return reject(err!)
                 }
                print("deleteGameRecord: \(docId)")
                return resolve(())
            }
        }
        return p
    }
    
//
//    static func delete(id : String ) -> Promise<Void> {
//        let p = Promise<Void> { (resolve , reject) in
//            let db = Firestore.firestore()
//            let ref = db.collection("users").document(id).collection("users").document(id).delete { (err) in
//                guard err == nil  else {
//                     return reject(err!)
//                 }
//                print("delete : \(id)")
//                return resolve(())
//            }
//        }
//        return p
//    }
    
    
    static func getById(userId : String , id: String) -> Promise<GameRecord> {
        let p = Promise<GameRecord> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("users").document(userId).collection("gameRecords").document(id)
            ref.getDocument { (snapshot, err) in
                guard let dict = snapshot?.data() else {return}
                let data = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                var group = try! JSONDecoder.init().decode(GameRecord.self, from: data)
                let background = DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
                background.async {
                    resolve(group)
                }
            }
        }
        return p
    }
    
    static func getAllItem(userId : String) -> Promise<[GameRecord]> {
        let p = Promise<[GameRecord]> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("users").document(userId).collection("gameRecords")
            var groups : [GameRecord] = []
            ref.getDocuments { (snap, err) in
                guard let documents = snap?.documents else {return}
                for doc in documents {
                    let data = try! JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                    var group = try! JSONDecoder.init().decode(GameRecord.self, from: data)
                    groups.append(group)
                }
                let background = DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
                background.async {
                    resolve(groups)
                }
            }
        }
        return p
    }
    
    func save(userId:String) -> Promise<GameRecord> {
           
        return Promise<GameRecord> { (resolve , reject) in
            let db = Firestore.firestore()
            
            let encoded = try! JSONEncoder.init().encode(self)
            let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
            let ref = db.collection("users").document(userId).collection("gameRecords").document(self.record_id)
            ref.setData(data as! [String : Any]) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
                resolve(self)
            }
       
        }
    }
}
