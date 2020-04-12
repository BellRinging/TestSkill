import UIKit
import Firebase
import Promises

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
    
    func deleteGameRecord(userId : String ,docId : String ) -> Promise<Void> {
        let p = Promise<Void> { (resolve , reject) in
            let db = Firestore.firestore()
            db.collection("users").document(userId).collection("gameRecords").document(docId).delete { (err) in
                guard err == nil  else {
                     return reject(err!)
                 }
                print("deleteGameRecord: \(docId)")
                return resolve(())
            }
        }
        return p
    }
    
    static func getById2(userId : String) -> Promise<[GameRecord]> {
        let p = Promise<[GameRecord]> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("users").document(userId).collection("gameRecords")
            var gameRecords : [GameRecord] = []
            ref.getDocuments { (snap, err) in
                guard err == nil  else {
                    return reject(err!)
                }
                guard let documents = snap?.documents else {return}
                print("documents count \(documents.count) ")
                do{
                    for doc in documents {
                        let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                        let gameRecord = try JSONDecoder.init().decode(GameRecord.self, from: data)
                        gameRecords.append(gameRecord)
                    }
                    resolve(gameRecords)
                }catch{
                    reject(error)
                }
            }
        }
        return p
    }
    
    
    
    static func getAllByGameId(gameId : String ) -> Promise<[GameRecord]> {
            let p = Promise<[GameRecord]> { (resolve , reject) in
                let db = Firestore.firestore()
                var ref = db.collectionGroup("gameRecords").whereField("gameId", isEqualTo: gameId)
                var gameRecords : [GameRecord] = []
                ref.getDocuments { (snap, err) in
                    guard err == nil  else {
                        return reject(err!)
                    }
                    guard let documents = snap?.documents else {return}
                    print("documents count \(documents.count) ")
                    do{
                        for doc in documents {
                            let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                            let gameRecord = try JSONDecoder.init().decode(GameRecord.self, from: data)
                            gameRecords.append(gameRecord)
                        }
                        resolve(gameRecords)
                    }catch{
                        reject(error)
                    }
                }
            }
            return p
    }
    
    static func getAllByTo(userId : String ) -> Promise<[GameRecord]> {
            let p = Promise<[GameRecord]> { (resolve , reject) in
                let db = Firestore.firestore()
                var ref = db.collectionGroup("gameRecords").whereField("to", isEqualTo: userId)
                var gameRecords : [GameRecord] = []
                ref.getDocuments { (snap, err) in
                    guard err == nil  else {
                        return reject(err!)
                    }
                    guard let documents = snap?.documents else {return}
                    print("documents count \(documents.count) ")
                    do{
                        for doc in documents {
                            let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                            let gameRecord = try JSONDecoder.init().decode(GameRecord.self, from: data)
                            gameRecords.append(gameRecord)
                        }
                        resolve(gameRecords)
                    }catch{
                        print(error)
                        reject(error)
                    }
                }
            }
            return p
    }
    
    
    
    static func getAllItemAndFixthePath() -> Promise<[GameRecord]> {
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
                            let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                            var gameRecord = try JSONDecoder.init().decode(GameRecord.self, from: data)
                            if doc.documentID != gameRecord.id {
                                gameRecord.id = doc.documentID
                                gameRecord.userId = String(doc.reference.path.prefix(34).suffix(28))
                                gameRecords.append(gameRecord)
                            }
                        }
                        resolve(gameRecords)
                    }catch{
                        reject(error)
                    }
                }
            }
            return p
    }
    
    static func getAllItem(userId : String , fan : String = "Any", period : String = "Any" ,win : String = "Any" ,players : [User] = []) -> Promise<[GameRecord]> {
        let p = Promise<[GameRecord]> { (resolve , reject) in
            let db = Firestore.firestore()
            var ref = db.collection("users").document(userId).collection("gameRecords") as Query
            if fan != "Any" {
                ref  = ref.whereField("fan", isEqualTo: Int(fan) ?? 0 )
            }
            if win != "Any" {
                ref  = ref.whereField("win", isEqualTo: win == "Win" ? 1:0 )
            }
            if period != "Any" {
                ref = ref.whereField("period", isEqualTo: period)
            }
            
            let uid = players.map{$0.id}
            if uid.count > 0 {
                ref = ref.whereField("to", in: uid)
            }
            
            var gameRecords : [GameRecord] = []
            ref.getDocuments { (snap, err) in
                guard err == nil  else {
                    return reject(err!)
                }
                guard let documents = snap?.documents else {return}
                print("documents count \(documents.count) ")
                do{
                    for doc in documents {
                        let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                        let gameRecord = try JSONDecoder.init().decode(GameRecord.self, from: data)
//                        print(gameRecord)
                        gameRecords.append(gameRecord)
                    }
                    resolve(gameRecords)
                }catch{
                    reject(error)
                }
            }
        }
        return p
    }
    

    
    func save() -> Promise<GameRecord> {
           
        return Promise<GameRecord> { (resolve , reject) in
            let db = Firestore.firestore()
            let encoded = try! JSONEncoder.init().encode(self)
            let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
            let ref = db.collection("users").document(self.userId).collection("gameRecords").document(self.id)
            ref.setData(data as! [String : Any]) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
                print("Save gamerecord \(self.id)")
                resolve(self)
            }
        }
    }
    
    
    func updateId(userId : String) -> Promise<GameRecord>{
        return Promise<GameRecord> { (resolve , reject) in
            let db = Firestore.firestore()
            var data = ["userId": userId]
           
            let ref = db.collection("users").document(userId).collection("gameRecords").document(self.id)
            ref.updateData(data as [String : Any]) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
                print("updated \(self.id) on user \(userId)")
                resolve(self)
            }
        }
    }
}
