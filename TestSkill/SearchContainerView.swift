//
//  searchViewController.swift
//  SnookerGambling
//
//  Created by Kwok Wai Yeung on 1/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SearchContainerView: UICollectionViewController   {
    
    
    var filteredUsers = [User]()
    var users = [User]()
    let cellId = "cellId"
    
    
    lazy var searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter the User"
        sb.delegate = self
        sb.barTintColor = UIColor(white: 0, alpha: 30)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(SearchViewControllerCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        setupViewLayout()
        fetchAllUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.isHidden = false
    }
    
    func setupViewLayout(){
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(searchBar)
        searchBar.Anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, right: navBar?.rightAnchor, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 8, bottomPadding: 0, width: 0, height: 50)
        
    }
    
    
    func fetchAllUser(){
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {return }
            dict.forEach({ (key,value) in
                if key == Auth.auth().currentUser?.uid {
                    print("found myself")
                }else{
                    guard let userProfileDict = value as? [String: Any] else {return}
//                    let user = User(dictionary: userProfileDict as [String : AnyObject])
//                    self.users.append(user)
                }
                
            })
            self.filteredUsers = self.users
            self.collectionView?.reloadData()
        })
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let vc = ProfileViewController(collectionViewLayout: layout)
//        vc.user = filteredUsers[indexPath.row]
        searchBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    
    
    
}

