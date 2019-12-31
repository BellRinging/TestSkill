import UIKit
import FirebaseAuth
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import Promises

class `CurrentViewController`: UICollectionViewController ,UICollectionViewDelegateFlowLayout{
    
    var fetchSize : Int = 4
    var endOfRecordFlag : Bool = false
    var lastDoc : DocumentSnapshot? = nil
    let headerID = "headerID"
    let footerID = "footerID"
    let cellID = "cellID"
    var headerCell : CurrentHeaderCell?
    var footerCell : CurrentFooterCell?
    var lastRecordUid : String?
    var isUpdating = false
    var isScrolling = false
    let refreshControl = UIRefreshControl()
    var games = [Game]()
    var user : User?
    var userGroup : UserGroup?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(CurrentHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        collectionView?.register(GameCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(CurrentFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerID)
        
        let barButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = barButton
        refreshControl.addTarget(self, action: #selector(fetchGame), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
  

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user2 = Auth.auth().currentUser else {return }
        User.getById(id: user2.uid).then{ result in
//            print(result)
            self.user = result
            self.fetchGame()
        }
    }
 //mark ABC
    
    @objc func fetchGame(){
//        refreshControl.endRefreshing
//        print("fetchGame")
        guard let user = self.user else {
            return
        }
        if (endOfRecordFlag == false){
            isUpdating = true
            print("fetchGame from user \(user.id)")
            let userId = user.id
            var gamePromise : Promise<([Game], DocumentSnapshot?)>
            if lastDoc == nil {
                gamePromise = Game.getItemWithUserId(userId: userId,pagingSize: fetchSize)
            }else{
                gamePromise = Game.getItemWithUserId(userId: userId,pagingSize: fetchSize, lastDoc: lastDoc!)
            }
            gamePromise.then{  result in
                let gameResultList = result.0
                self.lastDoc = result.1
                if (gameResultList.count < self.fetchSize){
                    print("end of record")
                    self.endOfRecordFlag = true
                    self.lastDoc = nil
                }else{
                    print("has more")
                }
                self.games.append(contentsOf: gameResultList)
                self.collectionView?.reloadData()
            }.catch{err in
                print(err.localizedDescription)
                Utility.showError(self, message: err.localizedDescription)
            }.always {
                self.refreshControl.endRefreshing()
                self.isUpdating = false
            }
        }
        
    }

    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrolling")
        isScrolling = true
    }
    

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("finish scrolling")
        isScrolling = false
        if games.count < fetchSize {
            return
        }
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom <= height {
            print(" you reached end of the table")
            fetchGame()
        }
    }
    
    @objc func handleProfileChange(){
     
    }
    
    
    @objc func handleLogout(){
        Utility.logout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didselect item \(indexPath.item) available `item \(games.count) int item \(indexPath.row)")
        let vc = GameDetailController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.game = games[indexPath.item] as Game
        navigationController?.pushViewController(vc, animated: true)
//        nav?.pushViewController(vc, animated: true)
//        present(vc, animated: true, completion: nil)
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! GameCell
        cell.game = games[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        print("Config the header cell \(kind)" )
        if (kind == UICollectionView.elementKindSectionHeader){
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath)  as! CurrentHeaderCell
            headerCell = cell
//            cell.backgroundColor = UIColor.green
//            cell.user = self.user
            return cell
        }else{
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerID, for: indexPath)  as! CurrentFooterCell
//            footerCell = cell
            cell.backgroundColor = UIColor.gray
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //header area height
        let height = 200
        return CGSize(width: view.frame.width, height: CGFloat(height))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: CGFloat(40))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    
    
}
