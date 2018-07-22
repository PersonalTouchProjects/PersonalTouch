//
//  CountdownView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/1.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class CountdownView: UIView {

    var count: Int = 3
    var timeIntervalForEachCount: TimeInterval = 0.5
    
    let label = UILabel()
    
    private var remain = 0
    
    private var isInvalidated = true {
        didSet { setNeedsLayout() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        label.text = "\(count)"
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 144, weight: .medium)
        label.isHidden = true
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.isHidden = isInvalidated
    }
    
    func fire(completed: @escaping () -> ()) {
        isInvalidated = false
        label.isHidden = false
        
        if remain == 0 {
            remain = count
        } else {
            remain -= 1
        }
        
        if remain == 0 {
            invalidate()
            completed()
        } else {
            
            label.text = "\(remain)"
            label.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            
            UIView.animate(withDuration: timeIntervalForEachCount, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [.beginFromCurrentState],  animations: {
                
                self.label.transform = .identity
                
            }) { (finished) in
                
                self.fire(completed: completed)
            }
            
        }
    }
    
    func invalidate() {
        isInvalidated = true
    }
}
