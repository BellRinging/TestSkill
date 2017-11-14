
import Foundation
import UIKit

class ProfileFooterCell: UICollectionViewCell {
    
    var status : Int? {
        didSet{
            if let sts = status , sts == 1 {
                refreshControl.beginRefreshing()
                endOfRecordLabel.isHidden = true
                refreshControl.isHidden = false
            }else {
                refreshControl.endRefreshing()
                endOfRecordLabel.isHidden = false
                refreshControl.isHidden = true
                
            }
        }
    }
        
    
    
    let refreshControl = UIRefreshControl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViewLayout(){
        //header part
        addSubview(refreshControl)
        refreshControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        refreshControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(endOfRecordLabel)
        endOfRecordLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        endOfRecordLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    let endOfRecordLabel : UILabel = {
        let lb = UILabel()
        lb.text = "End of record.."
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        return lb
    }()

    
    
}


