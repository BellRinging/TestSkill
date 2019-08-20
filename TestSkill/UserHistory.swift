import UIKit
import SwiftyJSON
import Promises
import Firebase

public struct UserHistory : Codable{
    let period : String
    let value : Int
}


extension UserHistory {
    
    static func getById(usedId: String , period : String ) -> Promise<UserHistory> {
        
        let p = Promise<UserHistory> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("users").document(usedId).collection("history").document(period)
            ref.getDocument { (snapshot, err) in
                guard let dict = snapshot?.data() else {return}
                let data = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let history = try! JSONDecoder.init().decode(UserHistory.self, from: data)
                let background = DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
                background.async {
                    resolve(history)
                }
            }
        }
        return p
 
    }
    
    static func getAllItembyUser(usedId : String) -> Promise<[UserHistory]> {
        let p = Promise<[UserHistory]> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("users").document(usedId).collection("history")
            var historys : [UserHistory] = []
            ref.getDocuments { (snap, err) in
                guard let documents = snap?.documents else {return}
                for doc in documents {
                    let data = try! JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                    var hist = try! JSONDecoder.init().decode(UserHistory.self, from: data)
                    historys.append(hist)
                }
                let background = DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
                background.async {
                    resolve(historys)
                }
            }
        }
        return p
    }
    
    func save(userId:String) -> Promise<UserHistory> {
           
        return Promise<UserHistory> { (resolve , reject) in
            let db = Firestore.firestore()
            
            let encoded = try! JSONEncoder.init().encode(self)
            let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
            let ref = db.collection("users").document(userId).collection("history").document(self.period)
            ref.updateData(data as! [String : Any]) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
                resolve(self)
            }
       
        }
    }
}
