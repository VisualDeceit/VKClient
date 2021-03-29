//
//  ASPhotoGalleryCell.swift
//  VkClient
//
//  Created by Alexander Fomin on 28.03.2021.
//

import UIKit
import AsyncDisplayKit
import RealmSwift

class ASPhotoGalleryCell: ASCellNode {
    
    private var imageNode: ASMultiplexImageNode
    private var gallegalleryPhotoRef: ThreadSafeReference<UserPhoto>
    private var urls: [String: URL] = [:]
    
    init(reference: ThreadSafeReference<UserPhoto>) {
        self.gallegalleryPhotoRef = reference
        self.imageNode = ASMultiplexImageNode()
        super.init()
        
        //возвращаем объект, но для текущего потока
        let realm = try! Realm()
        let userPhoto = realm.resolve(self.gallegalleryPhotoRef)
        //заполняем словарь размеров
        userPhoto?.photoSizes.forEach{ urls[$0.type] = URL(string: $0.url)}
        //настравиаем imageNode для прогрессивной загрузки
        imageNode = ASMultiplexImageNode(cache: nil, downloader: ASBasicImageDownloader.shared)
        imageNode.downloadsIntermediateImages = true
        imageNode.dataSource = self
        imageNode.imageIdentifiers = ["x" as ASImageIdentifier,
                                      "m" as ASImageIdentifier,
                                      "s" as ASImageIdentifier]
        addSubnode(imageNode)
        backgroundColor = .systemBackground
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let photoDimension: CGFloat = (constrainedSize.max.width - 1) / 2.0
        imageNode.style.preferredSize = CGSize(width: photoDimension, height: photoDimension)
        return ASCenterLayoutSpec(centeringOptions: .Y, sizingOptions: .minimumX, child: imageNode)
    }
    
}

extension ASPhotoGalleryCell: ASMultiplexImageNodeDataSource {
    
    func multiplexImageNode(_ imageNode: ASMultiplexImageNode, urlForImageIdentifier imageIdentifier: ASImageIdentifier) -> URL? {
        guard let type = imageIdentifier as? String  else {
            return nil
        }
        return urls[type]
    }
    
}
