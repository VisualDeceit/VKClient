//
//  SwipePhotoGalleryViewController.swift
//  VkClient
//
//  Created by Alexander Fomin on 26.12.2020.
//

import UIKit

class SwipePhotoGalleryViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    var panGesture: UIPanGestureRecognizer!
    var animator: UIViewPropertyAnimator!
    var swipeGesture: UISwipeGestureRecognizer!
    
    var currentImageView: UIImageView!
    var nextImageView: UIImageView!
    
    var datasource =  [Photo]()
    var index: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initGallery()
    }
    
    func initGallery() {
        let defaultFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        imageView1.image = datasource[index].imageData
        imageView1.backgroundColor = .red
        imageView1.frame = defaultFrame
        
        imageView2.frame = defaultFrame
        imageView2.backgroundColor = .blue
       
        currentImageView = imageView1
        nextImageView = imageView2
        
        if index + 1 < datasource.count {
            //подгружаем след фото
            imageView2.image = datasource[index + 1].imageData
        }
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        view.addGestureRecognizer(panGesture)
        panGesture.delegate = self
        
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        swipeGesture.delegate = self
        
    
    }
    
    @objc func didPan( _ panGesture: UIPanGestureRecognizer) {
        
        let final = currentImageView.frame.width
    
        switch panGesture.state {
        case .began:
            animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
                self.currentImageView.frame  =  self.currentImageView.frame.offsetBy(dx:  -final, dy: 0.0)
            })
            animator.pauseAnimation()
        case .changed:
            let translation = panGesture.translation(in: self.view)
            
            animator.fractionComplete = -translation.x / final
        case .ended:
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0.0)
        default: return
        }
    }
    
    /* для возварта на прошлый экран + нужно еще подписать на UIGestureRecognizerDelegate
      и реализовать  shouldBeRequiredToFailBy чтобы не забивалась swipe от pan
      https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/coordinating_multiple_gesture_recognizers/preferring_one_gesture_over_another
     */
    
    @objc func didSwipe(_ swipeGesture: UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "unwindToFriendsPhotos", sender: nil)

    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
             shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
       // Do not begin the pan until the swipe fails.
       if gestureRecognizer == self.swipeGesture &&
              otherGestureRecognizer == self.panGesture {
          return true
       }
       return false
    }
    
    
}
