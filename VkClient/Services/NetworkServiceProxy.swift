//
//  NetworkServiceProxy.swift
//  VkClient
//
//  Created by Alexander Fomin on 21.04.2021.
//

import Foundation
import PromiseKit

class NetworkServiceProxy: NetworkServiceProtocol {
    let networkService: NetworkServiceProtocol
    
    init(_ networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getUserFriends() {
        self.networkService.getUserGroups()
        print("NetworkService: " + #function)
    }
    
    func getUserFriendsPromise() -> Promise<[RLMUser]> {
        print("NetworkService: " + #function)
        return self.networkService.getUserFriendsPromise()
    }
    
    func getPhotos(for user: RLMUser) {
        self.networkService.getPhotos(for: user)
        print("NetworkService: " + #function + "  user: \(user.lastName)  \(user.firstName)")
    }
    
    func getUserGroups() {
        self.networkService.getUserFriends()
        print("NetworkService: " + #function)
    }
    
    func searchGroups(by caption: String) {
        self.networkService.searchGroups(by: caption)
        print("NetworkService: " + #function + "text: \(caption)")
    }
    
    func getNewsFeed(type: NewsFeedType, startTime: TimeInterval? = nil, startFrom: String = "", completion: @escaping ([NewsPost], String?) -> ()) {
        self.networkService.getNewsFeed(type: type, startTime: startTime, startFrom: startFrom, completion: completion)
        print("NetworkService: " + #function + " type: \(type.rawValue) startTime: \(String(describing: startTime))")
    }
}
