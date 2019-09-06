import UIKit
import Firebase
import GoogleSignIn

class LoginController: UIViewController  ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout ,SignControllerDelegrate {
    func successLogin() {
        
    }
    
    let cellId = "CellId"
    
    weak var delegrate : FrontController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = pages.count
        setupView()
    }
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.addDefaultGradient()
        cv.register(LoginCell.self, forCellWithReuseIdentifier: self.cellId)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let pages : [Page] =
        [
        Page(title: "Page1", image: "splash1", massage: "This the the message \n Plah jjdfhjkasdf"),
        Page(title: "Page2", image: "splash2", massage: "This page 2 message \n Plah Thank you "),
        Page(title: "Page3", image: "splash3", massage: "This is page 3 message \n Plah jjdfhjkasdf")
        ]
        
    let pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = UIColor.white
        return pc
    }()
    
    func setupView(){
        view.addSubview(collectionView)
        collectionView.Anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, topPadding: 0  , leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height:0)
        view.addSubview(stackView)
        stackView.Anchor(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, topPadding: 0  , leftPadding: 8, rightPadding: 8, bottomPadding: 8, width: 0, height:100)
        view.addSubview(pageControl)
        pageControl.Anchor(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: stackView.topAnchor, topPadding: 0  , leftPadding: 8, rightPadding: 8, bottomPadding: 8, width: 0, height:0)
    }
   
    let siginButton : UIButton = {
        let bn = UIButton()
        let text = NSAttributedString(string: "Sign in", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20),NSAttributedString.Key.foregroundColor:UIColor.white])
        bn.setAttributedTitle(text, for: .normal)
        bn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return bn
    }()
    
    let registerButton : UIButton = {
        let bn = UIButton()
        let text = NSAttributedString(string: "Join Now", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20),NSAttributedString.Key.foregroundColor:UIColor.white])
        bn.setAttributedTitle(text, for: .normal)
        bn.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        bn.layer.borderWidth = 0.5
        bn.layer.borderColor = UIColor.white.cgColor

        return bn
    }()
    
    lazy var stackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.addArrangedSubview(self.registerButton)
        sv.addArrangedSubview(self.siginButton)
        sv.backgroundColor = UIColor.red
        return sv
    }()
    
    
    @objc func handleLogin(){
        let vc = SiginViewController()
        vc.delegrate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func handleRegister(){
        let vc = RegisterViewController()
        vc.delegrate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
}



