import Promises
import SwiftUI
import Firebase
import Combine
import AuthenticationServices
import CryptoKit

class LoginViewModel: ObservableObject {

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showRegisterPage: Bool = false
    @Published var showForgetPassword: Bool = false
    @Published  var appleSignInDelegates: SignInWithAppleDelegates! = nil
    var sampleDataForPageView : [PageViewArea]
    private var tickets: [AnyCancellable] = []

    
    init(){
        let dao = [
             Page(title: "Majhong recorder", image: Image("fontPageImage3"), massage: "無籌碼 都可以輕鬆MARK 數"),
             Page(title: "三缺一", image: Image("fontPageImage2"), massage: "仲唔來？"),
             Page(title: "悶悶地 無街出", image: Image("fontPageImage1"), massage: "仲唔打牌 等幾時")
         ]
        sampleDataForPageView  = dao.map{PageViewArea(inputDO: $0)}
        addNotification()
    }
    
    func addNotification(){
         NotificationCenter.default.publisher(for: .loginCompleted)
             .compactMap{$0.userInfo as NSDictionary?}
             .sink {(dict) in
                 if let credential = dict["token"] as? AuthCredential , let tempUser = dict["user"] as? ProviderUser {
                     SocialLogin().firebaseLogin(credential, provider: "google",user:tempUser)
                 }
         }.store(in: &tickets)
     }

    func normalLogin(){
        print("SignIn by Email")
        if self.validField() {
            Utility.showProgress()
            normalLoginByUser(email: email, password: password).then { user in
                 NotificationCenter.default.post(name: .dismissSwiftUI, object: nil)
            }.catch { (err) in
                Utility.showAlert(message: err.localizedDescription)
            }.always {
                Utility.hideProgress()
            }
        }
    }

    func validField() -> Bool{
        if email == "" {
            Utility.showAlert( message: "Email is required.Please enter your email")
            return false
        }

        if password == "" {
            Utility.showAlert(message: "Password is required.Please enter your number")
            return false
        }
        return true
    }

    func normalLoginByUser(email:String,password:String) ->Promise<FirebaseAuth.User>{
         let p = Promise<FirebaseAuth.User> { (resolve , reject) in
             Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//                print(error)
//                print(result)
                 if let err = error {
                     reject(err)
                    return
                 }
                 print("login by email success ,show main page")

                UserDefaults.standard.set(1, forKey: UserDefaultsKey.LoginFlag)
                resolve(result!.user)
             }
         }
         return p
     }

    func showAppleLogin() {
        let nonce = Utility.randomNonceString()
        Utility.currentNonce = nonce
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email ]
        request.nonce = sha256(nonce)
        performSignIn(using: [request])
    }
    func performSignIn(using requests: [ASAuthorizationRequest]) {
        appleSignInDelegates = SignInWithAppleDelegates()
        let controller = ASAuthorizationController(authorizationRequests: requests)
        controller.delegate = appleSignInDelegates
        //        controller.presentationContextProvider = appleSignInDelegates

        controller.performRequests()
    }


    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
}
