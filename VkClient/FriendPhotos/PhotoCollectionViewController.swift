//
//  PhotoCollectionViewController.swift
//  VkClient
//
//  Created by Alexander Fomin on 11.12.2020.
//

import UIKit
import RealmSwift

//private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController {
    
    var user = RLMUser()
    var userPhotos: Results<UserPhoto>!
    var token: NotificationToken?
    var refresher: UIRefreshControl!
    
    //объявляем слабую ссылку на делегат для передачи данных
    weak var delegate: FriendsTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(user.firstName) \(user.lastName)"
        
        //обновление
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        //self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView!.addSubview(refresher)
        
        //загрузка данных
        let networkService = NetworkServices()
        networkService.getPhotos(for: user)
        
        //устанавливаем уведомления
        do {
            userPhotos = try RealmService.load(typeOf: UserPhoto.self).filter("owner.id = %@", user.id)
            /// подписываем
            if let userPhotos = userPhotos {
                addNotification(for: userPhotos)
            }
        }
        catch {
            print(error)
        }
    
    }
    
    func addNotification(for results: Results<UserPhoto>) {
        token = (results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                self?.collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                    collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                    collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
            case .error(let error):
                fatalError("\(error)")
            }
        })
    }
    
    @objc func refresh(sender:AnyObject) {
        //загрузка данных
        let networkService = NetworkServices()
        networkService.getPhotos(for: user)
        self.refresher?.endRefreshing()
    }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  userPhotos.count 
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell
        else { return PhotoCollectionViewCell() }
        
        //передаем данные в ячейку
        cell.populate(userPhoto: userPhotos[indexPath.row])
   
        return cell
    }
    
//    //срабатывает при нажатии на сердце в likeControl
//    @objc func pushLike(_ sender: Any){
//        //определяю какой контрол нажат
//        guard let like = sender as? LikeControl
//             else {
//            return
//        }
//        // по конролу определяю ячейку к которой он принадлежит и нахожу индекс
//        // по большому счету это индекс фото под которым нажали на серддце
//        let index  = collectionView.indexPath(for: like.superview?.superview as! PhotoCollectionViewCell )
//        //передаем обратно данные с помощью делегатов
//        delegate?.update(indexPhoto: index!.row, like: Like(isLiked: like.isLiked, totalCount: like.totalCount))
//    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            UIView.animate(withDuration: 0.4) {
                cell.alpha = 1
                cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            }
        }
    }
    
    //to SwipePhotoGalleryViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "ShowGallery",
            let controller = segue.destination as? SwipePhotoGalleryViewController,
            let cell = sender as? PhotoCollectionViewCell
        else { return }
        
        let indexPaths = self.collectionView.indexPath(for: cell)
        
        controller.datasource = Array(userPhotos) //user.album!
        controller.index = indexPaths!.row
    }
    
    @IBAction func closeGallery(_ unwindSegue: UIStoryboardSegue) {}

}
    


extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-20) / 2
        let size = CGSize(width: width, height: width + 30)
        return size
    }
    
}
