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
    
    var imageURL: URL? {
    didSet {
        photo?.image = nil
        updateUI()
        }
    }
    
    private func updateUI(){
        if let url = imageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = data {
                        self.photo.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
    }
    
}
