import Foundation
import SwiftUI
import Promises
import Firebase

class RegisterViewModel: ObservableObject {
  
    @Published var email : String = ""
    @Published var password : String = ""
    @Published var reEnterPassword : String = ""
    @Published var userName : String = ""
    @Published var firstName : String = ""
    @Published var lastName : String = ""
    @Published var showingImagePicker = false
    @Published var image: Image? = Image("player3")
    @Published var inputImage: UIImage? = UIImage(named: "player3")
    @Binding var closeFlag : Bool
    var user : User?
    var editMode = false
    var hasSelectedPic : Bool = false
    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
    }()
    
    init(closeFlag: Binding<Bool> , user : User?){
        self._closeFlag = closeFlag
        self.user = user
        if user != nil {
            loadUser()
            editMode = true
        }
    }
    
    func loadUser(){
        self.email = user!.email
        self.userName = user!.userName
        self.firstName = user!.firstName!
        self.lastName = user!.lastName!
        let url =  URL(string:user!.imgUrl)!
    
        if let data = try? Data(contentsOf: url) {
            DispatchQueue.main.async {
                self.inputImage = UIImage(data: data)
                self.loadImage()
            }
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func validField() -> Bool{
        if self.email == "" {
            Utility.showAlert(message: "Email is required.Please enter your email")
            return false
        }
        if !self.editMode {
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
        if !editMode{
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
            print("Edit Mode")
            let uid = Auth.auth().currentUser!.uid
            if hasSelectedPic {
                RegisterHelper.uploadImage(uid: uid, inputImage: self.inputImage).then { (url) in
                    self.editUser(url:url)
                }
            }else{
                self.editUser(url: user!.imgUrl)
            }
            Utility.hideProgress()
        }
    }
    
    func editUser(url : String){
        let uid = Auth.auth().currentUser!.uid
        let list = [
            "userName":self.userName,
            "lastName": self.lastName ,
            "firstName": self.firstName ,
            "imgUrl": url
        ]
        let ref = Firestore.firestore()
        let usersReference = ref.collection("users").document(uid)
        usersReference.updateData(list)
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
