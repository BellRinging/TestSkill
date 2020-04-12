import UIKit
import Promises
import Firebase

struct PlayGroup :  Identifiable,Codable,Equatable,Hashable  {
    
     public var id : String
     public var playersName : [String]
     public var players : [String]
     public var startFan : Int
     public var endFan : Int
     public var rule : [Int:Int]
     public var ruleSelf : [Int:Int]
     public var groupName: String
    
    
    
    static func == (lhs: PlayGroup, rhs: PlayGroup) -> Bool {
        return lhs.id == rhs.id && lhs.groupName == rhs.groupName
    }
    
    
    init(){
        id = ""
        players = []
        playersName = []
        rule = [:]
        ruleSelf = [:]
        groupName = ""
        startFan = 3
        endFan = 10
    }

}

extension PlayGroup {

    func delete() -> Promise<Void> {
        let p = Promise<Void> { (resolve , reject) in
            let db = Firestore.firestore()
            db.collection("groups").document(self.id).delete { (err) in
                guard err == nil  else {
                     return reject(err!)
                 }
                print("delete Group : \(self.id)")
                return resolve(())
            }
        }
        return p
    }
    
    static func getByUserId(id: String) -> Promise<[PlayGroup]> {
        let p = Promise<[PlayGroup]> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("groups").whereField("players", arrayContains: id)
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
    
  

    static func getUserGroup() -> Promise<[PlayGroup]> {
        let p = Promise<[PlayGroup]> { (resolve , reject) in
            let uid = Auth.auth().currentUser!.uid
            let db = Firestore.firestore()
            let ref = db.collection("groups").whereField("players", arrayContains: uid)
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
                print("Add Group \(self.groupName) (\(self.id))")
                resolve(self)
            }
        }
    }
}
