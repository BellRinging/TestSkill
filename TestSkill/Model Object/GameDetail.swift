import UIKit
import Promises
import Firebase
import FirebaseFirestore

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
    var involvedPlayer : [String]
    var period : String
    var createDateTime : String
    var detailNo : Int
    var bonusFlag : Int
    var bonus : Int
    var waterFlag : Int?
    var waterAmount : Int?
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
    
     static func search(fan : String = "Any", period : String = "Any" ,win : String = "Any" ,winType : String = "Any",game : Game? = nil,player : User?) -> Promise<[GameDetail]> {
            let p = Promise<[GameDetail]> { (resolve , reject) in
                let db = Firestore.firestore()
                var ref = db.collection("gameDetails") as! Query
                if fan != "Any" {
                    ref  = ref.whereField("fan", isEqualTo: Int(fan) ?? 0 )
                }
//                if win != "Any" && players.count == 1 {
//                    ref  = ref.whereField("win", isEqualTo: win == "Win" ? 1:0 )
//                }
                if period != "Any" {
                    ref = ref.whereField("period", isEqualTo: period)
                }
                
                if winType != "Any" {
                    ref = ref.whereField("winType", isEqualTo: winType)
                }
                
                if let game = game {
                    ref = ref.whereField("gameId", isEqualTo: game.id)
                }
                
                if let player = player {
                    ref = ref.whereField("involvedPlayer", arrayContains: player.id)
                    print("player : \(player.id)")
                }
                
                var gameDetails : [GameDetail] = []
                ref.getDocuments { (snap, err) in
                    guard err == nil  else {
                        return reject(err!)
                    }
                    guard let documents = snap?.documents else {return}
                    print("documents count \(documents.count) ")
                    do{
                        for doc in documents {
                            let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                            let gameRecord = try JSONDecoder.init().decode(GameDetail.self, from: data)
                            
                            if player != nil  && win != "Any" {
                                if win == "Win"{
                                    let exist = gameRecord.whoWin.filter{$0 == player!.id}.first
                                    if let exist = exist {
                                        gameDetails.append(gameRecord)
                                    }
                                }
                                if win == "Lose"{
                                    let exist = gameRecord.whoLose.filter{$0 == player!.id}.first
                                    if let exist = exist {
                                        gameDetails.append(gameRecord)
                                    }
                                }
                            }else{
                            
                                gameDetails.append(gameRecord)
                            }
                        }
                        resolve(gameDetails)
                    }catch{
                        reject(error)
                    }
                }
            }
            return p
        }
    
    
    static func getLastDetailByGameId(gameId: String , detailNo : Int) -> Promise<GameDetail?>  {
        let p = Promise<GameDetail?> { (resolve , reject) in
//            print("GameId",gameId, detailNo)
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
            let query = ref.whereField("gameId", isEqualTo: gameId).order(by: "detailNo")
             var groups : [GameDetail] = []
             query.getDocuments  { (snap, err) in
//                print(err?.localizedDescription)
                 guard let documents = snap?.documents else {return}
//                print("item??")
                 for doc in documents {
                     do {
                         let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                         let  group = try JSONDecoder.init().decode(GameDetail.self, from: data)
//                        print(group.id)
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
