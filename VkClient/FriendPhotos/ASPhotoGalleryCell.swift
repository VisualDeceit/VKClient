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
    
    private let imageNode = ASNetworkImageNode()
    private var gallegalleryPhotoRef: ThreadSafeReference<UserPhoto>
    
    init(reference: ThreadSafeReference<UserPhoto>) {
        self.gallegalleryPhotoRef = reference
 
        super.init()
        let realm = try! Realm()
        //возвращаем объект, но для текущего потока
        let userPhoto = realm.resolve(self.gallegalleryPhotoRef)
        backgroundColor = .yellow
        imageNode.shouldRenderProgressImages = true
        imageNode.url = URL(string: userPhoto!.link)
        addSubnode(imageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let photoDimension: CGFloat = (constrainedSize.max.width - 20.0) / 2.0
        imageNode.style.preferredSize = CGSize(width: photoDimension, height: photoDimension)

        return ASCenterLayoutSpec(centeringOptions: .Y, sizingOptions: .minimumX, child: imageNode)
       
    }
}
