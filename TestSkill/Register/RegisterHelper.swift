import Promises
import Firebase


struct RegisterHelper{
    
    static func registerUserIntoDatabase(_ user:ProviderUser) {
        guard  let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let token = UserDefaults.standard.retrieve(object: String.self, fromKey: UserDefaultsKey.FcmToken) ?? ""
        let value = ["email": user.email ?? "",
                                        "id": uid,
                                        "userName":user.userName ?? "",
                                        "lastName": user.lastName ?? "",
                                        "firstName": user.firstName ?? "",
                                        "imgUrl": user.imgUrl ?? "",
                                        "balance":0,
                                        "friends": [],
                                        "fdsRequest": [],
                                        "fdsPending": [],
                                        "fcmToken" : token,
                                        "owner" : uid,
                                        "userType" : "real"
                               ] as [String : Any]
           let ref = Firestore.firestore()
           let usersReference = ref.collection("users").document(value["id"] as! String)
           usersReference.setData(value)
  
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
