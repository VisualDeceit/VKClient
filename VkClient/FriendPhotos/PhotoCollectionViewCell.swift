//
//  PhotoCollectionViewCell.swift
//  VkClient
//
//  Created by Alexander Fomin on 11.12.2020.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var likeControl: LikeControl!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image = nil
    }
    
    func populate(userPhoto: UserPhoto) {
        //пропорциональная копия с максимальной стороной 320px
        if let photo = userPhoto.sizes.first(where: {$0.type == "q"}) {
            self.photo.download(from: photo.url)
        } else {
            //пропорциональная копия изображения с максимальной стороной 604px
            if let photo = userPhoto.sizes.first(where: {$0.type == "x"}) {
                self.photo.download(from: photo.url)
            }
        }
        
        //состояние  для likeControl
       self.likeControl.totalCount = userPhoto.likesCount
        self.likeControl.isLiked = userPhoto.isLiked == 1 ? true : false
        //добавляем таргет
      //  self.likeControl.addTarget(self, action: #selector(pushLike(_:)), for: .valueChanged)
    }

    
}
