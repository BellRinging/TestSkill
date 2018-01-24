import UIKit
import Firebase

class CommentController: UICollectionViewController  ,UICollectionViewDelegateFlowLayout  ,CommentInputViewDelegate {

    let cellId = "cellId"
    let placeHolderText = "Enter the comment"
    var con : NSLayoutConstraint?
    var post: Post?
    var comments  = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.view.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.white
        navigationItem.title = "Comments"
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.register(CommentViewControllerCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        fetchComment()
    }


    func scrollToLast(){
        if self.comments.count > 0 {
            let indexPath = IndexPath(item: self.comments.count-1, section: 0)
            scrollToLast()
//            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
        }
    }

    func fetchComment(){
        self.comments.removeAll()
        guard let postId = post?.id else {return}
        let ref = Database.database().reference().child("comments").child(postId)

        ref.observe(.childAdded, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {return}
            guard let uid = dict["uid"] as? String else { return }
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                let comment = Comment(user: user, dictionary: dict)
                self.comments.append(comment)
                self.collectionView?.reloadData()
            })
        })
    }

    override func collectionView(_ : UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentViewControllerCell
        cell.comment = comments[indexPath.row]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentViewControllerCell(frame: frame)
        dummyCell.comment = comments[indexPath.row]
        dummyCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }

    func handleSubmit(text:String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let postId = self.post?.id ?? ""
        let values = ["text": text , "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (err, ref) in

            if let err = err {
                print("Failed to insert comment:", err)
                return
            }
            self.containerView.commentTextField.text = ""
            self.inputAccessoryView?.resignFirstResponder()
            self.collectionView?.reloadData()
            print("Successfully inserted comment.")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        inputAccessoryView?.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        inputAccessoryView?.resignFirstResponder()
//    }
//
//    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        inputAccessoryView?.resignFirstResponder()
//    }
    

    override var inputAccessoryView: UIView? {
        get {
            print("input view ")
            return containerView
        }
    }
    lazy var containerView: CommentInputView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        let commentInputAccessoryView = CommentInputView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
    }()
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
}


