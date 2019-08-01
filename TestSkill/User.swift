import UIKit
import SwiftyJSON
import Firebase
import Promises


public struct User : Codable  {
    let user_id : String
    let user_name: String?
    let first_name: String?
    let last_name: String?
    let email: String?
    let image_url : String?
    let groups : [UserGroup]?
    let gameRecord : [GameRecord]?
    let history : [UserHistory]?
}


extension User {
    
    static func getById(id: String) -> Promise<User> {
        let p = Promise<User> { (resolve, reject) in
            let db = Firestore.firestore()
            let ref = db.collection("users").document(id)
            ref.getDocument { (snapshot, err) in
                guard let dict = snapshot?.data() else {return}
                let data = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                var group = try! JSONDecoder.init().decode(User.self, from: data)
                let background = DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
                background.async {
                    resolve(group)
                }
            }
        }
        return p
    }
    
    static func getAllItem() -> Promise<[User]> {
        let p = Promise<[User]> { (resolve, reject) in
            let db = Firestore.firestore()
            let ref = db.collection("users")
            var groups : [User] = []
            ref.getDocuments { (snap, err) in
                guard let documents = snap?.documents else {return}
                for doc in documents {
                    let data = try! JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                    var group = try! JSONDecoder.init().decode(User.self, from: data)
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
    
    func save() -> Promise<User> {
           
        return Promise<User> { (resolve , reject) in
            let db = Firestore.firestore()
            
            let encoded = try! JSONEncoder.init().encode(self)
            let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
            let ref = db.collection("users").document(self.user_id)
            ref.setData(data as! [String : Any]) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
                resolve(self)
            }
       
        }
    }
}
