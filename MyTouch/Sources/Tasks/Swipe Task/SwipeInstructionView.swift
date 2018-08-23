//
//  SwipeInstructionView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/18.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class SwipeInstructionView: UIView {
    
    private let areaView = UIView()
    private let arrowView = UIImageView(image: UIImage(named: "arrow"))
    private let fingerView = UIImageView(image: UIImage(named: "finger"))
    
    private(set) var isAnimating = false
    
    private var initialConstraints = [NSLayoutConstraint]()
    private var targetConstraints = [NSLayoutConstraint]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        arrowView.contentMode = .scaleAspectFit
        
        addSubview(areaView)
        addSubview(arrowView)
        addSubview(fingerView)
        
        areaView.translatesAutoresizingMaskIntoConstraints = false
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        fingerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            areaView.centerXAnchor.constraint(equalTo: centerXAnchor),
            areaView.centerYAnchor.constraint(equalTo: centerYAnchor),
            areaView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0, constant: 0),
            areaView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8, constant: 0),
            
            arrowView.centerXAnchor.constraint(equalTo: centerXAnchor),
            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5, constant: 0.0)
        ])
        
        initialConstraints = [
            fingerView.centerXAnchor.constraint(equalTo: arrowView.leftAnchor),
            fingerView.topAnchor.constraint(equalTo: arrowView.centerYAnchor, constant: 20)
        ]
        
        targetConstraints = [
            fingerView.leftAnchor.constraint(equalTo: arrowView.rightAnchor),
            fingerView.topAnchor.constraint(equalTo: arrowView.centerYAnchor, constant: 20)
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
        layer.removeAllAnimations()
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                
                self.reset()
                
                if self.isAnimating {
                    self.animate()
                }
            })
        })
    }
    
    private func reset() {
        
        NSLayoutConstraint.deactivate(targetConstraints)
        NSLayoutConstraint.activate(initialConstraints)
        
        layoutIfNeeded()
    }
}
