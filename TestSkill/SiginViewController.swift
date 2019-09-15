import UIKit
import SwiftyJSON
import Firebase
import FBSDKLoginKit
import GoogleSignIn

protocol SignControllerDelegrate {
    func successLogin()
}

class SiginViewController: UIViewController   {
    
    weak var delegrate :LoginController?
    let button = FBLoginButton()
    
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
        
//        view.addSubview(signInButton)
//        signInButton.Anchor(top: forgetPasswordButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 4, rightPadding: 4, bottomPadding: 0, width: 0, height: 0)
//
//
       
        view.addSubview(facebookButton)
        facebookButton.Anchor(top: forgetPasswordButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        
        view.addSubview(googleButton)
                (googleButton).Anchor(top: facebookButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        
//        button.delegate = self
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

    var facebookButton: UIButton = {
        let facebookButtonOutlet = UIButton()
        facebookButtonOutlet.setTitle("Sign in with Facebook", for: UIControl.State.normal)
        facebookButtonOutlet.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        facebookButtonOutlet.backgroundColor = UIColor(red: 58/255, green: 85/255, blue: 159/255, alpha: 1)
        facebookButtonOutlet.layer.cornerRadius = 5
        facebookButtonOutlet.clipsToBounds = true
        
        facebookButtonOutlet.setImage( #imageLiteral(resourceName: "icon-facebook"), for: UIControl.State.normal)
        facebookButtonOutlet.imageView?.contentMode = .scaleAspectFit
        facebookButtonOutlet.tintColor = .white
        facebookButtonOutlet.imageEdgeInsets = UIEdgeInsets(top: 12, left: -15, bottom: 12, right: 0)
        facebookButtonOutlet.addTarget(self, action: #selector(SignInByFacebook), for: .touchUpInside)
        return facebookButtonOutlet
        
        }()
    
    
    var googleButton : UIButton = {
        let googleButtonOutlet = UIButton()

        googleButtonOutlet.setTitle("Sign in with Google", for: UIControl.State.normal)
        googleButtonOutlet.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        googleButtonOutlet.backgroundColor = UIColor(red: 223/255, green: 74/255, blue: 50/255, alpha: 1)
        googleButtonOutlet.layer.cornerRadius = 5
        googleButtonOutlet.clipsToBounds = true
        
        googleButtonOutlet.setImage(UIImage(named: "icon-google") , for: UIControl.State.normal)
        googleButtonOutlet.imageView?.contentMode = .scaleAspectFit
        googleButtonOutlet.tintColor = .white
        googleButtonOutlet.imageEdgeInsets = UIEdgeInsets(top: 12, left: -35, bottom: 12, right: 0)
        
        return googleButtonOutlet
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
