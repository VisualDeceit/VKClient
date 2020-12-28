//
//  PhotoCollectionViewController.swift
//  VkClient
//
//  Created by Alexander Fomin on 11.12.2020.
//

import UIKit

//private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController {
    
    var user = User(first_name: "", last_name: "", album: nil)
    
    //объявляем слабую ссылку на делегат для передачи данных
    weak var delegate: FriendsTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(user.first_name) \(user.last_name)"
       // downloadAlbum()
    }
    
    func downloadAlbum() {
        DispatchQueue.global(qos: .userInitiated).async {
            for index in 0..<self.user.album!.count {
                if let url = URL(string: self.user.album![index].imageURL) {
                    let data = try? Data(contentsOf: url)
                    if let imageData = data {
                        self.user.album![index].imageData = UIImage(data: imageData)!
                    }
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  user.album?.count ?? 0
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell
        else { return PhotoCollectionViewCell() }
        //передаем данные в ячейку
        //фото для каждой ячейки
        //cell.imageURL = URL(string: user.album![indexPath.row].imageURL)
        //cell.photo.image =  user.album![indexPath.row].imageData
        if let url = URL(string: user.album![indexPath.row].imageURL) {
            DispatchQueue.global(qos: .userInitiated).async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = data {
                        self.user.album![indexPath.row].imageData = UIImage(data: imageData)
                        cell.photo.image = UIImage(data: imageData)
                    }
                }
            }
        }
        //состояние  для likeControl
        cell.likeControl.totalCount = user.album![indexPath.row].like.totalCount
        cell.likeControl.isLiked = user.album![indexPath.row].like.isLiked
        //добавляем таргет
        cell.likeControl.addTarget(self, action: #selector(pushLike(_:)), for: .valueChanged)
        
        return cell
    }
    
    //срабатывает при нажатии на сердце в likeControl
    @objc func pushLike(_ sender: Any){
        //определяю какой контрол нажат
        guard let like = sender as? LikeControl
             else {
            return
        }
        // по конролу определяю ячейку к которой он принадлежит и нахожу индекс
        // по большому счету это индекс фото под которым нажали на серддце
        let index  = collectionView.indexPath(for: like.superview?.superview as! PhotoCollectionViewCell )
        //передаем обратно данные с помощью делегатов
        delegate?.update(indexPhoto: index!.row, like: Like(isLiked: like.isLiked, totalCount: like.totalCount))
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
        UIView.animate(withDuration: 0.4) {
            cell.alpha = 1
            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
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
        
        controller.datasource = user.album!
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
