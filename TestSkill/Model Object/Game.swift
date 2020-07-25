import UIKit
import Firebase
import Promises
import FirebaseFirestore

struct Game: Codable ,Identifiable  {
    var id : String
    var groupId : String
    var location : String
    var date : String
    var period : String
    var result : [String:Int]
    var totalCards : [String:Int]?
    var playersFilter : [String:Bool]
    var playersMap : [String:String]
    var playersId : [String]
    var createDateTime : String
    var detailCount : Int = 0
    var flown : Int
    var gameType : String?
    var doubleCount : [String:Int]?
    var tripleCount : [String:Int]?
    var quadipleCount : [String:Int]?
    var winCount : [String:Int]?
    var bonusFlag : Int?
    var bonus : Int?
    var lostStupidCount : [String:Int]?
    var safeGameCount : [String:Int]?
    var doubleBecaseLastCount : [String:Int]?
    var water : Int?
    var owner : String
}

extension Game {
    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//
    func delete() -> Promise<Void> {
        let p = Promise<Void> { (resolve , reject) in
            let db = Firestore.firestore()
            db.collection("games").document(self.id).delete { (err) in
                guard err == nil  else {
                     return reject(err!)
                 }
                print("delete game: \(self.id)")
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
    
    
    func updatePlayerOrder() -> Promise<Game> {
        let p = Promise<Game> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("games").document(self.id)
            let data = ["playersId": self.playersId]
            ref.updateData(data ) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
                resolve(self)
            }
        }
        return p
    }
    
    static func getAllItem() -> Promise<[Game]> {
        let p = Promise<[Game]> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("games").order(by: "date", descending: true)
            
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
    

    static func search(userId : String , fan : String = "Any", period : String = "Any" ,win : String = "Any" ,amount : Int , players : [User] = [] ,playerExclude: [User] = [], location: String) -> Promise<[Game]> {
            let p = Promise<[Game]> { (resolve , reject) in

                let db = Firestore.firestore()
                var query = db.collection("games") as Query
                let uid = players.map{$0.id}
                    print("uid : \(uid)")
                    
                if uid.count > 0 {
                    for id in uid {
                        query = query.whereField("playersFilter.\(id)", isEqualTo: true)
                    }
                }else{
                    query = query.whereField("playersId", arrayContains: userId)
                }
                if location != "Any" {
                    print("location \(location)")
                    query = query.whereField("location", isEqualTo: location)
                }
                if period != "Any" {
                    print("period \(period)")
                    query = query.whereField("period", isEqualTo: period)
                }
                var groups : [Game] = []
       
//                query = query.order(by: "date", descending: true)
                query.getDocuments { (snap, error) in
                    guard error == nil  else {
//                        print(error?.localizedDescription)
                        return reject(error!)
                    }
                    guard let documents = snap?.documents else {return}
                    for doc in documents {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                            let  game = try JSONDecoder.init().decode(Game.self, from: data)
                            let result = game.result[userId] ?? 0
                            
                           
                            
                            if win != "Any" {
                                if (win == "Win"){
                                    if (result >= amount){
                                        groups.append(game)
                                    }
                                }
                                if (win == "Lose"){
                                    if (result <= amount){
                                        groups.append(game)
                                    }
                                }
                            }else{
                                groups.append(game)
                            }
                        }catch{
                            reject(error)
                        }
                    }
                    var newGroup :[Game] = []
                  
                     if playerExclude.count > 0 {
                        for game in groups{
                            if !self.checkPlayerExist(game:game , players:playerExclude){
                                newGroup.append(game)
                            }
                        }
                          resolve(newGroup)
                     }else{
                         resolve(groups)
                    }
                }
            }
            return p
        }
    
    static func checkPlayerExist(game:Game,players:[User]) -> Bool{
        for playerId in game.playersId {
            for player in players {
                if player.id == playerId {
                    return true
                }
            }
        }
        return false
    }
    
        
    static func getGameByUserId(userId : String) -> Promise<[Game]> {
        let p = Promise<[Game]> { (resolve , reject) in
            
            let db = Firestore.firestore()
            var query = db.collection("games").order(by: "date", descending: true)
            query = query.whereField("playersId", arrayContains: userId)
            
            var groups : [Game] = []
            query.getDocuments { (snap, error) in
                
                guard error == nil  else {
                    print(error)
                    return reject(error!)
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
    
     static func getItemWithGroupId(groupId : String , pagingSize:Int=20, lastDoc:DocumentSnapshot? = nil) -> Promise<([Game],DocumentSnapshot?)> {
            let p = Promise<([Game],DocumentSnapshot?)> { (resolve , reject) in
                let db = Firestore.firestore()
                let ref = db.collection("games")
                var query = ref.limit(to: pagingSize)
                query = query.order(by: "date", descending: true)
                query = query.whereField("groupId", isEqualTo: groupId)
                if let lastDoc = lastDoc {
                    query = query.start(afterDocument: lastDoc)
                }
                var groups : [Game] = []
                query.getDocuments { (snap, error) in
                
                    guard error == nil  else {
                        print(error!.localizedDescription )
                        return reject(error!)
                    }
                    guard let documents = snap?.documents else {return}
                    let lastDoc : DocumentSnapshot? = documents.last
                    print("Game count : \(documents.count) last Doc id : \(lastDoc?.documentID ?? "N/A")")
                    for doc in documents {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                            let  group = try JSONDecoder.init().decode(Game.self, from: data)
                            groups.append(group)
                        }catch{
                            print("\(doc) \(error.localizedDescription)")
                            reject(error)
                        }
                    }
                    resolve((groups,lastDoc))
                }
            }
            return p
        }
    
    
    
    static func getItemWithUserId(userId : String ,groupId : String , pagingSize:Int=20, lastDoc:DocumentSnapshot? = nil) -> Promise<([Game],DocumentSnapshot?)> {
        let p = Promise<([Game],DocumentSnapshot?)> { (resolve , reject) in

            let db = Firestore.firestore()
            
            
            let ref = db.collection("games")
            var query = ref.limit(to: pagingSize)
            query = query.order(by: "date", descending: true)
            query = query.whereField("groupId", isEqualTo: groupId)
            query = query.whereField("playersId", arrayContains: userId)
            if let lastDoc = lastDoc {
                query = query.start(afterDocument: lastDoc)
            }
            var groups : [Game] = []
    
//            query.addSnapshotListener  { (snap, err) in
            query.getDocuments { (snap, error) in
            
                guard error == nil  else {
                    print(error)
                    return reject(error!)
                }
                guard let documents = snap?.documents else {return}
                print("Game count : \(documents.count)")
                let lastDoc : DocumentSnapshot? = documents.last
        
                print("last Doc id : \(lastDoc?.documentID)")
                for doc in documents {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                        let  group = try JSONDecoder.init().decode(Game.self, from: data)
//                        print(group)
                        groups.append(group)
                    }catch{
//                        print(error.localizedDescription)
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
                print("Saved \(self.id)")
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
    
    func updateDetailCount() -> Promise<Game> {
            
         return Promise<Game> { (resolve , reject) in
             let db = Firestore.firestore()
             let data = ["detailCount": FieldValue.increment(Int64(1))]
             let ref = db.collection("games").document(self.id)
             ref.updateData(data ) { (err) in
                 guard err == nil  else {
                     return reject(err!)
                 }
                 resolve(self)
             }
         }
     }
    
    func markFlown(flown : Int = 1) -> Promise<Game> {
            
         return Promise<Game> { (resolve , reject) in
             let db = Firestore.firestore()
            let data = ["flown": flown ,"water" : 0]
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


