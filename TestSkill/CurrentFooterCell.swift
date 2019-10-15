
import Foundation
import UIKit

class CurrentFooterCell: UICollectionViewCell {
    
    var status : Int? {
        didSet{
            if let sts = status , sts == 1 {
                endOfRecordLabel.isHidden = true
                endOfRecordLabel.text = ""
            }else {
                endOfRecordLabel.isHidden = false
                endOfRecordLabel.text = "loading more"
                
            }
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViewLayout(){
        addSubview(endOfRecordLabel)
        endOfRecordLabel.translatesAutoresizingMaskIntoConstraints = false
        endOfRecordLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        endOfRecordLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    let endOfRecordLabel : UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.sizeToFit()
        return lb
    }()

    
    
}


