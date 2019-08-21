import UIKit
import Promises
import Firebase

public struct UserGroup : Codable {
    public var group_id : String
    public let group_name: String
}

extension UserGroup {
    
    
    
    static func delete(userId : String ,docId : String ) -> Promise<Void> {
        let p = Promise<Void> { (resolve , reject) in
            let db = Firestore.firestore()
            db.collection("users").document(userId).collection("groups").document(docId).delete { (err) in
                guard err == nil  else {
                     return reject(err!)
                 }
                print("deleteUserGroup: \(docId)")
                return resolve(())
            }
        }
        return p
    }
    
    static func getById(userId : String , id: String) -> Promise<UserGroup> {
        let p = Promise<UserGroup> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("users").document(userId).collection("groups").document(id)
            ref.getDocument { (snapshot, err) in
                guard err == nil  else {
                    return reject(err!)
                }
                guard let dict = snapshot?.data() else {return}
                do {
                    let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    let group = try JSONDecoder.init().decode(UserGroup.self, from: data)
                    resolve(group)
                }catch{
                    reject(error)
                }
            }
        }
        return p
    }
    
    static func getAllItem(userId : String) -> Promise<[UserGroup]> {
        let p = Promise<[UserGroup]> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("users").document(userId).collection("groups")
            var groups : [UserGroup] = []
            ref.getDocuments { (snap, err) in
                guard err == nil  else {
                    return reject(err!)
                }
                guard let documents = snap?.documents else {return}
                do{
                    for doc in documents {
                        let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                        let group = try JSONDecoder.init().decode(UserGroup.self, from: data)
                        groups.append(group)
                    }
                    resolve(groups)
                }catch{
                    reject(error)
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
                print("Add user group \(userId) \(self.group_id)")
                resolve(self)
            }
       
        }
    }
}
