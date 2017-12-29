import Firebase
extension HomeViewController{
    
    
    func didTapChat(user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func didTapOption(for cell: HomeViewControllerCell){
        let alert = UIAlertController(title: nil, message: "Select action", preferredStyle: UIAlertControllerStyle.actionSheet)
        let editAction = UIAlertAction(title: "Edit", style: UIAlertActionStyle.default){
            (action) -> Void in
            guard let indexPath = self.collectionView?.indexPath(for: cell) else { return }
            let shareView = SharePhotoController()
            shareView.editFlag = 1
            shareView.post = cell.post
            let nav = UINavigationController(rootViewController: shareView)
            self.present(nav, animated: true, completion: nil)
        }
        alert.addAction(editAction)
        let alertAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive)
        {
            (action) -> Void in
            
            let alert2 = UIAlertController(title: nil, message: "Confirm to delete?", preferredStyle: UIAlertControllerStyle.alert)
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive){
                action -> Void in
                guard let indexPath = self.collectionView?.indexPath(for: cell) else { return }
                self.deleteUserPost(index: indexPath.item)
            }
            let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default){
                (action) -> Void in
                print("Cancel")
            }
            alert2.addAction(yesAction)
            alert2.addAction(noAction)
            self.present(alert2, animated: true, completion: nil)
        }
        alert.addAction(alertAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            (action) -> Void in
            print("Cancel")
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    

    
    func didShare(for cell: HomeViewControllerCell) {
        print("Share")
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.item]
        guard let postId = post.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print(post.caption)
        post.caption.share()
        
    }
    
    func didTagImage(for cell: HomeViewControllerCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.item]
        let vc = DisplayPhotoView()
        vc.imageUrl = posts[indexPath.row].imageUrl
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func didTapComment(post: Post) {
        let commentsController = CommentViewController()
        
//        let av = ViewController()
        commentsController.post = post
        //        let commentsController = UIViewController()
//        self.present(commentsController, animated: true, completion: nil)
        
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    
    func handleRefresh(){
        posts.removeAll()
        collectionView?.reloadData()
        fetchPost()
    }
    
    func handleUpdateFeed() {
        handleRefresh()
    }
    
    
    func handleCarema(){
        print("Carema")
        let vc = CameraController()
        self.present(vc, animated: true, completion: nil)
        
    }
    
}
