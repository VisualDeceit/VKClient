//
//  FirebaseGroup.swift
//  VkClient
//
//  Created by Alexander Fomin on 10.02.2021.
//

import Foundation
import Firebase

class FirebaseGroup {
    let id: String
    let name: String
    let ref: DatabaseReference?
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? String,
            let name = value["name"] as? String
        else {
            return nil
        }
        self.id = id
        self.name = name
        self.ref = snapshot.ref
    }
    
    func toAnyObject() -> [String: Any] {
            // 4
            return [
                "id": id,
                "name": name
            ]
        }

}
