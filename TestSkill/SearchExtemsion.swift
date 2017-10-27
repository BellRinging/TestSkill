//
//  SearchViewControllerExtension.swift
//  SnookerGambling
//
//  Created by Kwok Wai Yeung on 5/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

extension SearchViewController : UISearchBarDelegate ,UICollectionViewDelegateFlowLayout{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        }else{
            filteredUsers = users.filter { (user) -> Bool in
                
//                if let name = user.name {
//                    return name.lowercased().contains(searchText.lowercased())
//                }else {
//                    return false
//                }
                return false
            }
        }
        print("Refresh")
        print("\(filteredUsers.count)")
        collectionView?.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60+8+8)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchViewControllerCell
//        cell.user = filteredUsers[indexPath.row]
        //        cell.backgroundColor = UIColor.green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
}

