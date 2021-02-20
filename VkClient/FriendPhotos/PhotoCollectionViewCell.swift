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
    
    //для сохранения запрошенного адреса
    var imageURL: URL?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image = nil
    }
    
    func populate(userPhoto: UserPhoto) {
        //сохраняем запрошенный адрес
        imageURL = URL(string: userPhoto.link)
        self.photo.download(from: imageURL!) {[weak self] url in
            //если url с которого загрузили фото совпадает с запрошенным
            self?.imageURL == url
        }
    
        //состояние  для likeControl
        self.likeControl.totalCount = userPhoto.likesCount
        self.likeControl.isLiked = userPhoto.isLiked == 1 ? true : false
        //добавляем таргет
        //  self.likeControl.addTarget(self, action: #selector(pushLike(_:)), for: .valueChanged)
    }
        
}
