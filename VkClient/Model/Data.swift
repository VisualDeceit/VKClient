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
    //let deactivated: String = ""
    //let is_closed: Bool = false
    //let can_access_closed: Bool = true
    //let photo_50: String
    let album: [Photo]?
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
    var img: UIImage
    var like: Like
}

struct Like {
    var userLikes: Bool
    var count: Int
}




