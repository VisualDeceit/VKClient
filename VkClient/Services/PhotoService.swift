//
//  PhotoService.swift
//  VkClient
//
//  Created by Alexander Fomin on 17.03.2021.
//

import UIKit

class PhotoService {
    
    private var memoryCache = [String: UIImage]()
    
    private let cacheLifeTime: TimeInterval = 24 * 3600 // 24 часа
    
    private let serviceQ = DispatchQueue(label: "com.vkclient.photoservice.q", qos: .default)
    
    private static let pathName: String = {
        let pathName = "images"
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    private func getFilePath(url: String) -> String? {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hashName = url.split(separator: "/").last ?? "default"
        return cachesDirectory.appendingPathComponent(PhotoService.pathName + "/" + hashName).path
    }
    
    private func saveImageToDiskCache(url: String, image: UIImage) {
        guard let fileName = getFilePath(url: url),
              let data = image.pngData() else { return }
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
    
    
    private func getImageFromDiskCache(url: String) -> UIImage? {
        guard
            let fileName = getFilePath(url: url),
            let info = try? FileManager.default.attributesOfItem(atPath: fileName),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date
        else { return nil }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard
            lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileName) else { return nil }
        
        serviceQ.async {
            self.memoryCache[url] = image
        }
        return image
    }
    
    private func loadPhoto(urlString: String, complition: @escaping (UIImage?) -> () ) {
        
        guard let url = URL(string: urlString) else { complition(nil); return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            guard let data = data,
                  let image = UIImage(data: data)
            else { complition(nil); return }
            self?.memoryCache[urlString] = image
            self?.saveImageToDiskCache(url: urlString, image: image)
            complition(image)
        }.resume()
    }
    
    // MARK: - Public API
    public func getPhoto(urlString: String, completion: @escaping (UIImage?) -> ()) {
       
        if let image = memoryCache[urlString] {
            completion(image)
        } else if let image = getImageFromDiskCache(url: urlString) {
            completion(image)
        } else {
            loadPhoto(urlString: urlString, complition: completion)
        }
    }
    
}
