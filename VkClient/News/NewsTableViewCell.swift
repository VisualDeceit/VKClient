//
//  NewsTableViewCell.swift
//  VkClient
//
//  Created by Alexander Fomin on 20.12.2020.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentText: UILabel!
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var likeControl: LikeControl!
    @IBOutlet weak var viewsNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        contentText.text = nil
        contentImage.image = nil
        
    }

}
