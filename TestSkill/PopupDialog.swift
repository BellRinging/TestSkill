
import UIKit

class PopupDialog: UIView {
    
    
    
    
    let popupDialogHeight : CGFloat = 60.0
    weak var delegrate : UIViewController?
    
    var message : String?{
        didSet{
            messageLabel.text = message!
            messageLabel.sizeToFit()
        }
    }
    
    let messageLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.darkGray
        lb.numberOfLines = 0
        lb.adjustsFontSizeToFitWidth = true
        lb.lineBreakMode = NSLineBreakMode.byCharWrapping
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()
    
    let crossButton : UIButton = {
        let bn = UIButton()
        bn.setImage(#imageLiteral(resourceName: "icons8-Delete-48"), for: .normal)
        bn.imageView?.contentMode = .scaleToFill
        bn.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        return bn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init")
        let width = UIScreen.main.bounds.width
        self.frame = CGRect(x: 0, y: -self.popupDialogHeight, width: width, height: self.popupDialogHeight)
        self.backgroundColor = UIColor.white
        
        addSubview(crossButton)
        crossButton.Anchor(top: nil, left: leftAnchor, right: nil, bottom: nil, topPadding: 0, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        crossButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        addSubview(messageLabel)
        
        messageLabel.Anchor(top: nil, left: crossButton.rightAnchor, right: rightAnchor, bottom: nil, topPadding: 0, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func handleTap(){
        dismissDialog()
    }
    
    func dismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            var origal = self.frame
            origal.origin.y = -100
            self.frame = origal
        }, completion:nil)
    }
    
    func showDialog() {
        guard let window = UIApplication.shared.keyWindow else {return}
        window.addSubview(self)
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let height = self.bounds.height
        let width = UIScreen.main.bounds.width
        self.frame = CGRect(x: 0, y: -height , width: width, height: height)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.frame = CGRect(x: 0, y: 0 + statusBarHeight, width: width, height: height)
        }, completion: {completed in
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                self.dismissDialog()
            })
        })
    }
    
    func dismissDialog() {
        guard let window = UIApplication.shared.keyWindow else {return}
        let height = self.frame.height
        let width = UIScreen.main.bounds.width
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.frame = CGRect(x: 0, y: -height, width: width, height: height)
        }, completion: { _ in
            var removeView = window.viewWithTag(100)
            removeView = nil
            removeView?.removeFromSuperview()
        })
    }
    
    
    
    
    
    
}
