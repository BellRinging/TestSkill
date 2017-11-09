//
//  AddSampleData.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 8/11/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import Firebase


class AddSampleData: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        view.addSubview(addUserButton)
        view.addSubview(addPostButton)
        addUserButton.Anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 50)
        addPostButton.Anchor(top: addUserButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 8, width: 0, height: 50)
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
    
    func handleAddUser(){
        print("Add User")
        do {
            try Auth.auth().signOut()
        }catch{
            print(error)
        }
        
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
    
    func handleAddPost(){
        fetchAllUser()
    }
    
    
    func createUser(num : Int ,name : String){
        
        let email = "dummy\(num)@gmail.com"
        let password = "123456"
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            
            self.updateDisplayName(user!, name: name )
            print("User created")
        }
    }
    
    func loginUser(num : Int ,name:String ){
        
        let email = "dummy\(num)@gmail.com"
        let password = "123456"
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//            self.createProfitObject(user?.uid!)
            self.createProfitObject(num: num, uid: user!.uid, name: name)
        }
    }
    
    func updateDisplayName(_ user: Firebase.User , name:String ){
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges(completion: { (error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            print("Updated Display Name")
            do {
            try Auth.auth().signOut()
                print("signout")
            }catch{
                print(error)
            }
        })
    }
    
    func createProfitObject(num : Int ,uid : String ,name : String){
        let ref = Storage.storage().reference().child("profile_images").child(uid).child("profilePic.jpg")
        if let profileImage = UIImage(named: "\(num).jpg"), let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            ref.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                if (error != nil){
                    print("some bad happend in put image to server")
                    return
                }
                print("upload image")
                if let profileImageURL = metaData?.downloadURL()?.absoluteString{
                    let values = [ "last_name": "Dummy", "first_name": "\(num)" ,"email" : "dummy\(num)@gmail.com" , "img_url" : profileImageURL , "name" : name ,"id" : uid]
                    print(values)
                    self.registerUserIntoDatabaseWithUID(uid ,values: values as [String : AnyObject])
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
