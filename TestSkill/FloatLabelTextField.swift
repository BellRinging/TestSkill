import UIKit

@IBDesignable class FloatLabelTextField: UITextField {
    let animationDuration = 0.5
    var title = UILabel()
    var isShowingTitle : Bool = false
    var placeHolderYPostion : CGFloat = 0.0
    var firstSet : Int = 1
    var defaultFont : UIFont = UIFont.systemFont(ofSize: 12)
    
    
    let leftPadding : UIView = {
        let paddingView = UIView()
        //        paddingView.backgroundColor = UIColor.red
        paddingView.frame = CGRect(x: 0, y: 0, width: 10.0, height: 20)
        return paddingView
    }()
    
    
    let rightButton : UIButton = {
        let paddingView = UIButton(type: .system)
        paddingView.setTitle("Show  ", for: .normal)
        paddingView.addTarget(self, action: #selector(handleSwitch), for: .touchUpInside)
        paddingView.sizeToFit()
        return paddingView
    }()
    
    @objc func handleSwitch(){
//        print(rightButton.titleLabel?.text )
        if rightButton.titleLabel?.text == "Show  " {
//            print("true")
            self.isSecureTextEntry = false
            rightButton.setTitle("Hide  ", for: .normal)
            rightButton.sizeToFit()
        }else {
//            print("false")
            self.isSecureTextEntry = true
            rightButton.setTitle("Show  ", for: .normal)
            rightButton.sizeToFit()
        }
    }
    
    
    // MARK:- Properties
    override var accessibilityLabel:String? {
        get {
            if let txt = text , txt.isEmpty {
                return title.text
            } else {
                return text
            }
        }
        set {
            self.accessibilityLabel = newValue
        }
    }
    
    
    var fakePlaceholder:String? {
        didSet {
            title.text = fakePlaceholder
        }
    }
    
    var titleFont:UIFont = UIFont.boldSystemFont(ofSize: 12){
        didSet {
            title.font = titleFont
            title.sizeToFit()
        }
    }
    
    @IBInspectable var hintYPadding:CGFloat = 0.0
    
    @IBInspectable var titleYPadding:CGFloat = 8.0 {
        didSet {
            var r = title.frame
            r.origin.y = titleYPadding
            title.frame = r
        }
    }
    
    @IBInspectable var titleTextColour:UIColor = UIColor.gray {
        didSet {
            title.textColor = titleTextColour
        }
    }
    
    @IBInspectable var titleActiveTextColour:UIColor = UIColor.green {
        didSet {
            if isFirstResponder {
                title.textColor = titleActiveTextColour
            }
        }
    }
    
    // MARK:- Init
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    // MARK:- Overrides
    override func layoutSubviews() {
//        print("layoutsubviews")
        super.layoutSubviews()
        if let txt = text , !txt.isEmpty  {
            title.textColor = titleActiveTextColour
        } else {
            title.textColor = titleTextColour
        }
        if let txt = text , txt.isEmpty {
            hideTitle()
        } else {
            if (!isShowingTitle){
                showTitle()
            }
            
        }
    }
    
    override func textRect(forBounds bounds:CGRect) -> CGRect {
        var r = super.textRect(forBounds: bounds)
        if let txt = text , !txt.isEmpty {
            let top = maxTopInset()
            r = r.inset(by: UIEdgeInsets(top: top, left: 0, bottom: 0.0, right: 0.0))
        }
        
        return r.integral
    }
    
    override func editingRect(forBounds bounds:CGRect) -> CGRect {
        var r = super.editingRect(forBounds: bounds)
        if let txt = text , !txt.isEmpty {
            let top = maxTopInset()
            r = r.inset(by: UIEdgeInsets(top: top, left: 0, bottom: 0.0, right: 0.0))
        }
        return r.integral
    }
    
    override func clearButtonRect(forBounds bounds:CGRect) -> CGRect {
        var r = super.clearButtonRect(forBounds: bounds)
        if let txt = text , !txt.isEmpty {
            let top = maxTopInset()
            r = CGRect(x:r.origin.x, y:r.origin.y + (top * 0.5), width:r.size.width, height:r.size.height)
        }
        return r.integral
    }
    
    fileprivate func setup() {
        if (firstSet==1){
            firstSet = 0
            defaultFont = self.font!
//            print("Default font : \(self.font) height : \(self.font?.lineHeight)")
        }
        
        self.spellCheckingType = .no
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.borderStyle = .none
        titleActiveTextColour = tintColor
        title.font = self.font
        self.addSubview(title)
        self.leftViewMode = .always
        self.leftView = leftPadding
    }
    
    fileprivate func maxTopInset()->CGFloat {
        if let fnt = font {
            return max(0, floor(bounds.size.height - fnt.lineHeight - 4.0 - titleYPadding))
            //4.0 is padding bottom
        }
        return 0
    }
    
    fileprivate func showTitle() {
//        print("showTitle")
        isShowingTitle = true
        self.titleFont = defaultFont
//        print("title font : \(titleFont)")
        let posY = (self.bounds.height - self.titleFont.lineHeight) / 2
//        print("titleFont height : \(self.titleFont.lineHeight)")
        var r = self.textRect(forBounds: self.bounds)
        r.origin.y = posY
        title.frame = r
//        print("start position : \(title.frame)")
        
        let dur =  animationDuration
        UIView.animate(withDuration: dur, delay: 0, options: AnimationOptions.beginFromCurrentState, animations: {
                var r = self.textRect(forBounds: self.bounds)
                r.origin.y = 0
                self.title.font  = UIFont.boldSystemFont(ofSize: 12)
                self.title.frame = r
        }, completion: nil)
        

        
//            print("textRect \(self.title.frame)")
    }
    
    fileprivate func hideTitle() {
//        print("hideTitle")
        isShowingTitle = false
        let dur = animationDuration
        UIView.animate(withDuration: dur, delay: 0, options: AnimationOptions.beginFromCurrentState, animations: {
            self.titleFont = self.defaultFont
            self.title.frame = self.textRect(forBounds: self.bounds)
        }, completion: nil)
        
    }
}
