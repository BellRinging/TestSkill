import UIKit
import SwiftyJSON
import Promises
import Firebase

public struct UserGroup : Codable {
    public var group_id : String
    public let group_name: String
}

extension UserGroup {
    
    static func getById(userId : String , id: String) -> Promise<UserGroup> {
        let p = Promise<UserGroup> { (resolve, reject) in
            let db = Firestore.firestore()
            let ref = db.collection("users").document(userId).collection("groups").document(id)
            ref.getDocument { (snapshot, err) in
                guard let dict = snapshot?.data() else {return}
                let data = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                var group = try! JSONDecoder.init().decode(UserGroup.self, from: data)
                let background = DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
                background.async {
                    resolve(group)
                }
            }
        }
        return p
    }
    
    static func getAllItem(userId : String) -> Promise<[UserGroup]> {
        let p = Promise<[UserGroup]> { (resolve, reject) in
            let db = Firestore.firestore()
            let ref = db.collection("users").document(userId).collection("groups")
            var groups : [UserGroup] = []
            ref.getDocuments { (snap, err) in
                guard let documents = snap?.documents else {return}
                for doc in documents {
                    let data = try! JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                    var group = try! JSONDecoder.init().decode(UserGroup.self, from: data)
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
    
    func save(userId:String) -> Promise<UserGroup> {
           
        return Promise<UserGroup> { (resolve , reject) in
            let db = Firestore.firestore()
            
            let encoded = try! JSONEncoder.init().encode(self)
            let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
            let ref = db.collection("users").document(userId).collection("groups").document(self.group_id)
            ref.setData(data as! [String : Any]) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
                resolve(self)
            }
       
        }
    }
}
