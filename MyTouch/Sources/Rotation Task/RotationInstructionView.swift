//
//  RotationInstructionView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class RotationInstructionView: UIView {
    
    private let targetView = UIImageView(image: UIImage(named: "compass"))
    private let handView = UIImageView(image: UIImage(named: "finger_and_thumb"))
    private let fingerArrowView = UIImageView(image: UIImage(named: "rotation_arrow"))
    private let layoutGuide = UILayoutGuide()
    
    private(set) var isAnimating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        targetView.contentMode = .scaleAspectFit
        targetView.transform = CGAffineTransform(rotationAngle: .pi / 6)
        
        fingerArrowView.contentMode = .scaleAspectFit
        fingerArrowView.tintColor = .black
        fingerArrowView.transform = CGAffineTransform(rotationAngle: -90 * .pi / 180).scaledBy(x: 2/3, y: 2/3)
        
        handView.transform = CGAffineTransform(rotationAngle: .pi / 6)
        
        
        addSubview(targetView)
        addSubview(fingerArrowView)
        addSubview(handView)
        addLayoutGuide(layoutGuide)
        
        targetView.translatesAutoresizingMaskIntoConstraints = false
        fingerArrowView.translatesAutoresizingMaskIntoConstraints = false
        handView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            layoutGuide.centerXAnchor.constraint(equalTo: centerXAnchor),
            layoutGuide.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            
            fingerArrowView.leftAnchor.constraint(equalTo: handView.leftAnchor, constant: -20),
            fingerArrowView.topAnchor.constraint(equalTo: handView.topAnchor, constant: 0),
            
            handView.topAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            handView.leftAnchor.constraint(equalTo: layoutGuide.rightAnchor, constant: 20),
            
            targetView.centerXAnchor.constraint(equalTo: centerXAnchor),
            targetView.centerYAnchor.constraint(equalTo: centerYAnchor),
            targetView.widthAnchor.constraint(equalToConstant: 150),
            targetView.heightAnchor.constraint(equalTo: targetView.heightAnchor)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        
        isAnimating = true
        animate()
    }
    
    func stopAnimating() {
        
        isAnimating = false
        layer.removeAllAnimations()
        reset()
    }
    
    private func animate() {
        
        guard self.isAnimating else {
            return
        }

//        handView.layer.anchorPoint = CGPoint(x: 90/120, y: 70/120)
        
        UIView.animate(withDuration: 1.0, delay: 1.0, options: [.curveEaseInOut], animations: {
            
            self.targetView.transform = .identity
            self.handView.transform = .identity
            
        }, completion: { _ in
            
            guard self.isAnimating else {
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                
                self.reset()
                
                if self.isAnimating {
                    self.animate()
                }
            }
            
        })
        
    }
    
    private func reset() {
        
//        handView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        targetView.transform = CGAffineTransform(rotationAngle: .pi / 6)
        handView.transform = CGAffineTransform(rotationAngle: .pi / 6)
        
        layoutIfNeeded()
    }
}
