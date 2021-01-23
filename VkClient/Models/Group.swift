//
//  Group.swift
//  VkClient
//
//  Created by Alexander Fomin on 23.01.2021.
//

/*
 "response": {
       "count": 51,
       "items": [
           {
               "id": 184225789,
               "name": "ТОПОР — Хранилище",
               "screen_name": "toportg",
               "is_closed": 1,
               "type": "group",
               "is_admin": 0,
               "is_member": 1,
               "is_advertiser": 0,
               "photo_50": "https://sun3.ufanet.userapi.com/impf/c850636/v850636137/173d43/-LGOrMnatj4.jpg?size=50x0&quality=96&crop=98,89,1842,1842&sign=a78da967de957e78e20a933d2d5da388&c_uniq_tag=NWcaEFH8iipCzz3E6Ddtl3XoqJWUbXwMvLO5fLY3S88&ava=1",
               "photo_100": "https://sun3.ufanet.userapi.com/impf/c850636/v850636137/173d43/-LGOrMnatj4.jpg?size=100x0&quality=96&crop=98,89,1842,1842&sign=b5fa06af326c574f91019c806439f3f3&c_uniq_tag=hW0Zt3_yk2rJagZLpaiS8ZqtdNqH8uRKKXGw-q1grTY&ava=1",
               "photo_200": "https://sun3.ufanet.userapi.com/impf/c850636/v850636137/173d43/-LGOrMnatj4.jpg?size=200x0&quality=96&crop=98,89,1842,1842&sign=84e03cd1c48699fb5265fda5bc145cd5&c_uniq_tag=D8IJ3YmNidY8Fx1p9lC3-4iAHW7NVHsgiGwVtGQAgYc&ava=1"
           },
 
  ]
 }
 */


import Foundation

struct GroupListResponse: Decodable {
    let response: Response
    
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct Response: Decodable {
    let items: [Group0]
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}

struct Group0: Decodable {
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




