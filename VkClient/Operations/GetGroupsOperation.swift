//
//  GetGroupsOperation.swift
//  VkClient
//
//  Created by Alexander Fomin on 10.03.2021.
//

import Foundation
import  Alamofire

class GetGroupsOperation: AsyncOperation {
    
    // возвращаемые данные
    var data: Data?
    
    func getUserGroups(complition: @escaping (Data?) -> () ) {
        let host = "https://api.vk.com"
        let path = "/method/groups.get"
        let parameters: Parameters = [
            "access_token": Session.shared.token!,
            "v": "5.130",
            "extended": "1"
        ]
        
        AF.request(host + path,
                   method: .get,
                   parameters: parameters).responseData(queue: DispatchQueue.global()) { (response) in
            switch response.result {
            case .success(let data):
                complition(data)
            case .failure:
                complition(nil)
            }
        }
    }

    override func main() {
        getUserGroups {[weak self] (data) in
            self?.data = data
            self?.state = .finished
        }
    }
}
