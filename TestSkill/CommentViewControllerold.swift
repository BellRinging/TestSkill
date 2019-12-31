import UIKit
import Firebase

class CommentViewController:
UIViewController ,UICollectionViewDataSource ,UICollectionViewDelegate ,UITextViewDelegate ,UICollectionViewDelegateFlowLayout ,UIViewControllerTransitioningDelegate {

    var collectionView: UICollectionView!
    let cellId = "cellId"
    let placeHolderText = "Enter the comment"
    var con : NSLayoutConstraint?
    var post: Post?
    var comments  = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
        navigationController?.view.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.white
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        navigationItem.title = "Comments"
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.register(CommentViewControllerCell.self, forCellWithReuseIdentifier: cellId)
        setupLayout()
        fetchComment()
        addObserver()
    }
    
    func addObserver(){
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc func keyboardWillAppear(_ sender:NSNotification) {
        //Do something here
        let info = sender.userInfo!
        let keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
//        print("keyboard show")
        con?.isActive = false
        con?.constant = UIScreen.main.bounds.height - keyboardHeight
        con?.isActive = true
//        print("view frame",view.frame)
    }

    @objc func keyboardWillDisappear(_ sender:NSNotification) {
//        print("keyboard hide")
        con?.isActive = false
        con?.constant = UIScreen.main.bounds.height
        con?.isActive = true
        perform(#selector(scrollToLast),with: nil, afterDelay: 0.3)
    }
    
    @objc func scrollToLast(){
        if self.comments.count > 0 {
            let indexPath = IndexPath(item: self.comments.count-1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: true)
        }
    }

    func setupLayout(){
        view.addSubview(collectionView)
        view.addSubview(containerView)
        collectionView.Anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: containerView.topAnchor, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        containerView.Anchor(top: collectionView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        self.con = view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
    }

    func fetchComment(){
        self.comments.removeAll()
        guard let postId = post?.id else {return}
        let ref = Database.database().reference().child("comments").child(postId)

        ref.observe(.childAdded, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {return}
            guard let uid = dict["uid"] as? String else { return }
//            Database.fetchUserWithUID(uid: uid, completion: { (user) in
//                let comment = Comment(user: user, dictionary: dict)
//                self.comments.append(comment)
//                self.collectionView.reloadData()
//            })
        })
    }

    func collectionView(_ : UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentViewControllerCell
        cell.comment = comments[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

    @objc func handleSubmit() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let postId = self.post?.id ?? ""
//        print("submit",postId)
//        print("uid",uid)
        let values = ["text": commentTextField.text ?? "", "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (err, ref) in

            if let err = err {
                print("Failed to insert comment:", err)
                return
            }
            self.commentTextField.text = ""
            self.commentTextField.resignFirstResponder()
            self.collectionView.reloadData()
            print("Successfully inserted comment.")
        }
    }

    lazy var commentTextField: UITextView = {
        let textField = UITextView()
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.delegate = self
        textField.addSubview(self.placeholderLabel)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isScrollEnabled = false
        self.placeholderLabel.Anchor(top: nil, left: textField.leftAnchor, right: nil, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        self.placeholderLabel.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
        return textField
    }()

    lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Enter some text..."
        placeholderLabel.textColor = UIColor.lightGray
        return placeholderLabel
    }()

    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        containerView.addSubview(submitButton)
        submitButton.Anchor(top: containerView.topAnchor, left: nil, right: containerView.rightAnchor, bottom: containerView.bottomAnchor, topPadding: 0, leftPadding: 0, rightPadding: 12, bottomPadding: 0, width: 50, height: 0)
        containerView.addSubview(self.commentTextField)
        self.commentTextField.Anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: submitButton.leftAnchor, bottom: containerView.bottomAnchor, topPadding: 0, leftPadding: 12, rightPadding: 0, bottomPadding: 0, width: 0)
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        containerView.addSubview(lineSeparatorView)
        lineSeparatorView.Anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0.5)
        return containerView
    }()


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        commentTextField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.removeObserver(self)
        con?.isActive = false
        view.translatesAutoresizingMaskIntoConstraints = true
    }


    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        commentTextField.resignFirstResponder()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        commentTextField.resignFirstResponder()
    }

}
