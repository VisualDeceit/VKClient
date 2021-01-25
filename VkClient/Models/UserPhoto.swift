//
//  UserPhoto.swift
//  VkClient
//
//  Created by Alexander Fomin on 23.01.2021.
//


import Foundation

struct UserPhotoModel: Decodable {
    let response: UserPhotoResponse
}

struct UserPhotoResponse: Decodable {
    let items: [UserPhoto]
}

struct UserPhoto: Decodable {
    let likesCount: Int
    let isLiked: Int
    let repostsCount: Int
    var sizes: [PhotoSize]
    
    enum RepostsCodingKeys: String, CodingKey{
        case repostsCount = "count"
    }
    
    enum LikesCodingKeys: String, CodingKey {
        case likesCount = "count"
        case isLiked = "user_likes"
    }
    
    enum CodingKeys: String, CodingKey {
        case likesCount
        case isLiked
        case repostsCount
        case sizes
        case likes
        case reposts
    }
      
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sizes = try container.decode([PhotoSize].self, forKey: .sizes)
        
        let likeContainer = try container.nestedContainer(keyedBy: LikesCodingKeys.self, forKey: .likes)
        self.isLiked = try likeContainer.decode(Int.self, forKey: .isLiked)
        self.likesCount = try likeContainer.decode(Int.self, forKey: .likesCount)
        
        let repostsContainer = try container.nestedContainer(keyedBy: RepostsCodingKeys.self, forKey: .reposts)
        self.repostsCount = try repostsContainer.decode(Int.self, forKey: .repostsCount)
    }
}

//struct Likes: Decodable {
//    let count: Int
//    let isLiked: Int
//
//    enum CodingKeys: String, CodingKey {
//        case count
//        case isLiked = "user_likes"
//    }
//}

struct PhotoSize: Decodable {
    let height: Int
    let width: Int
    let type: String
    let url: String
}

