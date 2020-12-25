//
//  Data.swift
//  VkClient
//
//  Created by Alexander Fomin on 11.12.2020.
//

import UIKit

struct User {
    let id: Int = 0
    let first_name: String
    let last_name: String
    var album: [Photo]?

    init(first_name: String, last_name: String) {
        self.first_name = first_name
        self.last_name = last_name
        self.album = []
        
        for _ in 1..<Int.random(in: 10...20) {
            self.album?.append(Photo(like: Like(isLiked: false, totalCount: Int.random(in: 1...1000))))
        }

    }

    init(first_name: String, last_name: String, album: [Photo]?) {
        self.first_name = first_name
        self.last_name = last_name
        self.album = album
    }
}

struct Group {
    let id: Int  = 0
    let name: String
    let screen_name: String
    //let is_closed: Int = 0
    //let type: String = "page"
    //let is_admin: Int = 0
    //let is_member: Int = 1
    //let is_advertiser: Int = 0
    //let photo_50: String
    let logo: UIImage?
}

extension Group: Equatable {}


struct Photo {
    var imageURL:  String = "https://picsum.photos/300"
    var like: Like
}

struct Like {
    var isLiked: Bool = false
    var totalCount: Int = 0
}

struct News {
    var logo: UIImage?
    var caption: String = ""
    var date: String = ""
    var text: String?
    var image: UIImage?
    var like: Like
}




