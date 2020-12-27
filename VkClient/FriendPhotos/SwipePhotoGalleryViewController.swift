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
    
    var currentFrame: CGRect!
    var nextFrame: CGRect!
    var priorFrame: CGRect!
    
    var datasource =  [Photo]()
    var index: Int = 0
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initGallery()
    }
    
    
    
    private func initGallery() {
        
        currentFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
      
        nextFrame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        priorFrame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        imageView1.image = datasource[index].imageData
        //imageView1.backgroundColor = .red
        imageView1.frame = currentFrame
        
        imageView2.frame = nextFrame
       // imageView2.backgroundColor = .blue
       
        currentImageView = imageView1
        nextImageView = imageView2
        nextImageView.transform = CATransform3DGetAffineTransform(CATransform3DMakeScale(0.8, 0.8, 0.8))
        
        if index + 1 < datasource.count {
            index += 1
            imageView2.image = datasource[index].imageData
        }
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        view.addGestureRecognizer(panGesture)
        panGesture.delegate = self
        
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        swipeGesture.delegate = self
        
    
    }
    
    func changeImageViewPosition() {
        let tempImageView = currentImageView
        currentImageView.transform = .identity
        currentImageView = nextImageView
        currentImageView.frame = currentFrame
        
        nextImageView = tempImageView
        nextImageView.frame = nextFrame
        nextImageView.transform =  CATransform3DGetAffineTransform(CATransform3DMakeScale(0.8, 0.8, 0.8))
        if index + 1 < datasource.count {
            index += 1
        } else {
            index = 0
        }
        nextImageView.image = datasource[index].imageData

    }
    
    @objc func didPan( _ panGesture: UIPanGestureRecognizer) {
        
        let finalPosition = UIScreen.main.bounds.width
    
        switch panGesture.state {
       
        case .began:
            
            animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
                
                UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: []) {
    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.15) {
                        self.currentImageView.layer.transform =  CATransform3DMakeScale(0.8, 0.8, 0.8)
                    }

                    UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.7) {
                        self.currentImageView.frame  =  self.currentImageView.frame.offsetBy(dx:  -finalPosition, dy: 0.0)
                        self.nextImageView.frame  =  self.nextImageView.frame.offsetBy(dx:  -finalPosition, dy: 0.0)
                    }
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.15) {
                        self.nextImageView.transform = .identity
                    }
                }
            })

            animator.addCompletion { _ in self.changeImageViewPosition() }
            animator.pauseAnimation()
            
        case .changed:
            
            let translation = panGesture.translation(in: self.view)
            animator.fractionComplete = -translation.x / finalPosition
            
        case .ended:
            
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0.0)

        default: return
        }
    }
    
    /* для возварта на прошлый экран + нужно еще подписать на UIGestureRecognizerDelegate
      и реализовать  shouldBeRequiredToFailBy чтобы не забивалась swipe от pan
     */
    
    @objc func didSwipe(_ swipeGesture: UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "unwindToFriendsPhotos", sender: nil)

    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
             shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {

       if gestureRecognizer == self.swipeGesture &&
              otherGestureRecognizer == self.panGesture {
          return true
       }
       return false
    }
    
    
}
