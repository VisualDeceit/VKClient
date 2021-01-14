//
//  LoadingIndicator.swift
//  VkClient
//
//  Created by Alexander Fomin on 23.12.2020.
//

import UIKit


class LoadingIndicator: UIView {
    private var circles = [Сircle]()
    private var stackView: UIStackView!
    private var circlesCount = 4
    private var timerTest : Timer?
    private let timing = 0.2
    
    var circleSize: CGFloat = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      setupIndicatior()
       
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupIndicatior()
    }
    
    private func setupIndicatior() {
        backgroundColor = .clear
        
        for _ in 0..<circlesCount {
            let circle = Сircle()
            circles.append(circle)
        }
        
        stackView = UIStackView(arrangedSubviews: circles)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
        
//        let topConstraint = stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5)
//        let bottomConstraint = stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
//        let leadingConstraint = stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5)
//        let trailingConstraint = stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
//            self.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        
        NSLayoutConstraint.activate([
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
        ])
        
    }
    
    func startAnimation() {
        guard timerTest == nil else { return }
        
        timerTest =  Foundation.Timer.scheduledTimer(
            timeInterval: timing * Double(circlesCount + 2),
            target      : self,
            selector    : #selector(animation),
            userInfo    : nil,
            repeats     : true)
    }
    
    
    @objc private func animation(){
        for i in 0..<self.circlesCount {
            UIView.animate(withDuration: timing, delay: Double(i) * timing, options: [.curveLinear], animations: {
                self.circles[i].transform = self.transform.scaledBy(x: 1.2, y: 1.2)
                self.circles[i].alpha = 1
            }, completion: { _ in
                UIView.animate(withDuration: self.timing, animations: {
                    self.circles[i].transform = CGAffineTransform.identity
                    self.circles[i].alpha = 0.0
                })
            })
        }
        
    }
    
    func stopAnimation() {
        timerTest?.invalidate()
        timerTest = nil
    }

}

class Сircle: UIView {
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        alpha = 0
   }
    

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(UIColor(red: 0.153, green: 0.529, blue: 0.961, alpha: 1) .cgColor)
        let circleSize = min(self.frame.width, self.frame.height)
        context.fillEllipse(in: CGRect(x: self.frame.width/2 - circleSize/2, y: self.frame.height/2 - circleSize/2, width: circleSize, height: circleSize))
    }

}
