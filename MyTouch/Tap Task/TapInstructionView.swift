//
//  TapInstructionView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/17.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TapInstructionView: UIView {

    private let targetView = TapTrialView.TargetView()
    private let fingerClickView = UIImageView()
    
    private(set) var isAnimating = false
    
    private var initialConstraints = [NSLayoutConstraint]()
    private var targetConstraints = [NSLayoutConstraint]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fingerClickView.image = UIImage(named: "click_1")
        
        addSubview(targetView)
        addSubview(fingerClickView)
        
        targetView.translatesAutoresizingMaskIntoConstraints = false
        fingerClickView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            targetView.widthAnchor.constraint(equalToConstant: 44),
            targetView.heightAnchor.constraint(equalToConstant: 44),
            targetView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -100),
            targetView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -80),
        ])
        
        initialConstraints = [
            fingerClickView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 80),
            fingerClickView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        targetConstraints = [
            fingerClickView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -90),
            fingerClickView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50)
        ]
        
        NSLayoutConstraint.activate(initialConstraints)
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
        reset()
    }
    
    private func animate() {
    
        guard self.isAnimating else {
            return
        }
        
        NSLayoutConstraint.deactivate(initialConstraints)
        NSLayoutConstraint.activate(targetConstraints)
                
        UIView.animate(withDuration: 1.0, delay: 1.0, options: [.curveEaseInOut], animations: {
            
            self.layoutIfNeeded()
            
        }, completion: { _ in
            
            guard self.isAnimating else {
                return
            }
            
            self.fingerClickView.animationRepeatCount = 1
            self.fingerClickView.animationDuration = 0.6
            self.fingerClickView.animationImages = [
                UIImage(named: "click_1")!,
                UIImage(named: "click_2")!,
                UIImage(named: "click_3")!,
            ]
            self.fingerClickView.startAnimating()
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                
                self.reset()
                
                if self.isAnimating {
                    self.animate()
                }
            })
        })
    }
    
    private func reset() {
        
        fingerClickView.stopAnimating()
        fingerClickView.image = UIImage(named: "click_1")
        
        NSLayoutConstraint.deactivate(targetConstraints)
        NSLayoutConstraint.activate(initialConstraints)
        
        layoutIfNeeded()
    }
}

