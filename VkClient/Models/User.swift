//
//  User.swift
//  VkClient
//
//  Created by Alexander Fomin on 22.01.2021.
//

import Foundation
import SwiftyJSON
import RealmSwift

//эта модель через SwiftyJSON

class User: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var avatarUrl: String = ""
    //let photos = List<UserPhoto>()

    
    convenience init(_ json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.avatarUrl = json["photo_50"].stringValue
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
}
