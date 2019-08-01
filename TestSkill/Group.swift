import UIKit
import SwiftyJSON
import Promises
import Firebase

public struct Group : Codable {
    public let group_id : String
    public let players : [String:String]
    public let rule : [Int:Int]
    public let group_name: String
}

extension Group {
    
    static func getById(id: String) -> Promise<Group> {
        let p = Promise<Group> { (resolve, reject) in
            let db = Firestore.firestore()
            let ref = db.collection("groups").document(id)
            ref.getDocument { (snapshot, err) in
                guard let dict = snapshot?.data() else {return}
                let data = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                var group = try! JSONDecoder.init().decode(Group.self, from: data)
                let background = DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
                background.async {
                    resolve(group)
                }
            }
        }
        return p
    }
    
    static func getAllItem() -> Promise<[Group]> {
        let p = Promise<[Group]> { (resolve, reject) in
            let db = Firestore.firestore()
            let ref = db.collection("groups")
            var groups : [Group] = []
            ref.getDocuments { (snap, err) in
                guard let documents = snap?.documents else {return}
                for doc in documents {
                    let data = try! JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                    var group = try! JSONDecoder.init().decode(Group.self, from: data)
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
    
    func save() -> Promise<Group> {
           
        return Promise<Group> { (resolve , reject) in
            let db = Firestore.firestore()
            
            let encoded = try! JSONEncoder.init().encode(self)
            let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
            let ref = db.collection("group").document(self.group_id)
            ref.setData(data as! [String : Any]) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
                resolve(self)
            }
       
        }
            

    }
}
