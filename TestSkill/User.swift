import UIKit
import Firebase
import FirebaseAuth
import Promises


struct User : Identifiable,Codable,Equatable,Hashable  {
    public var  id : String
    public var  userName: String?
    public var  firstName: String?
    public var  lastName: String?
    public var  email: String
    public var  imgUrl : String
    public var balance : Int?
    
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.email == rhs.email
    }
    
//    init(dict : [String:String]) {
//        self.id = dict["user_id"] ?? ""
//        self.userName = dict["user_name"] ?? ""
//        self.firstName = dict["first_name"] ?? ""
//        self.lastName = dict["last_name"] ?? ""
//        self.email = dict["email"] ?? ""
//        self.imgUrl = dict["image_url"] ?? ""
//        self.balance = 0
//    }
//
//    enum CodingKeys: CodingKey {
//        case id
//        case userName
//        case firstName
//        case lastName
//        case email
//        case imgUrl
//        case balance
//    }
//
//    init(){
//        self.id = ""
//        self.userName = ""
//        self.firstName = ""
//        self.lastName = ""
//        self.email = ""
//        self.imgUrl = ""
//        self.balance = 0
//    }
//

}


extension User {
    
    
    static func getUserObject() -> Promise<User?>  {
        let p = Promise<User?>{(resolve , reject) in
            if true {
                resolve(nil)
            }else{
                let err = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "User not yet login"])
                reject(err)
            }
        }
        if let user = Auth.auth().currentUser{
            return self.getById(id: "")
        }else{
            return p
        }
     }
    
    static func getById(id: String) -> Promise<User?>  {
        let p = Promise<User?> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("users").document(id)
            ref.getDocument { (snapshot, err) in
                if let err = err{
                    reject(err)
                }
                guard let dict = snapshot?.data() else {
                    print("No User found")
                    resolve(nil)
                    return
                }
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
                print("Update balance \(userId) \(value)")
                 resolve(self)
             }
         }
     }
}

