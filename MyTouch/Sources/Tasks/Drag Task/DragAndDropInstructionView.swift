//
//  DragAndDropInstructionView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class DragAndDropInstructionView: UIView {
    
    private let targetView = TapTrialView.TargetView()
    private let destinationView = UIView()
    private let fingerView = UIImageView(image: UIImage(named: "finger"))
    
    private(set) var isAnimating = false
    
    private let targetGuide = UILayoutGuide()
    private var targetInitialConstraints = [NSLayoutConstraint]()
    private var targetFinalConstraints = [NSLayoutConstraint]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        targetView.tintColor = .white
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
        addLayoutGuide(targetGuide)
        
        targetView.translatesAutoresizingMaskIntoConstraints = false
        destinationView.translatesAutoresizingMaskIntoConstraints = false
        fingerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            targetGuide.centerXAnchor.constraint(equalTo: centerXAnchor),
            targetGuide.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            
            destinationView.centerXAnchor.constraint(equalTo: targetGuide.rightAnchor),
            destinationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            destinationView.widthAnchor.constraint(equalToConstant: 80),
            destinationView.heightAnchor.constraint(equalTo: destinationView.widthAnchor),
            
            targetView.widthAnchor.constraint(equalToConstant: 80),
            targetView.heightAnchor.constraint(equalTo: targetView.widthAnchor),
            
            fingerView.centerXAnchor.constraint(equalTo: targetView.centerXAnchor, constant: 10),
            fingerView.topAnchor.constraint(equalTo: targetView.centerYAnchor)
        ])
        
        targetInitialConstraints = [
            targetView.centerXAnchor.constraint(equalTo: targetGuide.leftAnchor),
            targetView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        targetFinalConstraints = [
            targetView.centerXAnchor.constraint(equalTo: targetGuide.rightAnchor),
            targetView.centerYAnchor.constraint(equalTo: centerYAnchor),
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
                            self.animate()
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
