//
//  LikeIt.swift
//  VkClient
//
//  Created by Alexander Fomin on 13.12.2020.
//

import UIKit

class LikeIt: UIControl {
    
    var isLikeSet: Bool = false
    var likes: Int = 0
    
    private var button = UIButton(type: .system)
    private var label = UILabel(frame: CGRect(x: 10, y: 10, width: 50, height: 10))
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    func setupView(){
        button.setImage(UIImage(named: "heart.png"), for: .normal)
        //button.addTarget(self, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
        
        stackView = UIStackView(arrangedSubviews: [self.button, self.label])

        self.addSubview(stackView)

        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
