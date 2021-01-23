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

    override func prepareForReuse() {
        super.prepareForReuse()
        friendAvatar.logoView.image = nil
        friendName.text = nil
    }
    
    func populate(user: User0) {
        friendName.text = "\(user.firstName) \(user.lastName)"
        friendAvatar.logoView.download(from: user.avatarUrl)
    }
    
    

}
