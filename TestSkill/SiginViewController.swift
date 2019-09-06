import UIKit
import FacebookCore
import SwiftyJSON
import Firebase
import FBSDKLoginKit
import FacebookLogin
import GoogleSignIn

protocol SignControllerDelegrate {
    func successLogin()
}

class SiginViewController: UIViewController   {
    
    weak var delegrate :LoginController?
    let button = FBLoginButton(permissions: [ .publicProfile ,.email ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addDefaultGradient()
        setupView()
        GIDSignIn.sharedInstance().uiDelegate = self
   
    }
    
    

    
    func setupView(){
        view.addSubview(stackView)
        stackView.Anchor(top: view.topAnchor, left: view.leftAnchor , right: view.rightAnchor, bottom: nil, topPadding: 18   , leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        stackView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        view.addSubview(normalSignInButton)
        normalSignInButton.Anchor(top: stackView.bottomAnchor, left: view.leftAnchor , right: view.rightAnchor, bottom: nil, topPadding: 8   , leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 50)
        view.addSubview(joinNowButton)
        joinNowButton.Anchor(top: normalSignInButton.bottomAnchor, left: nil , right: view.rightAnchor, bottom: nil, topPadding: 8   , leftPadding: 0, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        
        view.addSubview(forgetPasswordButton)
        forgetPasswordButton.Anchor(top: normalSignInButton.bottomAnchor, left: view.leftAnchor , right: nil, bottom: nil, topPadding: 8   , leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        
        view.addSubview(signInButton)
        signInButton.Anchor(top: forgetPasswordButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 4, rightPadding: 4, bottomPadding: 0, width: 0, height: 0)
        
        
       
        view.addSubview(button)
        button.Anchor(top: signInButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        
        button.delegate = self
    }
    
    let myActivityIndicator : UIActivityIndicatorView = {
        let im = UIActivityIndicatorView()
        return im
    }()
    
    lazy var stackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.addArrangedSubview(self.crossImageView)
        sv.addArrangedSubview(self.emailField)
        sv.addArrangedSubview(self.passwordField)
        return sv
    }()
    
    
    let crossImageView : UIView = {
        let temp = UIView()
        let ig = UIButton()
        ig.setImage(#imageLiteral(resourceName: "cancel_shadow"), for: .normal)
        temp.addSubview(ig)
        ig.Anchor(top: temp.topAnchor, left: nil, right: temp.rightAnchor, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0  )
        ig.addTarget(self, action: #selector(handleTapCross), for: .touchUpInside)
        
        return temp
    }()
    
    @objc func handleTapCross(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    let signInButton : GIDSignInButton = {
        let bn = GIDSignInButton()
        return bn
    }()
    
    let emailField : FloatLabelTextField = {
        let tv = FloatLabelTextField()
        tv.fakePlaceholder = "Email"
        tv.spellCheckingType = .no
        tv.autocorrectionType = .no
        tv.backgroundColor = UIColor.white
        tv.rightViewMode = UITextField.ViewMode.never
        tv.addBottomBorder(UIColor.gray, thickness: 0.5)
        return tv
    }()
    
    
    let passwordField : FloatLabelTextField = {
        let tv = FloatLabelTextField()
        tv.fakePlaceholder = "Password"
        tv.spellCheckingType = .no
        tv.autocorrectionType = .no
        tv.isSecureTextEntry = true
        tv.backgroundColor = UIColor.white
        tv.rightViewMode = .whileEditing
        tv.rightView = tv.rightButton
        return tv
    }()
    

    let forgetPasswordButton : UIButton = {
        let bn = UIButton()
        let text = NSAttributedString(string: "Forget the Password", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.white])
        bn.setAttributedTitle(text, for: .normal)
        bn.addTarget(self, action: #selector(handleForgetPassword), for: .touchUpInside)
        return bn
    }()
    
    @objc func handleForgetPassword(){
        
        let vc = ForgetPasswordController()
        self.present(vc, animated: true, completion: nil)
        print("forgetpassword")
    }
    
    @objc func handleJoinNow(){
        print("Join Now")
        self.dismiss(animated: true, completion: nil)
        delegrate?.handleRegister()
    }


    
    let joinNowButton : UIButton = {
        let bn = UIButton()
        let text = NSAttributedString(string: "Join Now", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.white])
        bn.setAttributedTitle(text, for: .normal)
        bn.addTarget(self, action: #selector(handleJoinNow), for: .touchUpInside)
        return bn
    }()
    
    let normalSignInButton : UIButton = {
        let bn = UIButton()
        let text = NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.white])
        bn.setAttributedTitle(text, for: .normal)
        bn.addTarget(self, action: #selector(SignInByEmail), for: .touchUpInside)
        bn.layer.borderWidth = 0.5
        bn.layer.borderColor = UIColor.white.cgColor
        return bn
    }()
    
    
    @objc func SignInByEmail(){
        print("SignIn by Email")
        
        guard let email = Utility.validField(emailField, "Email is required.Please enter your email"),
            let password = Utility.validField(passwordField,"Password is required.Please enter your number") else {
                Utility.showError(self,message: Utility.errorMessage!)
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error {
                Utility.showError(self,message: err.localizedDescription)
                return
            }
            print("User is login")
            self.dismissLogin()
        }
    }

    func dismissLogin(){
        print("Dismiss the login controller")
        self.dismiss(animated: true, completion: nil)
        self.delegrate?.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    
    
  

}
