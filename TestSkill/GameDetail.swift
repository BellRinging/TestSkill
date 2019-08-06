import UIKit
import SwiftyJSON
import Promises
import Firebase

struct GameDetail : Codable {
    let id : String
    let game_id : String
    let remark : String
    let value  : Int
    let whoLose : [String]
    let whoWin  : [String]
    let winType : String
    
    /*
    init(dict : Dictionary<String, Any>){
        self.id = dict["id"] as? String ?? ""
        self.game_id = dict["game_id"] as? String ?? ""
        self.value = dict["value"] as? Int ?? 0
        self.remark = dict["remark"] as? String ?? ""
        self.whoLose = dict["whoLose"] as? [String] ?? []
        self.whoWin = dict["whoWin"] as? [String] ?? []
        self.winType = dict["winType"] as? String ?? ""
        
    }
 */
}


extension GameDetail {
    
    static func getById(id: String) throws -> Promise<GameDetail>  {
//        print("get Id")
        let p = Promise<GameDetail> { (resolve, reject) in
            let db = Firestore.firestore()
            let ref = db.collection("gameDetails").document(id)
            ref.getDocument { (snapshot, err) in
                if let err = err{
                    reject(err)
                }
//                print("in the loop")
                guard let dict = snapshot?.data() else {return}
//                print(dict)
                do {
                    let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    let group = try JSONDecoder.init().decode(GameDetail.self, from: data)
                    resolve(group)
                }catch{
                    print("-======= \(error.localizedDescription)" )
                    reject(error)
                }
            }
        }
        return p
    }
    
    static func getAllItem() -> Promise<[GameDetail]> {
        let p = Promise<[GameDetail]> { (resolve, reject) in
            let db = Firestore.firestore()
            let ref = db.collection("gameDetails")
            var groups : [GameDetail] = []
            ref.getDocuments { (snap, err) in
//                print("err : \(err)")
                guard let documents = snap?.documents else {return}
                for doc in documents {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                        let  group = try JSONDecoder.init().decode(GameDetail.self, from: data)
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
    
    func save() -> Promise<GameDetail> {
           
        return Promise<GameDetail> { (resolve , reject) in
            let db = Firestore.firestore()
            
            let encoded = try! JSONEncoder.init().encode(self)
            let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
            let ref = db.collection("gameDetails").document(self.id)
            ref.setData(data as! [String : Any]) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
                resolve(self)
            }
       
        }
    }
}
