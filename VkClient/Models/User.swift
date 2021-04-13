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

class RLMUser: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var avatarUrl: String = ""
    
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

// модель для после применения адаптера
//struct UserAdapted {
//    var id: Int
//    var firstName: String
//    var lastName: String
//    var avatarUrl: String
//}
