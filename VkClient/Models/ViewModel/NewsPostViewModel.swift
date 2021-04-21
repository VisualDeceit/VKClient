//
//  NewsPostViewModel.swift
//  VkClient
//
//  Created by Alexander Fomin on 13.04.2021.
//

import UIKit

struct NewsPostViewModel {
    var iconImage: UIImage
    var caption: String
    var dateText: String
    var dateInt: TimeInterval = 0 // для запроса
    var contentText: String
    var likesCount = 0
    var isLiked = 0
    var repostsCount: String
    var viewsCount: String
    var commentsCount: String
    var attachments: [ViewModelAttachment]?
}

struct ViewModelAttachment {
    var image: UIImage
    var ratio: CGFloat = 0
}