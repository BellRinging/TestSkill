
import Foundation

class GameViewController : UIViewController ,CustomAlertViewDelegate{
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
//        view.backgroundColor = .white
        
    }
    
    
    let player1 : UIButton  = {
        let bn = UIButton()
        bn.setTitle("Player A", for: .normal)
        bn.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
        bn.tag = 1
        return bn
    }()
    
    let player2 : UIButton  = {
        let bn = UIButton()
        bn.setTitle("Player B", for: .normal)
        bn.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
        bn.tag = 2
        return bn
    }()
    
    let player3 : UIButton  = {
        let bn = UIButton()
        bn.setTitle("Player C", for: .normal)
        bn.tag = 3
        bn.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
        return bn
    }()
    
    let player4 : UIButton  = {
        let bn = UIButton()
        bn.setTitle("Player D", for: .normal)
        bn.tag = 4
        bn.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
        return bn
    }()
    
    
    
    
    
    
    
    lazy var stackView : UIStackView = {
        let sv = UIStackView()
        sv.backgroundColor = .green
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.addArrangedSubview(player1)
        sv.addArrangedSubview(player2)
        sv.addArrangedSubview(player3)
        sv.addArrangedSubview(player4)
        return sv
    }()
    
    
    @objc func tapButton(sender: Any){
        guard let bn = sender as? UIButton else { return }
        
        let vc = PickerViewController()
        var fanArray = [String]()
        
        fanArray.append( "3")
        fanArray.append( "4")
        fanArray.append( "5")
        fanArray.append( "6")
        fanArray.append( "7")
        fanArray.append( "8")
        fanArray.append( "9")
        fanArray.append( "10")
        fanArray.append( "詐胡")
        var losePlayerArray = [String]()
        losePlayerArray.append( "康哥")
        losePlayerArray.append( "Bob")
        losePlayerArray.append( "Sugar")
        losePlayerArray.append( "Ricky")
        losePlayerArray.append( "自摸")
        vc.fanArray = fanArray
        vc.losePlayerArray = losePlayerArray
        vc.winner = "\(bn.tag)"
//        vc.providesPresentationContextTransitionStyle = true
//        vc.definesPresentationContext = true
//        vc.modalPresentationStyle = UIModalPresentationStyle.automatic
//        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    

        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    
    func setupView(){
        
        view.addSubview(stackView)
        stackView.Anchor(top: view.topAnchor, left: view.leftAnchor , right: view.rightAnchor, bottom: nil, topPadding: 8   , leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 400)
     
    }

    
     func okButtonTapped(result: GameDetailResult) {
   //        print("okButtonTapped with \(selectedOption) option selected")
            print("\(result)")
       }
       
       func cancelButtonTapped() {
           print("cancelButtonTapped")
       }

}


