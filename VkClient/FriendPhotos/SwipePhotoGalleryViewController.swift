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
    @IBOutlet weak var imageView3: UIImageView!
    
    var panGesture: UIPanGestureRecognizer!
    var animator: UIViewPropertyAnimator!
    var swipeGesture: UISwipeGestureRecognizer!
    
    var centerImageView: UIImageView!
    var rightImageView: UIImageView!
    var leftImageView: UIImageView!
    
    var centerFramePosition: CGRect!
    var rightFramePosition: CGRect!
    var leftFramePosition: CGRect!
    
    var datasource =  [Photo]()
    var index: Int = 0
    
    enum Direction {
        case Left, Right
        
        var title: String {
            switch self {
            case .Left:
                return "to left"
            case .Right:
                return "to right"

            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupGallery()
    }
    

    private func setupGallery() {
        
        //позиции фремов
        centerFramePosition = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
      
        rightFramePosition = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        leftFramePosition = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        

        //imageView1.backgroundColor = .red
        imageView1.frame = centerFramePosition
        
        
        imageView2.frame = rightFramePosition
        //imageView2.backgroundColor = .blue
        
        imageView3.frame = leftFramePosition
        //imageView3.backgroundColor = .green
       
        //ссылки на imageViews для удобвства анимации и перемещения
        centerImageView = imageView1
        rightImageView = imageView2
        leftImageView = imageView3
        
        // картинки по умолчанию
        centerImageView.image = datasource[index].imageData
        
        if index + 1 < datasource.count {
            rightImageView.image = datasource[index + 1].imageData
        } else {
            rightImageView.image = datasource[0].imageData
        }
        
        if index - 1 >= 0 {
            leftImageView.image = datasource[index - 1].imageData
        } else {
            leftImageView.image = datasource[datasource.count - 1].imageData
        }
        
        
        //активируем жесты
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        view.addGestureRecognizer(panGesture)
        panGesture.delegate = self
        
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        swipeGesture.delegate = self
        
    }

    //Перемещение ImageView поссле анимации
    private func reconfigureImageViews(to dir: Direction) {
        //пролистали влево
        if dir == .Left {
            
            //меняем местами ссылки на imageView
            let tempImageView = centerImageView
            centerImageView = rightImageView
            rightImageView = tempImageView
            
            //возвращаем на место
            rightImageView.frame = rightFramePosition
            rightImageView.alpha  = 1
            rightImageView.transform = .identity
            
            index = index + 1 < datasource.count ? index + 1 : 0
            
            
        } else if dir == .Right {
            
            //меняем местами ссылки на imageView
            let tempImageView = centerImageView
            centerImageView = leftImageView
            leftImageView = tempImageView
            
            //возвращаем на место
            leftImageView.frame = leftFramePosition
            leftImageView.alpha  = 1
            leftImageView.transform = .identity
            
            index = index - 1 >= 0 ? index - 1 : datasource.count - 1
        }
        
        if index == datasource.count-1 {
        rightImageView.image = datasource[0].imageData
        } else {
            rightImageView.image = datasource[index + 1].imageData
        }
       
        if index == 0 {
        leftImageView.image = datasource[datasource.count-1].imageData
        } else {
            leftImageView.image = datasource[index - 1].imageData
        }
        
    }
    
    //разбор анимации и жеста
    @objc func didPan( _ panGesture: UIPanGestureRecognizer) {

        let finalPosition = UIScreen.main.bounds.width
        let direction: Direction = panGesture.velocity(in: self.view).x > 0 ? .Right : .Left
    
        switch panGesture.state {
       
        case .began:

            animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn)
 
            switch direction {
            case .Left:
                animator.addAnimations {
                    //в самой анимации используем ссылки на ImageView чтобы не плодить ветви с вариантами
                    UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: []) {

                            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                                self.centerImageView.layer.transform =  CATransform3DMakeScale(0.8, 0.8, 0.8)
                            }

                            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75) {
                                self.centerImageView.frame  =  self.centerImageView.frame.offsetBy(dx:  -finalPosition, dy: 0.0)
                                self.rightImageView.frame  =  self.rightImageView.frame.offsetBy(dx:  -finalPosition, dy: 0.0)
                            }
                            
                            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                                self.centerImageView.alpha  = 0.0
                            }
                        }
                }
            case .Right:
                animator.addAnimations {
                    UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: []) {

                            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                                self.centerImageView.layer.transform =  CATransform3DMakeScale(0.8, 0.8, 0.8)
                            }

                            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75) {
                                self.centerImageView.frame  =  self.centerImageView.frame.offsetBy(dx:  finalPosition, dy: 0.0)
                                self.leftImageView.frame  =  self.leftImageView.frame.offsetBy(dx:  finalPosition, dy: 0.0)
                            }
                            
                            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                                self.centerImageView.alpha  = 0.0
                            }
                        }
                }
            }

            animator.addCompletion { _ in
                //по завершению переммещаем imageview
                self.reconfigureImageViews(to: direction)
            }
            
            animator.pauseAnimation()
            
        case .changed:
            
            let translation = panGesture.translation(in: self.view)
            let multiplayer = direction == .Left ?  -1 : 1
            animator.fractionComplete = CGFloat(multiplayer) * translation.x / finalPosition
            
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
