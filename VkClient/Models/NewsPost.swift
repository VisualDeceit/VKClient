//
//  NewsPost.swift
//  VkClient
//
//  Created by Alexander Fomin on 03.03.2021.
//

import Foundation


struct NewsPostResponse: Decodable {
    let items: [NewsPost]
    
    enum ResponseCodingKeys: CodingKey {
        case response
        case items
        case profiles
        case groups
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseCodingKeys.self)
        let response = try container.nestedContainer(keyedBy: ResponseCodingKeys.self, forKey: .response)
        self.items = try response.decode([NewsPost].self, forKey: .items)
    }
}

class NewsPost: Decodable {
    
    var name = ""
    var avatarUrl = ""
    var date = 0
    var likesCount = 0
    var isLiked = 0
    var repostsCount = 0
    var viewsCount = 0
    var text = ""
    
    enum RepostsCodingKeys: String, CodingKey{
        case repostsCount = "count"
    }
    
    enum LikesCodingKeys: String, CodingKey {
        case likesCount = "count"
        case isLiked = "user_likes"
    }
    
    enum ViewsCodingKeys: String, CodingKey {
        case viewsCount = "count"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
    }
    
}
