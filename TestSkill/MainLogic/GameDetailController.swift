import UIKit
import FirebaseAuth
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import Promises

class GameDetailController: UICollectionViewController ,UICollectionViewDelegateFlowLayout{
    

    let cellID = "cellID"
    var gameDetails = [GameDetail]()
    var game : Game?{
        didSet{
            fetchGameDetail()
        }
    }
    var lastDoc : DocumentSnapshot?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(GameCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func fetchGameDetail(){
        print("fetchGameDetail")
        GameDetail.getAllItemById(gameId: game?.gameId ?? "", pagingSize: 40, lastDoc: lastDoc).then{ result in
            let list = result.0
            self.lastDoc = result.1
            self.collectionView.reloadData()
            
        }
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didselect item \(indexPath.item) available `item \(gameDetails.count) int item \(indexPath.row)")
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameDetails.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! GameDetailCell
        cell.gameDetail = gameDetails[indexPath.item]
        return cell
    }
    
}
