//
//  UIImageView.swift
//  VkClient
//
//  Created by Alexander Fomin on 23.01.2021.
//

import UIKit

extension UIImageView {
    func download(from url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
    func download(from link: String) {
        guard let url = URL(string: link) else { return }
        download(from: url)
    }
}
