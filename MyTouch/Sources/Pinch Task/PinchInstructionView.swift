//
//  PinchInstructionView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class PinchInstructionView: UIView {
    
    private let targetView = UIView()
    private let destinationView = UIView()
    private let handView = UIImageView(image: UIImage(named: "finger_and_thumb"))
    private let thumbArrowView = UIImageView(image: UIImage(named: "rounded_arrow"))
    private let fingerArrowView = UIImageView(image: UIImage(named: "rounded_arrow"))
    
    private let arrowsView = UIView()
    
    private(set) var isAnimating = false
    
    private var targetInitialConstraints = [NSLayoutConstraint]()
    private var targetFinalConstraints = [NSLayoutConstraint]()
    
    private var arrowInitialConstraints = [NSLayoutConstraint]()
    private var arrowFinalConstraints = [NSLayoutConstraint]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fingerArrowView.tintColor = .black
        
        thumbArrowView.tintColor = .black
        thumbArrowView.transform = CGAffineTransform(rotationAngle: .pi)
        
        arrowsView.addSubview(thumbArrowView)
        arrowsView.addSubview(fingerArrowView)
        
        thumbArrowView.translatesAutoresizingMaskIntoConstraints = false
        fingerArrowView.translatesAutoresizingMaskIntoConstraints = false
        
        arrowInitialConstraints = [
            fingerArrowView.topAnchor.constraint(equalTo: arrowsView.topAnchor),
            fingerArrowView.centerXAnchor.constraint(equalTo: arrowsView.centerXAnchor),
            
            thumbArrowView.bottomAnchor.constraint(equalTo: arrowsView.bottomAnchor),
            thumbArrowView.centerXAnchor.constraint(equalTo: arrowsView.centerXAnchor)
        ]
        
        arrowFinalConstraints = [
            fingerArrowView.topAnchor.constraint(equalTo: arrowsView.topAnchor, constant: -20),
            fingerArrowView.centerXAnchor.constraint(equalTo: arrowsView.centerXAnchor),
            
            thumbArrowView.bottomAnchor.constraint(equalTo: arrowsView.bottomAnchor, constant: 20),
            thumbArrowView.centerXAnchor.constraint(equalTo: arrowsView.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(arrowInitialConstraints)
        
        targetView.backgroundColor = tintColor
        targetView.layer.cornerRadius = 8.0
        targetView.layer.masksToBounds = true
        
        destinationView.layer.masksToBounds = true
        destinationView.layer.cornerRadius = 8.0
        destinationView.layer.borderWidth = 2.0
        destinationView.layer.borderColor = UIColor.black.cgColor
        
        arrowsView.transform = CGAffineTransform(rotationAngle: 22.5 * .pi / 180).scaledBy(x: 2/3, y: 2/3)
        
        addSubview(targetView)
        addSubview(destinationView)
        addSubview(handView)
        addSubview(arrowsView)
        
        targetView.translatesAutoresizingMaskIntoConstraints = false
        destinationView.translatesAutoresizingMaskIntoConstraints = false
        handView.translatesAutoresizingMaskIntoConstraints = false
        arrowsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            arrowsView.widthAnchor.constraint(equalToConstant: 120),
            arrowsView.heightAnchor.constraint(equalTo: arrowsView.widthAnchor),
            
            arrowsView.leftAnchor.constraint(equalTo: destinationView.rightAnchor, constant: 0),
            arrowsView.topAnchor.constraint(equalTo: centerYAnchor),
            
            handView.topAnchor.constraint(equalTo: arrowsView.topAnchor, constant: 25),
            handView.leftAnchor.constraint(equalTo: arrowsView.centerXAnchor, constant: -20),
            
            destinationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            destinationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            destinationView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2),
            destinationView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2),
        ])
        
        targetInitialConstraints = [
            targetView.centerXAnchor.constraint(equalTo: centerXAnchor),
            targetView.centerYAnchor.constraint(equalTo: centerYAnchor),
            targetView.widthAnchor.constraint(equalTo: destinationView.widthAnchor, multiplier: 0.5),
            targetView.heightAnchor.constraint(equalTo: destinationView.heightAnchor, multiplier: 0.5)
        ]
        
        targetFinalConstraints = [
            targetView.centerXAnchor.constraint(equalTo: centerXAnchor),
            targetView.centerYAnchor.constraint(equalTo: centerYAnchor),
            targetView.widthAnchor.constraint(equalTo: destinationView.widthAnchor, multiplier: 1.0),
            targetView.heightAnchor.constraint(equalTo: destinationView.heightAnchor, multiplier: 1.0)
        ]
        
        NSLayoutConstraint.activate(targetInitialConstraints)
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

        NSLayoutConstraint.deactivate(self.arrowInitialConstraints)
        NSLayoutConstraint.activate(self.arrowFinalConstraints)
        
        NSLayoutConstraint.deactivate(self.targetInitialConstraints)
        NSLayoutConstraint.activate(self.targetFinalConstraints)
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveEaseInOut], animations: {
            
            self.layoutIfNeeded()
            
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
        
        NSLayoutConstraint.deactivate(arrowFinalConstraints)
        NSLayoutConstraint.activate(arrowInitialConstraints)
        
        NSLayoutConstraint.deactivate(targetFinalConstraints)
        NSLayoutConstraint.activate(targetInitialConstraints)
        
        layoutIfNeeded()
    }
}
