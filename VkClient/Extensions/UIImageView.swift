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
                //защита от неправильного отображения фото прии скролле
                if url == response?.url {
                    self.image = image
                }
            }
        }.resume()
    }
    func download(from link: String) {
        guard let url = URL(string: link) else { return }
        download(from: url)
    }
}

extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}
