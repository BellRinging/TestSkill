import UIKit
import Firebase
import Promises
import FirebaseFirestore

struct FdsRequest : Codable ,Identifiable {
    let id : String
    let fromUserId : String
    let fromUserName : String
    let toUserId: String
    let fcmToken: String
    let createDate: String
}

extension FdsRequest {

    
    func save() -> Promise<FdsRequest> {
           
        return Promise<FdsRequest> { (resolve , reject) in
            let db = Firestore.firestore()
            let encoded = try! JSONEncoder.init().encode(self)
            let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
            let ref = db.collection("fdsRequest").document(self.id)
            ref.setData(data as! [String : Any]) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
                print("Send fdsRequest to \(self.fcmToken)")
                resolve(self)
            }
       
        }
    }
}
