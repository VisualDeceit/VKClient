//
//  UserPhoto.swift
//  VkClient
//
//  Created by Alexander Fomin on 23.01.2021.
//


import Foundation
import RealmSwift

struct UserPhotoResponse: Decodable {
    let items: [UserPhoto]
    
    enum ResponseCodingKeys: CodingKey {
        case response
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseCodingKeys.self)
        let response = try container.nestedContainer(keyedBy: ResponseCodingKeys.self, forKey: .response)
        self.items = try response.decode([UserPhoto].self, forKey: .items)
    }
}

class UserPhoto: Object, Decodable {
    @objc dynamic var likesCount: Int = 0
    @objc dynamic var isLiked: Int = 0
    @objc dynamic var repostsCount: Int = 0
    let sizes = List<PhotoSize>()
    
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
      
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let sizesArray = try container.decode([PhotoSize].self, forKey: .sizes)
        //sizesArray.forEach{ self.sizes.append($0) }
        sizes.append(objectsIn: sizesArray)
        let likeContainer = try container.nestedContainer(keyedBy: LikesCodingKeys.self, forKey: .likes)
        self.isLiked = try likeContainer.decode(Int.self, forKey: .isLiked)
        self.likesCount = try likeContainer.decode(Int.self, forKey: .likesCount)
        
        let repostsContainer = try container.nestedContainer(keyedBy: RepostsCodingKeys.self, forKey: .reposts)
        self.repostsCount = try repostsContainer.decode(Int.self, forKey: .repostsCount)
    }
}

class PhotoSize: Object, Decodable {
    @objc dynamic var height: Int = 0
    @objc dynamic var width: Int = 0
    @objc dynamic var type: String = ""
    @objc dynamic var url: String = ""
}

