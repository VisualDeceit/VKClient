//
//  ASPhotoGalleryController.swift
//  VkClient
//
//  Created by Alexander Fomin on 28.03.2021.
//

import UIKit
import AsyncDisplayKit
import RealmSwift

class ASPhotoGalleryController: ASDKViewController<ASCollectionNode> {
    
    var user: User
    var collectionNode: ASCollectionNode
    var galleryPhotos: Results<UserPhoto>!
    var token: NotificationToken?
    

    init(user: User) {
        self.user = user
        
        let flowLayout = UICollectionViewFlowLayout()
        self.collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(node: collectionNode)
        
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionNode.delegate = self
        collectionNode.dataSource = self
        collectionNode.view.backgroundColor = .systemBackground
        
        self.navigationItem.title = "\(user.firstName) \(user.lastName)"
        
        let networkService = NetworkServices()
        networkService.getPhotos(for: user)
        
        do {
            galleryPhotos = try RealmService.load(typeOf: UserPhoto.self).filter("owner.id = %@", user.id)
            if let galleryPhotos = galleryPhotos {
                addNotification(for: galleryPhotos)
            }
        }
        catch {
            print(error)
        }
    }
    
    private func addNotification(for results: Results<UserPhoto>) {
        token = (results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionNode = self?.collectionNode else { return }
            switch changes {
            case .initial:
                self?.collectionNode.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                collectionNode.performBatchUpdates({
                    collectionNode.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                    collectionNode.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                    collectionNode.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
            case .error(let error):
                fatalError("\(error)")
            }
        })
    }
}

extension ASPhotoGalleryController: ASCollectionDataSource {
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        galleryPhotos.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard galleryPhotos.count > indexPath.row else { return { ASCellNode() } }
    
        let gallegalleryPhotoItem = galleryPhotos[indexPath.item]
        //Получаем потоко-безопасную ссылку
        let gallegalleryPhotoRef = ThreadSafeReference(to: gallegalleryPhotoItem)
  
        let cellNodeBlock = { () -> ASCellNode in
            //в ячейку передаем ссылку
            let cellNode = ASPhotoGalleryCell(reference: gallegalleryPhotoRef)
           return cellNode
         }
        
        return cellNodeBlock
    }

    
}

extension ASPhotoGalleryController: ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {

        let photoBrowseController = PhotoBrowseController()
        photoBrowseController.modalPresentationStyle = .automatic
        photoBrowseController.datasource = Array(galleryPhotos)
        photoBrowseController.index = indexPath.item
        present(photoBrowseController, animated: true)
    }
    
}
