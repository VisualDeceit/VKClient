//
//  SaveToRealmOperation.swift
//  VkClient
//
//  Created by Alexander Fomin on 10.03.2021.
//

import Foundation

class SaveToRealmOperation: AsyncOperation {
    
    override func main() {
        guard let parsingGroupOperation = dependencies.first as? ParsingGroupsOperation,
              let groups = parsingGroupOperation.groups else { return }
        do {
            // удаляем старых друзей
            let ids = groups.map { $0.id}
            let objectsToDelete = try RealmService.load(typeOf: Group.self).filter("NOT id IN %@", ids)
            try RealmService.delete(object: objectsToDelete)
            //сохранение данных в Realm
            try RealmService.save(items: groups)
            state = .finished
        }
        catch {
            print(error)
        }
    }
}
