
import Foundation
import UIKit

class ProfileFooterCell: UICollectionViewCell {
    
    var status : Int? {
        didSet{
            if let sts = status , sts == 1 {
//                refreshControl.beginRefreshing()
                endOfRecordLabel.isHidden = true
//                refreshControl.isHidden = false
                endOfRecordLabel.text = "end of loading"
            }else {
//                refreshControl.endRefreshing()
                endOfRecordLabel.isHidden = false
//                refreshControl.isHidden = true
                endOfRecordLabel.text = "loading more"
                
            }
        }
    }
        
    

    
    func handleRefresh(){
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViewLayout(){
        //header part
//        addSubview(refreshControl)
//        refreshControl.translatesAutoresizingMaskIntoConstraints = false
//        refreshControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        refreshControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(endOfRecordLabel)
        
//        endOfRecordLabel.Anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        endOfRecordLabel.translatesAutoresizingMaskIntoConstraints = false
        endOfRecordLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        endOfRecordLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    let endOfRecordLabel : UILabel = {
        let lb = UILabel()
        lb.text = "loading more.."
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.sizeToFit()
        return lb
    }()

    
    
}


