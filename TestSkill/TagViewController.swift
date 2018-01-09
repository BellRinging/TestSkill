import UIKit
import FirebaseAuth
import FacebookLogin
import Firebase

class TagViewController: UICollectionViewController ,UICollectionViewDelegateFlowLayout{
    
    
    var tag : Tag? {
        didSet{
            
        }
    }
    
    var fetchSize : Int = 40
    let headerID = "headerID"
    let footerID = "footerID"
    let cellID = "cellID"
    var posts = [Post]()
    var user : User?
    var headerCell : ProfileHeaderCell?
    var footerCell : ProfileFooterCell?
    var lastRecordUid : String?
    var isUpdating = false
    var isScrolling = false
    var totalNumberOfPost = Int()
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(SinglePhotoCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(TagViewHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: headerID)
        refreshControl.addTarget(self, action: #selector(fetchPost), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        self.collectionView?.reloadData()
    }
//
    
    func fetchPost(){
        
    }
    
    /*
    func fetchPost(){
        //        return
        guard let tag = self.tag else {
            isUpdating = false
            return
        }
        refreshControl.endRefreshing()
        print("fetchPost from tag \(tag.id)")
        self.posts = [Post]()
        self.collectionView?.reloadData()
        lastRecordUid = nil
        
        let ref = Database.database().reference().child("tags").child()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String:Any] {
                self.totalNumberOfPost = dict.count
                print("Total post count : \(self.totalNumberOfPost)")
                self.loadMore()
            }else{
                self.isUpdating = false
            }
        })
        
    }
//
    func loadMore(){
        //        print("load more")
        guard let user = self.tag else {
            isUpdating = false
            return
        }
        let initialDataFeed = posts.count
        let fetchSizeOffSet = initialDataFeed == 0 ? 0:1
        var query : DatabaseQuery
        if ( totalNumberOfPost <= initialDataFeed) {
            print("No More data")
            footerCell?.status = 1
            isUpdating = false
            return
        }else {
            query = Database.database().reference().child("tags").child(user.id).queryOrderedByKey().queryLimited(toFirst: UInt(fetchSize + fetchSizeOffSet))
            footerCell?.status = 0
        }
        
        if let lastId = lastRecordUid {
            query = query.queryStarting(atValue: lastId)
        }
        print("tag id \(tag.id)")
        print("last id \(lastRecordUid)")
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String:Any] {
                print(dict.count)
                dict.forEach({ (key,value) in
                    guard let postDict = value as? [String: Any] else {return}
//                    let post = Post(user: user , dict: postDict as [String : AnyObject])
                    post.id = key
                    if (self.posts.contains(where: { (post) -> Bool in
                        guard let id = post.id else {return false}
                        return id == key
                    })){
                        //                        print("Post reject")
                    }else{
                        //                        print("Post added")
                        self.posts.append(post)
                    }
                })
                self.posts = self.posts.sorted(by: { $0.id! < $1.id!
                })
                self.lastRecordUid = self.posts.last?.id
                if ( self.totalNumberOfPost <= self.posts.count) {
                    print("No More data")
                    self.footerCell?.status = 1
                }
                self.collectionView?.reloadData()
            }
            self.isUpdating = false
            print("finish fetch")
        })
    }
    */
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //        print("scrolling")
        isScrolling = true
    }
    
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //        print("finish scrolling")
        isScrolling = false
        if posts.count < fetchSize {
            return
        }
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom <= height {
            print(" you reached end of the table")
//            loadMore()
        }
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        print("didselect item \(indexPath.item) available item \(posts.count) int item \(indexPath.row)")
        let vc = DisplayPhotoView()
        let post = posts[indexPath.item] as Post
        vc.imageUrl = post.imageUrl
        self.present(vc, animated: true, completion: nil)
        //        print("4")
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-3)/4
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SinglePhotoCell
        //        print("Index path size \(indexPath.item)")
        //        print("Post size \(posts.count)")
        cell.post = posts[indexPath.item]
        return cell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //        print("Config the header cell \(kind)" )
        if (kind == UICollectionElementKindSectionHeader){
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath)  as! ProfileHeaderCell
            headerCell = cell
            cell.backgroundColor = UIColor.white
            cell.user = self.user
            return cell
        }else{
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerID, for: indexPath)  as! ProfileFooterCell
            footerCell = cell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let height = 80 + 8 + 8 + 30 + 1 + 20 + 8
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

