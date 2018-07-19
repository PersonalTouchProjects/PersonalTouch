//
//  ScrollInstructionView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class ScrollInstructionView: UIView {
    
    private let targetView = UIView()
    private let destinationView = UIView()
    private let fingerView = UIImageView(image: UIImage(named: "Finger"))
    
    private(set) var isAnimating = false
    
    private var targetInitialConstraints = [NSLayoutConstraint]()
    private var targetFinalConstraints   = [NSLayoutConstraint]()
    
    private var fingerOnTargetConstraints = [NSLayoutConstraint]()
//    private var fingerOnTargetFinalConstraints   = [NSLayoutConstraint]()
    
    private var fingerOffTargetConstraints = [NSLayoutConstraint]()
//    private var fingerOffFinalConstraints   = [NSLayoutConstraint]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        targetView.backgroundColor = tintColor
        targetView.layer.cornerRadius = 8.0
        targetView.layer.masksToBounds = true
        
        destinationView.layer.masksToBounds = true
        destinationView.layer.cornerRadius = 8.0
        destinationView.layer.borderWidth = 2.0
        destinationView.layer.borderColor = UIColor.black.cgColor
        
        addSubview(targetView)
        addSubview(destinationView)
        addSubview(fingerView)
        
        targetView.translatesAutoresizingMaskIntoConstraints = false
        destinationView.translatesAutoresizingMaskIntoConstraints = false
        fingerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            destinationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            destinationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            destinationView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            destinationView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),

            targetView.centerYAnchor.constraint(equalTo: centerYAnchor),
            targetView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            targetView.heightAnchor.constraint(equalTo: destinationView.heightAnchor),
            
            fingerView.topAnchor.constraint(equalTo: targetView.centerYAnchor)
        ])
        
        targetInitialConstraints = [
            targetView.leftAnchor.constraint(equalTo: leftAnchor)
        ]
        
        targetFinalConstraints = [
            targetView.centerXAnchor.constraint(equalTo: destinationView.centerXAnchor)
        ]
        
        fingerOnTargetConstraints = [
            fingerView.centerXAnchor.constraint(equalTo: targetView.centerXAnchor)
        ]
        
        fingerOffTargetConstraints = [
            fingerView.leftAnchor.constraint(equalTo: targetView.rightAnchor, constant: 8)
        ]
        
        NSLayoutConstraint.activate(targetInitialConstraints)
        NSLayoutConstraint.activate(fingerOnTargetConstraints)
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
        
        animateFingerOnTarget()
    }
    
    private func animateFingerOnTarget() {
        
        guard self.isAnimating else {
            return
        }
        
        NSLayoutConstraint.deactivate(fingerOffTargetConstraints)
        NSLayoutConstraint.activate(fingerOnTargetConstraints)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.fingerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
            NSLayoutConstraint.deactivate(self.targetInitialConstraints)
            NSLayoutConstraint.activate(self.targetFinalConstraints)
            
            UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveEaseInOut], animations: {
                
                self.layoutIfNeeded()
                
            }, completion: { _ in
                
                guard self.isAnimating else {
                    return
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    
                    self.fingerView.transform = .identity
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        
                        self.reset()
                        
                        if self.isAnimating {
                            self.animateFingerOffTarget()
                        }
                    }
                }
            })
        }
    }
    
    private func animateFingerOffTarget() {
        
        guard self.isAnimating else {
            return
        }
        
        NSLayoutConstraint.deactivate(fingerOnTargetConstraints)
        NSLayoutConstraint.activate(fingerOffTargetConstraints)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.fingerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
            NSLayoutConstraint.deactivate(self.targetInitialConstraints)
            NSLayoutConstraint.activate(self.targetFinalConstraints)
            
            UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveEaseInOut], animations: {
                
                self.layoutIfNeeded()
                
            }, completion: { _ in
                
                guard self.isAnimating else {
                    return
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    
                    self.fingerView.transform = .identity
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        
                        self.reset()
                        
                        if self.isAnimating {
                            self.animateFingerOnTarget()
                        }
                    }
                }
            })
        }
    }
    
    private func reset() {
        
        fingerView.transform = .identity
        
        NSLayoutConstraint.deactivate(targetFinalConstraints)
        NSLayoutConstraint.activate(targetInitialConstraints)
        
        layoutIfNeeded()
    }
}
