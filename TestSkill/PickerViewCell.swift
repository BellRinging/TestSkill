//
//  PickerViewCell.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 15/10/2019.
//  Copyright © 2019 Kwok Wai Yeung. All rights reserved.
//

import Foundation

class PickerViewController : UIViewController,UIPickerViewDelegate, UIPickerViewDataSource{
    
    var winner : String = ""{
        didSet{
            updateLabel(text: winner)
        }
    }
    var fanArray:[String] = []
    var losePlayerArray:[String] = []
    
    var numberOfComponents : Int = 2
    var perviousNumberOfComponents : Int = 2
    var labelTexts = ["Winer", "Loser"]
    var gameResult : GameDetailResult = GameDetailResult()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let alertView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 15
        return v
    }()
    
    let okButton: UIButton = {
        let bn = UIButton()
        bn.setTitle("Ok", for: .normal)
//        bn.backgroundColor = .red
        bn.setTitleColor(.black, for: .normal)
        bn.addTarget(self, action: #selector(onTapOkButton), for: .touchUpInside)
        return bn
     }()
    
    let cancelButton: UIButton = {
        let bn = UIButton()
        bn.setTitle("Cancel", for: .normal)
        bn.setTitleColor(.black, for: .normal)
//        bn.backgroundColor = .green
        bn.addTarget(self, action: #selector(onTapCancelButton), for: .touchUpInside)
        return bn
     }()
    
    lazy var bottomStackView : UIStackView = {
          let sv = UIStackView()
          sv.axis = .horizontal
        sv.layer.borderWidth = 1
        sv.layer.borderColor = UIColor.black.cgColor
        sv.distribution = .fillEqually
        sv.addArrangedSubview(self.okButton)
        sv.addArrangedSubview(self.cancelButton)
        sv.spacing = 8
          return sv
      }()
    func updateLabel(text : String){
        descLabel.text = " \(winner) 食糊啦!"
    }
    
    var delegate: CustomAlertViewDelegate?
       var selectedOption = "First"
       let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    
    func animateView() {
//        alertView.alpha = 0;
//        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
//        UIView.animate(withDuration: 0.4, animations: { () -> Void in
//            self.alertView.alpha = 1.0;
//            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
//        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateView()
    }
    
    @objc func onTapCancelButton(_ sender: Any) {
        picker.resignFirstResponder()
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onTapOkButton() {
        picker.resignFirstResponder()
        delegate?.okButtonTapped(result: gameResult)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    let picker : UIPickerView  = {
        let picker = UIPickerView()
        return picker
    }()
    
    let descLabel : UILabel  = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    
    let fanLabel : UILabel  = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "番"
        return label
    }()
    
    let loseLabel : UILabel  = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "出沖者"
        return label
    }()
    
    lazy var pickerLabelStackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.addArrangedSubview(self.fanLabel)
        sv.addArrangedSubview(self.loseLabel)
        return sv
    }()
    

    
    lazy var toogleButtonStackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fill
        let label = UILabel()
        label.text = "出沖者包自摸"
        let stretchingView = UIView()
        stretchingView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stretchingView.backgroundColor = .clear
        stretchingView.translatesAutoresizingMaskIntoConstraints = false
        sv.addArrangedSubview(stretchingView)
        sv.addArrangedSubview(label)
        sv.addArrangedSubview(self.toogle)
        sv.addArrangedSubview(stretchingView)
        return sv
    }()
    
    let toogle : UISwitch  = {
        let switchControl = UISwitch()
        switchControl.setOn(false, animated: false)
        return switchControl
    }()
    
    func setupView(){
        
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.8)
        
        picker.becomeFirstResponder()
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self
        
        view.addSubview(alertView)
        alertView.Anchor(top: view.topAnchor, left: view.leftAnchor , right: view.rightAnchor, bottom: view.bottomAnchor, topPadding: 0   , leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        alertView.addSubview(descLabel)
        descLabel.Anchor(top: alertView.topAnchor, left: alertView.leftAnchor , right: alertView.rightAnchor, bottom: nil, topPadding: 8   , leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        
        alertView.addSubview(pickerLabelStackView)
        pickerLabelStackView.Anchor(top: descLabel.bottomAnchor, left: alertView.leftAnchor , right: alertView.rightAnchor, bottom: nil, topPadding: 8   , leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 20)
        
        alertView.addSubview(picker)
        picker.Anchor(top: pickerLabelStackView.bottomAnchor, left: alertView.leftAnchor , right: alertView.rightAnchor, bottom: nil, topPadding: 8   , leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 150)
        
        alertView.addSubview(toogleButtonStackView)
        toogleButtonStackView.Anchor(top: picker.bottomAnchor, left: nil , right: nil, bottom: nil, topPadding: 8   , leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        toogleButtonStackView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor).isActive = true
        
        
        
        alertView.addSubview(bottomStackView)
        bottomStackView.Anchor(top: toogleButtonStackView.bottomAnchor, left: alertView.leftAnchor , right: alertView.rightAnchor, bottom: nil, topPadding: 8   , leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
    }

    
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
            
           return numberOfComponents
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           if component == 0 {
               return fanArray.count
           }
           
           return losePlayerArray.count
       }
       
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           
           if component == 0 {
               return fanArray[row]
           }
           return losePlayerArray[row]
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let fanSelected = fanArray[pickerView.selectedRow(inComponent: 0)]
        if pickerView.selectedRow(inComponent: 0) ==  fanArray.count - 1  {
            numberOfComponents = 1
            gameResult.eatByError = true
            gameResult.whoLose = winner
        }else{
            numberOfComponents = 2
        }
        
        if numberOfComponents != perviousNumberOfComponents {
            perviousNumberOfComponents = numberOfComponents
            if perviousNumberOfComponents == 1 {
                loseLabel.isHidden = true
            }else{
                loseLabel.isHidden = false
            }
            pickerView.reloadAllComponents()
            return
        }
        
        
        if numberOfComponents == 2 {
            let loseSelected = losePlayerArray[pickerView.selectedRow(inComponent: 1)]
            gameResult.whoWin = winner
            gameResult.eatByError = false
            gameResult.eatByHimself = pickerView.selectedRow(inComponent: 1) == losePlayerArray.count - 1
            gameResult.whoLose = loseSelected
            
            if (pickerView.selectedRow(inComponent: 0) != (fanArray.count - 1 )){
//            print("\(fanSelected)")
                gameResult.fan = Int(fanSelected)!
//                print(gameResult.fan)
            }
            if (pickerView.selectedRow(inComponent: 1) == (losePlayerArray.count - 1 )){
                toogle.setOn(false, animated: true)
                toogle.isEnabled = false
            }else{
                toogle.isEnabled = true
            }
            gameResult.loserRespondForAll = toogle.isOn
            if (toogle.isOn){
                gameResult.eatByHimself = true
            }
            
        }
        
        
        
       }
    
       

}

protocol CustomAlertViewDelegate: class {
    func okButtonTapped(result: GameDetailResult)
    func cancelButtonTapped()
}


struct GameDetailResult{
    var whoWin : String
    var whoLose : String
    var fan : Int
    var eatByHimself : Bool
    var eatByError : Bool
    var loserRespondForAll : Bool
    
    init() {
        whoWin = ""
        whoLose = ""
        fan = 0
        eatByHimself = false
        eatByError = false
        loserRespondForAll = false
    }
}

extension PickerViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
