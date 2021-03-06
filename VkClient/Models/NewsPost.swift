//
//  NewsPost.swift
//  VkClient
//
//  Created by Alexander Fomin on 03.03.2021.
//

import Foundation


struct NewsPostResponse: Decodable {
    let items: [NewsPost]
    let profiles: [NewsPostProfiles]
    let gpoups: [NewsPostGroups]
    
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
        self.profiles = try response.decode([NewsPostProfiles].self, forKey: .profiles)
        self.gpoups = try response.decode([NewsPostGroups].self, forKey: .groups)
    }
}

struct NewsPostProfiles: Decodable {
    var id = 0
    var name = ""
    var photoURL = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photoURL = "photo_50"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id =  try container.decode(Int.self, forKey: .id)
        let lastName = try container.decode(String.self, forKey: .lastName)
        let firstName = try container.decode(String.self, forKey: .firstName)
        self.name = "\(lastName) \(firstName)"
        self.photoURL = try container.decode(String.self, forKey: .photoURL)
    }
}

struct NewsPostGroups: Decodable {
    var id = 0
    var name = ""
    var photoURL = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photoURL = "photo_50"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id =  try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.photoURL = try container.decode(String.self, forKey: .photoURL)
    }
    
}


struct NewsPostAttachment: Decodable {
    var type = ""
    var url = ""
    
    enum CodingKeys: String, CodingKey {
        case type
        case photo
        case sizes
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        if self.type == "photo" {
            let photoContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .photo)
            let sizesArray = try photoContainer.decode([PhotoSize].self, forKey: .sizes)
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
            
            self.url = maxSize.url
        }
       
        
    }
    
}

class NewsPost: Decodable {
    var sourceId = 0
    var name = ""
    var avatarUrl = ""
    var date = 0
    var likesCount = 0
    var isLiked = 0
    var repostsCount = 0
    var viewsCount: Int?
    var text = ""
    var attachments : [NewsPostAttachment]?
    
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
    
    enum AttachmentsCodingKeys: String, CodingKey {
        case attType = "type"
    }
    
    enum CodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case date
        case text
        case likes
        case reposts
        case views
        case attachments
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(Int.self, forKey: .date)
        self.text = try container.decode(String.self, forKey: .text)
        self.sourceId = try container.decode(Int.self, forKey: .sourceId)

        let likeContainer = try container.nestedContainer(keyedBy: LikesCodingKeys.self, forKey: .likes)
        self.isLiked = try likeContainer.decode(Int.self, forKey: .isLiked)
        self.likesCount = try likeContainer.decode(Int.self, forKey: .likesCount)
        
        let repostsContainer = try container.nestedContainer(keyedBy: RepostsCodingKeys.self, forKey: .reposts)
        self.repostsCount = try repostsContainer.decode(Int.self, forKey: .repostsCount)
        
        let viewsContainer = try? container.nestedContainer(keyedBy: ViewsCodingKeys.self, forKey: .views)
        self.viewsCount = try? viewsContainer?.decode(Int.self, forKey: .viewsCount)
        
        self.attachments = try? container.decode([NewsPostAttachment].self, forKey: .attachments)
    }
    
}
