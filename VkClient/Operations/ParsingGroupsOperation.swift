//
//  ParsingGroupsOperation.swift
//  VkClient
//
//  Created by Alexander Fomin on 10.03.2021.
//

import Foundation


class ParsingGroupsOperation: AsyncOperation {
    var groups: [Group]?

    override func main() {
        guard let getGroupsOperation = dependencies.first as? GetGroupsOperation,
              let data = getGroupsOperation.data else { return }
        
        groups = try? JSONDecoder().decode(GroupResponse.self, from: data).items
        self.state = .finished
    }
    
}
