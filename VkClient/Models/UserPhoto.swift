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
    @objc dynamic var id: Int = 0
    @objc dynamic var likesCount: Int = 0
    @objc dynamic var isLiked: Int = 0
    @objc dynamic var repostsCount: Int = 0
    let photoSizes = List<PhotoSize>()
    @objc dynamic var link: String = ""
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
    @objc dynamic var type: String = ""
    @objc dynamic var owner: User?

    
    enum RepostsCodingKeys: String, CodingKey{
        case repostsCount = "count"
    }
    
    enum LikesCodingKeys: String, CodingKey {
        case likesCount = "count"
        case isLiked = "user_likes"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
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
        self.id = try container.decode(Int.self, forKey: .id)
        let sizesArray = try container.decode([PhotoSize].self, forKey: .sizes)
        
        self.photoSizes.append(objectsIn: sizesArray)

        // поиск максимальный размер
        var maxSize = sizesArray.reduce(sizesArray[0]) { current, next -> PhotoSize in
            let currentPoints = current.width * current.height
            let nextPoints = next.width * next.height
            return currentPoints >= nextPoints ? current : next
        }
        // для фото до 2012г
        if maxSize.height == 0 {
            maxSize = sizesArray.first(where: {$0.type == "x"}) ?? sizesArray[0]
        }
        
        self.link = maxSize.url
        self.width = maxSize.width
        self.height = maxSize.height
        self.type = maxSize.type

        let likeContainer = try container.nestedContainer(keyedBy: LikesCodingKeys.self, forKey: .likes)
        self.isLiked = try likeContainer.decode(Int.self, forKey: .isLiked)
        self.likesCount = try likeContainer.decode(Int.self, forKey: .likesCount)
        
        let repostsContainer = try container.nestedContainer(keyedBy: RepostsCodingKeys.self, forKey: .reposts)
        self.repostsCount = try repostsContainer.decode(Int.self, forKey: .repostsCount)
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
}

class PhotoSize: Object, Decodable {
    @objc dynamic var height: Int = 0
    @objc dynamic var width: Int = 0
    @objc dynamic var type: String = ""
    @objc dynamic var url: String = ""
}

