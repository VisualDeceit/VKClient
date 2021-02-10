//
//  FirebaseUsers.swift
//  VkClient
//
//  Created by Alexander Fomin on 10.02.2021.
//

import Foundation
import Firebase

class FirebaseUsers {
    let id: String
    let date: Int
    let ref: DatabaseReference?
    
    init(id: String, date: Int) {
        self.id = id
        self.date = date
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? String,
            let date = value["date"] as? Int
        else {
            return nil
        }
        self.id = id
        self.date = date
        self.ref = snapshot.ref
    }
    
    func toAnyObject() -> [String: Any] {
            // 4
            return [
                "id": id,
                "date": date
            ]
        }

}
