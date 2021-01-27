//
//  User.swift
//  VkClient
//
//  Created by Alexander Fomin on 22.01.2021.
//


/*
 {
                "first_name": "Кристина",
                "id": 154192,
                "last_name": "Лаврова",
                "can_access_closed": true,
                "is_closed": true,
                "photo_50": "https://sun1.ufanet.userapi.com/impf/bkp7-c4fOWtqKneOlfhPM8RSPgMg5Att_XpF3Q/MOboUP_kv-o.jpg?size=50x0&quality=96&crop=597,171,1365,1365&sign=fc0ad5739fdf2370954bf1744e839c13&c_uniq_tag=CCXuTUBIDOY0wQqjfpRd__dJ4C9luvYP8ctGCFTzTEQ&ava=1",
                "lists": [
                    26
                ],
                "track_code": "093a5881ovE6cTh07ulMuZyIZmbq2teWsAX6GbHAFel4LVObU8nTjTAqBiG15RvnnCTKpSjq98LEAf4FvtY4hRE"
            }
 
 */


import Foundation
import SwiftyJSON
import RealmSwift

//эта модель через SwiftyJSON

class User0: Object {
    
    @objc dynamic var id: Int
    @objc dynamic var firstName: String
    @objc dynamic var lastName: String
    @objc dynamic var avatarUrl: String
    
    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.avatarUrl = json["photo_50"].stringValue
    }
}
