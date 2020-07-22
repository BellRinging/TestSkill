//
//  Location.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 28/5/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import Firebase
import Promises

struct Location: Codable ,Identifiable {
    var id : String
    var name : String
    var userId : String

}


extension Location {
    
    
    func delete() -> Promise<Void> {
        let p = Promise<Void> { (resolve , reject) in
            let db = Firestore.firestore()
            db.collection("locations").document(self.id).delete { (err) in
                guard err == nil  else {
                     return reject(err!)
                 }
                print("delete location: \(self.id)")
                return resolve(())
            }
        }
        return p
    }

    
    static func getAllItem() -> Promise<[Location]> {
        let p = Promise<[Location]> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("locations")
            var groups : [Location] = []
            ref.getDocuments { (snap, err) in
                guard err == nil  else {
//                    print("no data")
                    return reject(err!)
                }
                guard let documents = snap?.documents else {return}
//                print("\(documents.count)")
                for doc in documents {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                        let  group = try JSONDecoder.init().decode(Location.self, from: data)
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
    
    static func getItemByUserId(userId: String) -> Promise<[Location]> {
            let p = Promise<[Location]> { (resolve , reject) in
                let db = Firestore.firestore()
                let query = db.collection("locations").whereField("userId", isEqualTo: userId)
                
                var groups : [Location] = []
                query.getDocuments { (snap, err) in
                    guard err == nil  else {
    //                    print("no data")
                        return reject(err!)
                    }
                    guard let documents = snap?.documents else {return}
    //                print("\(documents.count)")
                    for doc in documents {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                            let  group = try JSONDecoder.init().decode(Location.self, from: data)
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
    
    func save() -> Promise<Location> {
             
          return Promise<Location> { (resolve , reject) in
              let db = Firestore.firestore()
              let encoded = try! JSONEncoder.init().encode(self)
              let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
              let ref = db.collection("locations").document(self.id)
              ref.setData(data as! [String : Any]) { (err) in
                  guard err == nil  else {
                      return reject(err!)
                  }
                  resolve(self)
              }
         
          }
      }
 
}

