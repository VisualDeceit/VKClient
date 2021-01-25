//
//  Group.swift
//  VkClient
//
//  Created by Alexander Fomin on 23.01.2021.
//

import Foundation

//эта модель через Decodable

struct GroupModel: Decodable {
    let response: GroupResponse
    
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct GroupResponse: Decodable {
    let items: [Group]
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
    /*
     сработает автоматическая функция init
     если написать декодирование самостоятельно, то:
     self.items = try container.decode([Group0].self, forKey: .items)
     */
}

struct Group: Decodable, Equatable {
    let id: Int
    let name: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarUrl = "photo_50"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
        
    }
}




