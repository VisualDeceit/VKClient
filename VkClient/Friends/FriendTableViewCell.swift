//
//  FriendTableViewCell.swift
//  VkClient
//
//  Created by Alexander Fomin on 11.12.2020.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet var friendAvatar: CellLogo!
    @IBOutlet var friendName: UILabel!
    //для сохранения запрошенного адреса
    var imageURL: URL?

    override func prepareForReuse() {
        super.prepareForReuse()
        friendAvatar.logoView.image = nil
        friendName.text = nil
    }
    
    func populate(user: User, service: PhotoService) {
        imageURL = URL(string: user.avatarUrl)
        friendName.text = "\(user.firstName) \(user.lastName)"
        service.getPhoto(urlString: user.avatarUrl) {[weak self] (image) in
            DispatchQueue.main.async {
                self?.friendAvatar.logoView.image = image
            }
        }
//        friendAvatar.logoView.download(from: imageURL!) {[weak self] url in
//            self?.imageURL == url
//        }
    }
    
    

}
