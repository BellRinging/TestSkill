import SwiftUI
import FirebaseAuth
import  SwiftEntryKit

class MainTabViewModel: ObservableObject {


    @Published var status : pageStatus = .loading
    var userId : String = ""
    var uid = "8QfQrvQEklaD9tKfksXrbmOaYo53"

   
    init(){
        saveCurrentUser()
    }
    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
    }()
    

    func saveCurrentUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.userId = uid
        User.getById(id: uid).then { (user)  in
            if let user = user {
                UserDefaults.standard.save(customObject: user, inKey: UserDefaultsKey.CurrentUser)
                if let token = UserDefaults.standard.retrieve(object: String.self, fromKey: UserDefaultsKey.FcmToken){
                    if user.fcmToken != token {
                        user.updateFcmToken(token: token).catch { (err) in
                            Utility.showAlert(message: err.localizedDescription)
                        }
                    }
                }
                self.status = .completed
            }
        }
    }
   
}
