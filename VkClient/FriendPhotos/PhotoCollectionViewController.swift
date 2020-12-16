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
    
    weak var delegate: FriendsTableViewControllerDelegate?
    
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
        cell.likeControl.addTarget(self, action: #selector(pushLike(_:)), for: .valueChanged)
        
        return cell
    }
    
    @objc func pushLike(_ sender: Any){
        //определяю какой контрол нажат
        guard let like = sender as? LikeControl
             else {
            return
        }
        // по конролу определяю ячейку к которой он принадлежит и нахожу индекс
        let index  = collectionView.indexPath(for: like.superview?.superview as! PhotoCollectionViewCell )
        //передаем обратно данные с помощью делегатов
        delegate?.update(indexPhoto: index!.row, like: Like(userLikes: like.isLiked, count: like.likesCount))
    }
}
