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
    
    var userObject = RLMUser()
    var userPhotos = [UserPhoto]()
    var refresher: UIRefreshControl!
    let networkService = NetworkServiceAdapter()
    
    //объявляем слабую ссылку на делегат для передачи данных
    weak var delegate: FriendsTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(userObject.firstName) \(userObject.lastName)"
        
        //обновление
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        //self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView!.addSubview(refresher)
        
        networkService.getPhotos(for: userObject) {[weak self] photos in
            self?.userPhotos = photos
            self?.collectionView.reloadData()

        }
    }
        
    
    @objc func refresh(sender:AnyObject) {
        //загрузка данных
        let networkService = NetworkServices()
        networkService.getPhotos(for: userObject)
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
        
        controller.datasource = Array(userPhotos)
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
