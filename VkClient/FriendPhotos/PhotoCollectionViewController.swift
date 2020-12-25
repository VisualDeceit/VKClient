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
    }
    
    //заготовка для ДЗ
    //пока хз  как передавать фото целиком или грузить по ссылке???
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
        cell.imageURL = URL(string: user.album![indexPath.row].imageURL)
        //cell.photo.image =  user.album![indexPath.row].imageData
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
    
}

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-20) / 2
        let size = CGSize(width: width, height: width + 30)
        return size
    }
}
