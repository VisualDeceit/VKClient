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
    
    private let container: DataReloadable
    
    private static let pathName: String = {
        let pathName = "images"
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    init(container: UITableView) {
        self.container = Table(table: container)
    }
    
    init(container: UICollectionView) {
        self.container = Collection(collection: container)
    }
    
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
    
    private func loadPhoto(at indexPath: IndexPath, urlString: String ) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            guard let data = data,
                  let image = UIImage(data: data)
            else { return }
            
            self?.serviceQ.async {
                self?.memoryCache[urlString] = image
            }

            self?.saveImageToDiskCache(url: urlString, image: image)
            
            DispatchQueue.main.async {
                self?.container.reloadRow(at: indexPath)
            }

        }.resume()
    }
    
    // MARK: - Public API
    public func photo(at indexPAth: IndexPath, urlString: String) -> UIImage? {
        var image: UIImage?
        if let imageFromCache = memoryCache[urlString] {
            image = imageFromCache
        } else if let imageFromCache = getImageFromDiskCache(url: urlString) {
           image = imageFromCache
        } else {
            loadPhoto(at: indexPAth, urlString: urlString)
        }
        return image
    }
    
}

fileprivate protocol DataReloadable {
    func reloadRow(at indexPath: IndexPath)
}

extension PhotoService {
    
    private class Table: DataReloadable {
        let table: UITableView
        
        init(table: UITableView) {
            self.table = table
        }
        
        func reloadRow(at indexPath: IndexPath) {
            table.reloadRows(at: [indexPath], with: .none)
        }
        
    }
    
    private class Collection: DataReloadable {
        let collection: UICollectionView
        
        init(collection: UICollectionView) {
            self.collection = collection
        }
        
        func reloadRow(at indexPath: IndexPath) {
            collection.reloadItems(at: [indexPath])
        }
    }
}
