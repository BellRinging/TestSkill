import UIKit
import Promises
import Firebase

struct PlayGroup :  Identifiable,Codable,Equatable  {
    
     public var id : String
     public var players : [String:String]
     public var startFan : Int
     public var endFan : Int
     public var rule : [Int:Int]
     public var groupName: String
    
    
    
    static func == (lhs: PlayGroup, rhs: PlayGroup) -> Bool {
        return lhs.id == rhs.id && lhs.groupName == rhs.groupName
    }
    
//    enum CodingKeys: CodingKey {
//        case id
//        case players
//        case startFan
//        case endFan
//        case rule
//        case groupName
//    }
    
    init(){
        id = ""
        players = [:]
        rule = [:]
        groupName = ""
        startFan = 3
        endFan = 10
    }
//
//    required public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(String.self, forKey: .id)
//        players = try container.decode(Dictionary.self, forKey: .players)
//        startFan = try container.decode(Int.self, forKey: .startFan)
//        endFan = try container.decode(Int.self, forKey: .endFan)
//        rule = try container.decode(Dictionary.self, forKey: .rule)
//        groupName = try container.decode(String.self, forKey: .groupName)
//
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(players, forKey: .players)
//        try container.encode(startFan, forKey: .startFan)
//        try container.encode(endFan, forKey: .endFan)
//        try container.encode(rule, forKey: .rule)
//        try container.encode(groupName, forKey: .groupName)
//    }
}
//
extension PlayGroup {

    static func delete(id : String ) -> Promise<Void> {
        let p = Promise<Void> { (resolve , reject) in
            let db = Firestore.firestore()
            db.collection("groups").document(id).delete { (err) in
                guard err == nil  else {
                     return reject(err!)
                 }
                print("delete Group : \(id)")
                return resolve(())
            }
        }
        return p
    }

    static func getById(id: String) -> Promise<PlayGroup> {
        let p = Promise<PlayGroup> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("groups").document(id)
            ref.getDocument { (snapshot, err) in
                if let err = err{
                   reject(err)
                }
                guard let dict = snapshot?.data() else {return}
                do{
                    let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    let group = try JSONDecoder.init().decode(PlayGroup.self, from: data)
                    resolve(group)
                }catch{
                    reject(error)
                }
            }
        }
        return p
    }
    
  

    static func getAllItem() -> Promise<[PlayGroup]> {
        let p = Promise<[PlayGroup]> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("groups")
            var groups : [PlayGroup] = []
            ref.getDocuments { (snap, err) in
                if let err = err{
                   reject(err)
                }
                guard let documents = snap?.documents else {return}
                for doc in documents {
                    do{
                        let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                        let group = try JSONDecoder.init().decode(PlayGroup.self, from: data)
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
    
    func save() -> Promise<PlayGroup> {

        return Promise<PlayGroup> { (resolve , reject) in
            let db = Firestore.firestore()
            let encoded = try! JSONEncoder.init().encode(self)
            let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
            let ref = db.collection("groups").document(self.id)
            ref.setData(data as! [String : Any]) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
                print("Add Group \(self.id)")
                resolve(self)
            }
        }
    }
}
