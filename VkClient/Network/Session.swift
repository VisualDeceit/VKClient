//
//  Session.swift
//  VkClient
//
//  Created by Alexander Fomin on 13.01.2021.
//

import Foundation

class Session {
    
    private init() {}
    
    static let shared = Session()
    var token: String?
    var userId: Int?
}
