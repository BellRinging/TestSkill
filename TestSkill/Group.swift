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
            let ref = db.collection("group").document(id)
            ref.getDocument { (snapshot, err) in
                if let err = err{
                   reject(err)
                }
                guard let dict = snapshot?.data() else {return}
                do{
                    let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    var group = try JSONDecoder.init().decode(Group.self, from: data)
                    resolve(group)
                }catch{
                    reject(error)
                }
            }
        }
        return p
    }
    
    static func getAllItem() -> Promise<[Group]> {
        let p = Promise<[Group]> { (resolve, reject) in
            let db = Firestore.firestore()
            let ref = db.collection("group")
            var groups : [Group] = []
            ref.getDocuments { (snap, err) in
                if let err = err{
                   reject(err)
                }
                guard let documents = snap?.documents else {return}
                for doc in documents {
                    do{
                        let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                        var group = try JSONDecoder.init().decode(Group.self, from: data)
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
