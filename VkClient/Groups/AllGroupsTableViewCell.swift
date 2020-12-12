//
//  AllGroupsTableViewCell.swift
//  VkClient
//
//  Created by Alexander Fomin on 12.12.2020.
//

import UIKit

class AllGroupsTableViewCell: UITableViewCell {

    @IBOutlet var groupImage: UIImageView!
    @IBOutlet var groupName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
