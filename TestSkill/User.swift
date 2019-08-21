import UIKit
import Firebase
import Promises


public struct User : Codable  {
    let id : String
    let user_id : String?
    let user_name: String?
    let first_name: String?
    let last_name: String?
    let email: String?
    let img_url : String?
    let groups : [UserGroup]?
    let gameRecord : [GameRecord]?
    let history : [UserHistory]?
    let fcmToken : String?
    let name : String
    var balance : Int?
    
    init(dict : [String:String]) {
        self.user_id = dict["user_id"] ?? ""
        self.user_name = dict["user_name"] ?? ""
        self.first_name = dict["first_name"] ?? ""
        self.last_name = dict["last_name"] ?? ""
        self.email = dict["email"] ?? ""
        self.img_url = dict["image_url"] ?? ""
        self.groups = nil
        self.gameRecord = nil
        self.history = nil
        self.fcmToken = ""
        self.name = ""
        self.id = dict["id"] ?? ""
        self.balance = 0
    }
    
}


extension User {
    
    static func getById(id: String) throws -> Promise<User>  {
        let p = Promise<User> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("users").document(id)
            ref.getDocument { (snapshot, err) in
                if let err = err{
                    reject(err)
                }
                guard let dict = snapshot?.data() else {return}
                do {
                    let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    let group = try JSONDecoder.init().decode(User.self, from: data)
                    resolve(group)
                }catch{
                    reject(error)
                }
            }
        }
        return p
    }
    
    static func getAllItem() -> Promise<[User]> {
        let p = Promise<[User]> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("users")
            var groups : [User] = []
            ref.getDocuments { (snap, err) in
                guard let documents = snap?.documents else {return}
                for doc in documents {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                        let  group = try JSONDecoder.init().decode(User.self, from: data)
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
    
    func save() -> Promise<User> {
           
        return Promise<User> { (resolve , reject) in
            let db = Firestore.firestore()
            let encoded = try! JSONEncoder.init().encode(self)
            let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
            let ref = db.collection("users").document(self.id)
            ref.setData(data as! [String : Any]) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
                resolve(self)
            }
        }
    }


    func updateBalance(userId : String , value : Int ) -> Promise<User>{
            
        return Promise<User> { (resolve , reject) in
             let db = Firestore.firestore()
             let data = ["balance": FieldValue.increment(Int64(value))]
             let ref = db.collection("users").document(userId)
             ref.updateData(data as! [String : Any]) { (err) in
                 guard err == nil  else {
                     return reject(err!)
                 }
                 resolve(self)
             }
         }
     }
}
