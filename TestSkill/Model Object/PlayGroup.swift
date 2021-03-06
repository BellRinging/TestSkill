import UIKit
import Promises
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct PlayGroup :  Identifiable,Codable,Equatable,Hashable  {
    
     public var id : String
     public var playersName : [String]
     public var players : [String]
     public var startFan : Int
     public var endFan : Int
     public var rule : [Int:Int]
     public var ruleSelf : [Int:Int]
     public var groupName: String
    
    
    public var enableSpecialItem: Int
    public var specialItemAmount: Int
    public var enableBonusPerDraw: Int
    public var enableCalimWater: Int
    public var calimWaterAmount: Int
    public var calimWaterFan: Int
    public var bonusPerDraw: Int
    
    public var big2Amt: Int
    public var big2Enable: Int
    public var mahjongEnable: Int
    public var double: Int
    public var triple: Int
    public var quadiple: Int
    public var enableDouble: Int
    public var enableTriple: Int
    public var enableQuadiple: Int
    public var startMinusOne: Int
    public var markBig2: Int
    
    
    
    
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
        big2Amt = 10
        double = 8
        triple = 10
        quadiple = 13
        markBig2 = 0
        mahjongEnable = 1
        startMinusOne = 1
        big2Enable = 0
        enableDouble = 1
        enableTriple = 1
        enableQuadiple = 1
       enableSpecialItem = 1
        specialItemAmount = 1
        enableBonusPerDraw = 1
        enableCalimWater = 1
        calimWaterAmount = 1
        calimWaterFan = 1
        bonusPerDraw = 1
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
//                        print("finished get group")
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
