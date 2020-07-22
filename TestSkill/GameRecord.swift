import UIKit
import Firebase
import Promises
import FirebaseFirestore

struct GameRecord : Codable ,Identifiable {
    var id : String
    var detailId : String
    var userId : String
    var gameId : String
    var fan: Int
    var period: String
    var to: String
    var value: Int
    var win: Int
    var winType : String
    var byErrorFlag : Int
    var repondToLose : Int
}

extension GameRecord {
    
    
    func delete(userId:String) -> Promise<Void> {
        let p = Promise<Void> { (resolve , reject) in
            let db = Firestore.firestore()
            db.collection("users").document(userId).collection("gameRecords").document(self.id).delete { (err) in
                guard err == nil  else {
                     return reject(err!)
                 }
                print("delete HistRecord: \(self.id)")
                return resolve(())
            }
        }
        return p
    }
    
 
 
    
    static func getAllItem() -> Promise<[GameRecord]> {
            let p = Promise<[GameRecord]> { (resolve , reject) in
                let db = Firestore.firestore()
                var ref = db.collectionGroup("gameRecords")
                var gameRecords : [GameRecord] = []
                ref.getDocuments { (snap, err) in
                    guard err == nil  else {
                        return reject(err!)
                    }
                    guard let documents = snap?.documents else {return}
                    print("documents count \(documents.count) ")
                    do{
                        for doc in documents {
                            doc.reference.delete()
                            print("Delete")
                        }
                        resolve(gameRecords)
                    }catch{
                        reject(error)
                    }
                }
            }
            return p
    }
    
  
}
