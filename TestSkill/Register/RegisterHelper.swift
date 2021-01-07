import Promises
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct RegisterHelper{
    
    static func registerUserIntoDatabase(_ user:ProviderUser) {
        guard  let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let token = UserDefaults.standard.retrieve(object: String.self, fromKey: UserDefaultsKey.FcmToken) ?? ""
        var value = ["email": user.email ?? "",
                                        "id": uid,
                                        "userName":user.userName ?? "",
                                        "lastName": user.lastName ?? "",
                                        "firstName": user.firstName ?? "",
                                        "imgUrl": user.imgUrl ?? "",
                                        "yearBalance": [Utility.getCurrentYear(): 0],
                                        "friends": [],
                                        "fdsRequest": [],
                                        "fdsPending": [],
                                        "fcmToken" : token,
                                        "owner" : uid,
                                        "userType" : "real"
                               ] as [String : Any]
        
           let ref = Firestore.firestore()
           let usersReference = ref.collection("users").document(uid)
//        print(usersReference.path)
//        print("before add")
        let user = User(id: uid, userName: user.userName ?? "", firstName: user.firstName ?? "", lastName: user.lastName ?? "", email: user.email ?? "", imgUrl: user.imgUrl ?? "", friends: [], fdsRequest: [], fdsPending: [], fcmToken: token, userType: "real", owner: uid, yearBalance: [2020:0])
        user.save().then { _ in
            print("success save")
        }
//        print(value)
//           usersReference.setData(value)
        print("after add")
  
       }
    
    
    static func uploadImage(uid: String , inputImage : UIImage?) -> Promise<String> {

        let p = Promise<String> { (resolve , reject) in
            let ref = Storage.storage().reference().child("profile_images").child(uid).child("profilePic.jpg")
            if let img = inputImage ?? UIImage(named: "player3") , let uploadData = img.jpegData(compressionQuality: 0.1) {
                ref.putData(uploadData, metadata: nil) { (metaData, error) in
                    if let error = error{
                        reject(error)
                        return
                    }
                    ref.downloadURL { (url, err) in
                        print("download url")
                        if let err = err{
                            reject(err)
                            return
                        }
                        let profileImageURL = url!.absoluteString
                        resolve(profileImageURL)
                    }
                }
            }else{
                print("cant upload photo")
            }
        }
        return p
    }
    
    static func updateDisplayName(_ providerUser:ProviderUser) {
        guard let user = Auth.auth().currentUser else { return }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = providerUser.userName as! String
        changeRequest.photoURL = URL(fileURLWithPath: providerUser.imgUrl as! String)
        changeRequest.commitChanges(completion: { (error) in
            if let _ = error {
                return
            }
            print("Updated Display Name & Img Pic")
        })
      }
    
}
