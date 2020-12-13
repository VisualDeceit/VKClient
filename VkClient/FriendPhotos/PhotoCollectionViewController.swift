//
//  PhotoCollectionViewController.swift
//  VkClient
//
//  Created by Alexander Fomin on 11.12.2020.
//

import UIKit

//private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController {
    
    //var userId: Int = 0
    var user = User(first_name: "", last_name: "", album: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  user.album?.count ?? 0
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell
        else { return PhotoCollectionViewCell() }
        
        cell.photo.image = user.album![indexPath.row].img
        cell.likeControl.likesCount = user.album![indexPath.row].like.count
        cell.likeControl.isLiked = user.album![indexPath.row].like.userLikes
        
        return cell
    }
}
