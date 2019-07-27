import UIKit
import FacebookCore
import FacebookLogin
import SwiftyJSON
import Firebase


class ForgetPasswordController: UIViewController   {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addDefaultGradient()
        setupView()
    }
    
    func setupView(){
        view.addSubview(stackView)
        stackView.Anchor(top: view.topAnchor, left: view.leftAnchor , right: view.rightAnchor, bottom: nil, topPadding: 18   , leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        stackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        view.addSubview(sendRequestButton)
        sendRequestButton.Anchor(top: stackView.bottomAnchor, left: view.leftAnchor , right: view.rightAnchor, bottom: nil, topPadding: 8   , leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 50)
    }

    
    lazy var stackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.addArrangedSubview(self.crossImageView)
        sv.addArrangedSubview(self.emailField)
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
    
    let sendRequestButton : UIButton = {
        let bn = UIButton()
        let text = NSAttributedString(string: "Send Request", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.white])
        bn.setAttributedTitle(text, for: .normal)
        bn.addTarget(self, action: #selector(RequestForPasswordByEmail), for: .touchUpInside)
        bn.layer.borderWidth = 0.5
        bn.layer.borderColor = UIColor.white.cgColor
        return bn
    }()
    
    
    @objc func RequestForPasswordByEmail(){
        print("SignIn by Email")
        guard let email = Utility.validField(emailField, "Email is required.Please enter your email") else {
                Utility.showError(self,message: Utility.errorMessage!)
                return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let err = error {
                Utility.showError(self,message: err.localizedDescription)
                return
            }
            
            Utility.showPopUpDialog(viewController: self, message: "Send", completion: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
        }
        
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    
    
    
}

