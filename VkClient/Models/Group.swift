//
//  Group.swift
//  VkClient
//
//  Created by Alexander Fomin on 23.01.2021.
//

import Foundation
import RealmSwift

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

class Group: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var avatarUrl: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarUrl = "photo_50"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
        
    }

}




