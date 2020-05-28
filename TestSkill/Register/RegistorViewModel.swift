import Foundation
import SwiftUI
import Promises
import Firebase
import Combine

class RegisterViewModel: ObservableObject {
  
    @Published var email : String = ""
    @Published var password : String = ""
    @Published var balance : String = ""
    @Published var reEnterPassword : String = ""
    @Published var userName : String = ""
    @Published var firstName : String = ""
    @Published var lastName : String = ""
    @Published var showingImagePicker = false
    @Published var image: Image? = Image("player3")
    @Published var inputImage: UIImage? = UIImage(named: "player3")
    @Binding var closeFlag : Bool
    @Published var title : String = ""
    var user : User?
    var editMode = false
    var hasSelectedPic : Bool = false
    var userType : String = "real"
    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
    }()
        private var tickets: [AnyCancellable] = []
    init(closeFlag: Binding<Bool> , user : User?,userType : String){
        self._closeFlag = closeFlag
        self.user = user
        self.userType = userType
        self.title = userType == "real" && user == nil ? "Register form" : userType == "dummy" ? "Add Dummy Account" : "Edit User"
//
        if user != nil {
            loadUser()
            editMode = true
        }
        
        NotificationCenter.default.publisher(for: .test)
            .sink { _ in
                print("received")
                self.showingImagePicker = false
        }.store(in: &tickets)
    }
    
    func loadUser(){
        self.email = user!.email
        self.userName = user!.userName
        self.firstName = user!.firstName!
        self.lastName = user!.lastName!
        if user!.userType == "dummy"{
            self.balance = "\(user!.balance)"
        }
        
        let url =  URL(string:user!.imgUrl)!
        self.background.async {
            
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.inputImage = UIImage(data: data)
                    self.loadImage()
                }
            }
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func validField() -> Bool{
        
        if userType == "real" {
            if self.email == "" {
                Utility.showAlert(message: "Email is required.Please enter your email")
                return false
            }
        }else{
           if Int(balance) == nil {
               Utility.showAlert(message: "Fail to convert balance")
               return false
           }
        }
        if !self.editMode && userType == "real" {
            if self.password == "" {
                Utility.showAlert(message: "Password is required.Please enter your number")
                return false
            }
            if self.reEnterPassword == "" {
                Utility.showAlert( message: "Password is required.Please enter your number")
                return false
            }
            
            if self.reEnterPassword != password {
                Utility.showAlert( message: "Password is required.Please enter your number")
                return false
            }
        }
        if self.userName == "" {
            Utility.showAlert(message: "userName is required.Please enter your number")
            return false
        }
        if self.firstName == "" {
            Utility.showAlert( message: "firstName is required.Please enter your number")
            return false
        }
        if self.lastName == "" {
            Utility.showAlert( message: "lastName is required.Please enter your number")
            return false
        }
        return true
    }

    func handleRegister(){
        if !self.validField() {
            return
        }
        Utility.showProgress()
        if userType == "dummy" {
            let uid = Auth.auth().currentUser!.uid
            if editMode{
                let userId = user!.id
                if hasSelectedPic {
                    print("Change Pic")
                
                    RegisterHelper.uploadImage(uid: userId, inputImage: self.inputImage).then { (url) in
                        print("After upload img :\(url)")
                        self.editUser(url:url,updateBalance:true)
                    }.always {
                         Utility.hideProgress()
                    }
                }else{
                    self.editUser(url: user!.imgUrl,updateBalance:true)
                }
            }else{
                registerDummyUserIntoDatabase()
            }
        }else if !editMode{

            print("Create login into firebase")
            self.createUserInDb().then { user in
                return RegisterHelper.uploadImage(uid: user.uid, inputImage: self.inputImage)
            }.then{ url in
                print("url :\(url)")
                let providerUser = ProviderUser(userName: self.userName, firstName: self.firstName, lastName: self.lastName, email: self.email, imgUrl: url)
                RegisterHelper.registerUserIntoDatabase(providerUser)
                RegisterHelper.updateDisplayName(providerUser)
                print("Profile created")
                self.closeFlag.toggle()
            }.catch{ err in
                print("Fail to create login into firebase \(err.localizedDescription)")
                Utility.showAlert(message: err.localizedDescription)
            }.always {
                Utility.hideProgress()
            }
        }else{
            let uid = Auth.auth().currentUser!.uid
            print("Edit Mode")
            
            if hasSelectedPic {
                RegisterHelper.uploadImage(uid: uid, inputImage: self.inputImage).then { (url) in
                    self.editUser(url:url)
                }
                        
            }else{
                self.editUser(url: user!.imgUrl)
            }
    
        }
    }
    
    func registerDummyUserIntoDatabase() {
        
        let uid = Auth.auth().currentUser!.uid
        let uuid = UUID().uuidString
        RegisterHelper.uploadImage(uid: uuid, inputImage: self.inputImage).then { (url) in
            let value = ["email": "\(uuid)@dummy.com" ,
                "id": uuid,
                "userName": self.userName ,
                "lastName": self.lastName ,
                "firstName": self.firstName ,
                "imgUrl": url,
                "balance": Int(self.balance) ?? 0 ,
                "friends": [uid],
                "fdsRequest": [],
                "fdsPending": [],
                "fcmToken" : "",
                "userType" : "dummy",
                "owner" : uid
                ] as [String : Any]
            let ref = Firestore.firestore()
            let usersReference = ref.collection("users").document(uuid)
            usersReference.setData(value)
            
            var user = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!
            user.updateFriend(userId: uuid).then { _ in
                var fds = user.friends
                fds.append(uuid)
                user.friends = fds
                UserDefaults.standard.save(customObject: user, inKey: UserDefaultsKey.CurrentUser)
                self.closeFlag.toggle()
            }
        }.catch { (err) in
            Utility.showAlert(message: "Error : \(err.localizedDescription)")
        }.always {
            Utility.hideProgress()
        }
    }
    
    
    func editUser(url : String , updateBalance : Bool = false){
        
        var list = [
            "userName":self.userName,
            "lastName": self.lastName ,
            "firstName": self.firstName ,
            "imgUrl": url
        ] as [String:Any]
        
        
        print("list \(list)")
        if updateBalance {
            list["balance"] = Int(self.balance) ?? 0
        }
        
        let ref = Firestore.firestore()
        let uid = userType == "real" ? Auth.auth().currentUser!.uid : self.user!.id
        let usersReference = ref.collection("users").document(uid)
        usersReference.updateData(list)
        if var user = self.user {
            print("AAA")
            user.userName = self.userName
            user.lastName = self.lastName
            user.firstName = self.firstName
            user.imgUrl = url
            
            if userType == "real" {
                var temp = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!
                temp.userName = self.userName
                temp.lastName = self.lastName
                temp.firstName = self.firstName
                temp.imgUrl = url
                UserDefaults.standard.save(customObject: temp, inKey: UserDefaultsKey.CurrentUser)
            }
            
            if updateBalance {
                user.balance = Int(self.balance) ?? 0
            }
            NotificationCenter.default.post(name: .updateUser , object: user)
        }
        Utility.hideProgress()
        self.closeFlag.toggle()
    }

    func createUserInDb() -> Promise<FirebaseAuth.User>  {
        let p = Promise<FirebaseAuth.User> { (resolve , reject) in
            Auth.auth().createUser(withEmail: self.email, password: self.password) { (result, err) in
                guard let user = result?.user else {
                    reject(err!)
                    return
                }
                resolve(user)
            }
        }
        return p
    }
}
