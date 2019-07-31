//
//  AddSampleData.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 8/11/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AddSampleData: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        view.addSubview(addUserButton)
        view.addSubview(addPostButton)
        view.addSubview(addGroupButton)
        view.addSubview(addGameButton)
        view.addSubview(addGameDetailButton)
        addUserButton.Anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 50)
        addPostButton.Anchor(top: addUserButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 8, width: 0, height: 50)
        addGroupButton.Anchor(top: addPostButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 8, width: 0, height: 50)
        addGameButton.Anchor(top: addGroupButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 8, width: 0, height: 50)
        addGameDetailButton.Anchor(top: addGameButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 8, width: 0, height: 50)
    }
    
    let addUserButton : UIButton = {
        let bn = UIButton()
        bn.setTitle("Add User", for: .normal)
        bn.addTarget(self, action: #selector(handleAddUser), for: .touchUpInside)
        return bn
    }()
    
    let addPostButton : UIButton = {
        let bn = UIButton()
        bn.setTitle("Add Post", for: .normal)
        bn.addTarget(self, action: #selector(handleAddPost), for: .touchUpInside)
        return bn
    }()
    
    let addGroupButton : UIButton = {
        let bn = UIButton()
        bn.setTitle("Add Group", for: .normal)
        bn.addTarget(self, action: #selector(handleAddGroup), for: .touchUpInside)
        return bn
    }()

    let addGameButton : UIButton = {
        let bn = UIButton()
        bn.setTitle("Add Game", for: .normal)
        bn.addTarget(self, action: #selector(handleAddGame), for: .touchUpInside)
        return bn
    }()
    
    let addGameDetailButton : UIButton = {
        let bn = UIButton()
        bn.setTitle("Add Game Detail", for: .normal)
        bn.addTarget(self, action: #selector(handleAddGameDetail), for: .touchUpInside)
        return bn
    }()
    
    @objc func handleAddGame(){
        print("Add Game")
        let db = Firestore.firestore()     
        var ref: DocumentReference? = nil
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.date(from: "2016/10/08 22:31")
        ref = db.collection("games").addDocument(data: [
            "date": someDateTime,
            "location": "CP Home",
            "results": ["A":1230,"B":-800,"C":270,"D":-700 ]
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    } 
    
    
   @objc func handleAddGameDetail(){
        print("Add Game Detail")
        do {
            try Auth.auth().signOut()
        }catch{
            print(error)
        }
        let db = Firestore.firestore()     
        var ref: DocumentReference? = nil
        ref = db.collection("gameDetail").addDocument(data: [
            "whoWin": "A",
            "wholose": "B",
            "game_id":"MOTfxg1rRTVkORip0yvP",
            "value": 1020,
            "Remark": "10 fan"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    } 
    
    @objc func handleAddGroup(){
//        print("Add group")
        let db = Firestore.firestore()
        let userRef = db.collection("users")
        var players: [String: DocumentReference] = [:]
        userRef.getDocuments { (snapshot, err) in
            if let users = snapshot?.documents.flatMap({
                $0.data().flatMap({ (data) in
                    return User(dict: data)
                })
            }){
                for user in users {
                    let ref = db.collection("users").document(user.id)
                    players[user.name] = ref
                }
            } else {
                print("Document does not exist")
            }
        }
        
        //Add the Group
        var groupRef: DocumentReference? = nil
        groupRef = db.collection("Group").addDocument(data: [
                    "name": "VietNam",
                    "players": players,
                    "rules": [3:60,4:130,5:190,6:260,7:380,8:510,9:770,10:1020],
                    "rules2": [3:30,4:60,5:100,6:130,7:190,8:260,9:380,10:1020]
                ]) { err in
            if let err = err {
                    print(err.localizedDescription)
            }else{
                
                print("docuemnt id : \(groupRef?.documentID)")
            }
        }
        
        //Add the Game
        for round in 0...10{
            let someDateTime = self.generateRandomDate(daysBack:365)
            var gameRef: DocumentReference? = nil
            var modify2 = 0
            if Int.random(in: -1...1) > 0 {
                modify2 = 1
            }else{
                modify2 = -1
            }
            let number1 = Int.random(in: 0 ... 300) * modify2
            let number2 = Int.random(in: 0 ... 300) * modify2
            let number3 = Int.random(in: 0 ... 300) * modify2
            let number4 = (number1 + number2 + number3) * -1
            let location = ["CP Home", "Ricky Home"]
            let area = location.randomElement()
            gameRef = db.collection("games").addDocument(data: [
                "date": someDateTime!,
                "location": area,
                "results": ["A":1230,"B":-800,"C":270,"D":-700 ]
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(gameRef!.documentID)")
                }
            }
            
        }
        
        
        
        
    }
    
    
    func generateRandomDate(daysBack: Int)-> Date?{
                    let day = arc4random_uniform(UInt32(daysBack))+1
                    let hour = arc4random_uniform(23)
                    let minute = arc4random_uniform(59)
                    
                    let today = Date(timeIntervalSinceNow: 0)
                    let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
                    var offsetComponents = DateComponents()
                    offsetComponents.day = -1 * Int(day - 1)
                    offsetComponents.hour = -1 * Int(hour)
                    offsetComponents.minute = -1 * Int(minute)
                    
                    let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
                    return randomDate
        }

    
    
    
    @objc func handleAddUser(){
        print("Add User")
        if let path = Bundle.main.path(forResource: "user", ofType: "txt"){
            do {
                let data  = try String(contentsOfFile: path, encoding: .utf8)
                let lines = data.components(separatedBy: .newlines)
                var count = 1
                
                DispatchQueue.main.async {
                    
                    lines.map({ (text)  in
                        if text != "" {
                            print("create dummy \(count) \(text)")
                            self.loginUser(num: count ,name:  text)
                            count = count + 1
                        }
                    })
                
                }
            
            }catch{
                print(error)
            }
            
        }
        
        
        
    }
    
    func fetchAllUser(){
        var users = [User]()
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {return }
            dict.forEach({ (key,value) in
               
                guard let userProfileDict = value as? [String: Any] else {return}
                let user = User(dict: userProfileDict as [String : AnyObject])
                users.append(user)
            })
            self.addPost(users: users)
            
        })
    }
    
    func addPost(users: [User]){
        
        print(users.count)
        
        if let path = Bundle.main.path(forResource: "item", ofType: "txt"){
            do {
                let data  = try String(contentsOfFile: path, encoding: .utf8)
                let lines = data.components(separatedBy: .newlines)
                var count = 1000
                
                for i in 2001...8000 {
                    let line = lines[i]
                    if (line != "") {
                        print(line)
                        let items = line.components(separatedBy: "\t")
                        let rand : UInt32 = arc4random_uniform(UInt32(users.count))
//                        print(items[0])
//                        print(items[1])
//                        print(rand)
                        self.saveToDatabaseWithImageUrl(imageUrl: items[0], uid: users[Int(rand)].id, caption: items[1])
                    }
                }
                
//                DispatchQueue.main.async {
//
//                    lines.map({ (text)  in
//                        if text != "" {
////                            print("create dummy \(count) \(text)")
////                            self.loginUser(num: count ,name:  text)
//                            let items = text.split(separator: "\t")
//                            print(items[0])
//                            print(items[1])
//
////                            let rand : UInt32 = arc4random_uniform(UInt32(users.count))
////                            if let user = users[Int(rand)] as? User {
////                                print(user.id)
////                            }
//
//                            count = count + 1
//                        }
//                    })
                
//                }
//
            }catch{
                print(error)
            }
            
        }
        
    }
    
    @objc func handleAddPost(){
        fetchAllUser()
    }
    
    
    func createUser(num : Int ,name : String){
        
        let email = "dummy\(num)@gmail.com"
        let password = "123456"
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            guard let user = result?.user else {return}
//            self.updateDisplayName(user, name: name )
            print("User created")
        }
    }
    
    func loginUser(num : Int ,name:String ){
        
        let email = "dummy\(num)@gmail.com"
        let password = "123456"
        
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            guard let user = result?.user else {return}
            self.createProfitObject(num: num, uid: user.uid, name: name)
        }
    }
//
//    func updateDisplayName(_ user: Any , name:String ){
//        let changeRequest = user.createProfileChangeRequest()
//        changeRequest.displayName = name
//        changeRequest.commitChanges(completion: { (error) in
//            if let err = error {
//                print(err.localizedDescription)
//                return
//            }
//            print("Updated Display Name")
//            do {
//            try Auth.auth().signOut()
//                print("signout")
//            }catch{
//                print(error)
//            }
//        })
//    }
    
    func createProfitObject(num : Int ,uid : String ,name : String){
        let ref = Storage.storage().reference().child("profile_images").child(uid).child("profilePic.jpg")
        if let profileImage = UIImage(named: "\(num).jpg"), let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
            ref.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                if (error != nil){
                    print("some bad happend in put image to server")
                    return
                }
                print("upload image")
                ref.downloadURL { (url, error) in
                    if let profileImageURL = url?.absoluteString{
                                        let values = [ "last_name": "Dummy", "first_name": "\(num)" ,"email" : "dummy\(num)@gmail.com" , "img_url" : profileImageURL , "name" : name ,"id" : uid]
                                        print(values)
                                        self.registerUserIntoDatabaseWithUID(uid ,values: values as [String : AnyObject])
                                    }
                }
                
                
            })
        }
    }
    
    
                
    func registerUserIntoDatabaseWithUID( _ uid : String ,values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            do {
                try Auth.auth().signOut()
                print("signout")
            }catch{
                print(error)
            }
    })
    }
    
 
    
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String , uid : String ,caption : String ) {
        
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        
        let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": 100, "imageHeight": 100, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
//                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB", err)
                return
            }
            
            print("Successfully saved post to DB")
//            self.dismiss(animated: true, completion: nil)
            
//            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        }
    }
}
