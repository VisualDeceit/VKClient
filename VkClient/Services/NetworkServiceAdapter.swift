//
//  NetworkServiceAdapter.swift
//  VkClient
//
//  Created by Alexander Fomin on 13.04.2021.
//

import Foundation
import RealmSwift

class NetworkServiceAdapter {
    
    private let networkServiceImpl: NetworkServices
    private let networkService: NetworkServiceProxy
    var token: NotificationToken?
    
    init() {
        networkServiceImpl = NetworkServices()
        networkService = NetworkServiceProxy(self.networkServiceImpl)
    }
 
    func getPhotos(for user: RLMUser, then complition: @escaping ([UserPhoto]) -> ()) {
        
        guard let userPhotoObject = try? RealmService.load(typeOf: RLMUserPhoto.self).filter("owner.id = %@", user.id)
        else { return }
    
        token = userPhotoObject.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            //обрабатываю и .initial т.к изменений в базе может и не быть, а фото отобразить нужно
            case .initial(let photoObject), .update(let photoObject, _, _, _):
                var userPhotos = [UserPhoto]()
                photoObject.forEach {
                    userPhotos.append(self.convert(from: $0))
                }
                complition(userPhotos)
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
        networkService.getPhotos(for: user)
    }
    
    private func convert(from userPhotoObject: RLMUserPhoto) -> UserPhoto {
        UserPhoto(id: userPhotoObject.id,
                  likesCount: userPhotoObject.likesCount,
                  isLiked: userPhotoObject.isLiked,
                  repostsCount: userPhotoObject.repostsCount,
                  link: userPhotoObject.link,
                  width: userPhotoObject.width,
                  height: userPhotoObject.height,
                  type: userPhotoObject.type)
    }
}
