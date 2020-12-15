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
    let deactivated: String = ""
    let is_closed: Bool = false
    let can_access_closed: Bool = true
    var photo_50: UIImage? = #imageLiteral(resourceName: "camera_50")
}

struct Group {
    let id: Int  = 0
    let name: String
    let screen_name: String
    let is_closed: Int = 0
    let type: String = "page"
    let is_admin: Int = 0
    let is_member: Int = 1
    let is_advertiser: Int = 0
    var photo_50: UIImage? = nil
}

struct Image {
    let url: String = ""
    let width: Int =  130
    let height: Int = 87
    let type: String  = "o"
}

extension Group: Equatable {
}



var friends = [User]()
var allGroups = [Group]()
var userGroups = [Group]()
var photos = [UIImage]()


