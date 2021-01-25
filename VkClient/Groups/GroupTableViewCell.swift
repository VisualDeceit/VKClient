//
//  GroupTableViewCell.swift
//  VkClient
//
//  Created by Alexander Fomin on 11.12.2020.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupLogo: CellLogo!
    @IBOutlet var groupName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        groupLogo.logoView.image = nil
        groupName.text = nil
    }
    
    func populate(group: Group) {
        self.groupLogo.logoView.download(from: group.avatarUrl)
        self.groupName.text = group.name
    }
    
  

}
