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
    
    var direction: Direction = .Left
    
    var centerImageView: UIImageView!
    var rightImageView: UIImageView!
    var leftImageView: UIImageView!
    
    var centerFramePosition: CGRect!
    var rightFramePosition: CGRect!
    var leftFramePosition: CGRect!
    
    var datasource = [UserPhoto]() //[Photo]()
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
    
    var toLeftAnimation = {}
    var toRigtAnimation = {}
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupGallery()
        setupAnimations()
    }
    
    func getImage(for index: Int, to imageView: UIImageView){
        imageView.download(from: datasource[index].link) {[weak self] url in
            URL(string: (self?.datasource[index].link)!) == url
        }
    }
    

    private func setupGallery() {
        
        //позиции фремов
        centerFramePosition = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
      
        rightFramePosition = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        leftFramePosition = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        

        //imageView1.backgroundColor = .red
        imageView1.frame = centerFramePosition
        imageView1.enableZoom()
        
        
        imageView2.frame = rightFramePosition
        imageView2.enableZoom()
        //imageView2.backgroundColor = .blue
        
        imageView3.frame = leftFramePosition
        imageView3.enableZoom()
        //imageView3.backgroundColor = .green
       
        //ссылки на imageViews для удобвства анимации и перемещения
        centerImageView = imageView1
        rightImageView = imageView2
        leftImageView = imageView3
        
        // картинки по умолчанию
       //centerImageView.image = datasource[index].imageData
        getImage(for: index, to: centerImageView)
        
        if index + 1 < datasource.count {
           // rightImageView.image = datasource[index + 1].imageData
        getImage(for: index+1, to: rightImageView)
        } else {
            //rightImageView.image = datasource[0].imageData
            getImage(for: 0, to: rightImageView)
        }
        
        if index - 1 >= 0 {
            //leftImageView.image = datasource[index - 1].imageData
            getImage(for: index - 1, to: leftImageView)
        } else {
            //leftImageView.image = datasource[datasource.count - 1].imageData
            getImage(for: datasource.count - 1, to: leftImageView)
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
    
    private func setupAnimations() {
        
        let finalPosition = UIScreen.main.bounds.width
        
        toLeftAnimation = {
            
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                    self.centerImageView.layer.transform =  CATransform3DMakeScale(0.8, 0.8, 0.8)
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75) {
                    self.centerImageView.frame  =  self.centerImageView.frame.offsetBy(dx:  -finalPosition, dy: 0.0)
                    self.rightImageView.frame  =  self.rightImageView.frame.offsetBy(dx:  -finalPosition, dy: 0.0)
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 1) {
                    self.centerImageView.alpha  = 0.0
                }
            })
        }
        
        toRigtAnimation = {
            
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                    self.centerImageView.layer.transform =  CATransform3DMakeScale(0.8, 0.8, 0.8)
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75) {
                    self.centerImageView.frame  =  self.centerImageView.frame.offsetBy(dx:  finalPosition, dy: 0.0)
                    self.leftImageView.frame  =  self.leftImageView.frame.offsetBy(dx:  finalPosition, dy: 0.0)
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 1) {
                    self.centerImageView.alpha  = 0.0
                }
            })
        }
    }

    //Перемещение ImageView после анимации
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
        //rightImageView.image = datasource[0].imageData
            getImage(for: 0, to: rightImageView)
        } else {
            //rightImageView.image = datasource[index + 1].imageData
            getImage(for: index + 1, to: rightImageView)
        }
       
        if index == 0 {
            //leftImageView.image = datasource[datasource.count-1].imageData
            getImage(for: datasource.count-1, to: leftImageView)
        } else {
            //leftImageView.image = datasource[index - 1].imageData
            getImage(for: index - 1, to: leftImageView)
        }
        
    }
    
    //разбор анимации и жеста
    @objc func didPan( _ panGesture: UIPanGestureRecognizer) {

        let finalPosition = UIScreen.main.bounds.width

        switch panGesture.state {
       
        case .began:

            animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn)
            direction = panGesture.velocity(in: self.view).x > 0 ? .Right : .Left
 
            //выбор анимации
            switch direction {
            case .Left:
                animator.addAnimations(self.toLeftAnimation)
            case .Right:
                animator.addAnimations(self.toRigtAnimation)
            }

            animator.addCompletion { _ in
                //по завершению переммещаем imageview
                if !self.animator.isReversed {
                    self.reconfigureImageViews(to: self.direction)
                }
            }
            
            animator.pauseAnimation()
            
        case .changed:
            
            let translation = panGesture.translation(in: self.view)
            let multiplayer = direction == .Left ?  -1 : 1
            animator.fractionComplete = CGFloat(multiplayer) * translation.x / finalPosition
            
        case .ended:
           
            //отмена анимации
            let velocity = panGesture.velocity(in: self.view)
            let shouldCancel = direction == .Left && velocity.x > 0 || direction == .Right && velocity.x < 0 || animator.fractionComplete < 0.25
            if shouldCancel && !animator.isReversed { animator.isReversed.toggle() }
            
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
