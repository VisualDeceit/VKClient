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
    var album: [Photo]?
    
    init(first_name: String, last_name: String) {
        self.first_name = first_name
        self.last_name = last_name
        self.album = []
        
        var photo = Photo(img: UIImage(), like: Like(userLikes: false, count: 0))
        for _ in 1...Int.random(in: 1..<2){
            let url = URL(string: "https://picsum.photos/150")
            let data = try? Data(contentsOf: url!)
            let img = UIImage(data: data!)
            photo.img = img!
            photo.like.count = Int.random(in: 0..<50)
            self.album!.append(photo)
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
    var img: UIImage
    var like: Like
}

struct Like {
    var userLikes: Bool
    var count: Int
}




