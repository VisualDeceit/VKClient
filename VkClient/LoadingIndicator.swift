//
//  LoadingIndicator.swift
//  VkClient
//
//  Created by Alexander Fomin on 23.12.2020.
//

import UIKit

class Сircle: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(UIColor.lightGray.cgColor)
        context.fillEllipse(in: CGRect(x: 0, y: 0, width: 13, height: 13))
    }

}

class LoadingIndicator: UIView {
   
    private var circles = [Сircle]()
    private var stackView: UIStackView!
    private var circlesCount = 4
    private var timerTest : Timer?
    private let timing = 0.2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      setupIndicatior()
       
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupIndicatior()
        //backgroundColor = .red
    }
    
    private func setupIndicatior() {
        
        for i in 0..<circlesCount {
            let circle = Сircle(frame: CGRect(x: 20*i, y: Int(self.frame.height/2)-10, width: 20, height: 20))
            circles.append(circle)
            self.addSubview(circle)
        }
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
                self.circles[i].transform = self.transform.scaledBy(x: 1.4, y: 1.4)
            }, completion: { _ in
                UIView.animate(withDuration: self.timing, animations: {
                    self.circles[i].transform = CGAffineTransform.identity
                })
            })
        }
        
    }
    
    func stopAnimation() {
        timerTest?.invalidate()
        timerTest = nil
    }

}



//
//for _ in 0..<circlesCount {
//    //let circle = Сircle(frame: CGRect(x: 20*i, y: Int(self.frame.height)/2-10, width: 20, height: 20))
//    let circle = Сircle(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//    circle.translatesAutoresizingMaskIntoConstraints = true
//    circles.append(circle)
//   // self.addSubview(circle)
//}
//
//
//stackView = UIStackView(arrangedSubviews: self.circles)
//stackView.spacing = 10
//stackView.axis = .horizontal
//stackView.alignment = .fill
//stackView.distribution = .fill
//
//self.addSubview(stackView)
//
//stackView.translatesAutoresizingMaskIntoConstraints = false
//let topConstraint = stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
//let bottomConstraint = stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
//let leadingConstraint = stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
//let trailingConstraint = stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
//    self.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
//
