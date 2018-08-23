//
//  ScrollInstructionView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class ScrollInstructionView: UIView {
    
    private let contentView = UIView()
    private let stackView = UIStackView()
    private let fingerView = UIImageView(image: UIImage(named: "finger"))
    
    private var labels = [UILabel]()
    private(set) var isAnimating = false
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 600, height: 400)
    }
    
    var axis: ScrollTrial.Axis = .horizontal {
        didSet {
            stackView.axis = (axis == .horizontal) ? .horizontal : .vertical
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2.0
        
        labels = [
            label(with: 40, highlighted: false),
            label(with: 41, highlighted: false),
            label(with: 42, highlighted: false),
            label(with: 43, highlighted: false),
            label(with: 44, highlighted: false),
            label(with: 45, highlighted: false),
            label(with: 46, highlighted: false),
            label(with: 47, highlighted: false),
            label(with: 48, highlighted: false),
            label(with: 49, highlighted: false),
            label(with: 50, highlighted: false),
            label(with: 51, highlighted: false),
            label(with: 52, highlighted: false),
            label(with: 53, highlighted: false),
            label(with: 54, highlighted: false),
            label(with: 55, highlighted: false),
            label(with: 56, highlighted: false),
            label(with: 57, highlighted: true),
            label(with: 58, highlighted: false),
            label(with: 59, highlighted: false),
            label(with: 60, highlighted: false),
        ]
        labels.forEach { stackView.addArrangedSubview($0) }
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        contentView.clipsToBounds = true
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        contentView.addSubview(stackView)
        addSubview(fingerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if axis == .horizontal {
            
            stackView.frame = CGRect(
                x: bounds.minX,
                y: bounds.minY,
                width: bounds.width * CGFloat(labels.count/4),
                height: bounds.height
            )
            
            fingerView.frame.size = fingerView.intrinsicContentSize
            fingerView.frame.origin = CGPoint(
                x: bounds.maxX - fingerView.frame.width,
                y: bounds.maxY - fingerView.frame.height - 50
            )
            
        } else if axis == .vertical {
            
            stackView.frame = CGRect(
                x: bounds.minX,
                y: bounds.minY,
                width: bounds.width,
                height: bounds.height * CGFloat(labels.count/4)
            )
            
            fingerView.frame.size = fingerView.intrinsicContentSize
            fingerView.frame.origin = CGPoint(
                x: bounds.maxX - fingerView.frame.width - 20,
                y: bounds.maxY - fingerView.frame.height - 20
            )
        }
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
        
        UIView.animate(withDuration: 0.5, delay: 1.0, options: [.curveEaseInOut], animations: {
            
            if self.axis == .horizontal {
                self.fingerView.frame.origin.x = self.bounds.minX - self.fingerView.frame.width
            } else {
                self.fingerView.frame.origin.y = self.bounds.minY - 20
            }
            
        }, completion: nil)
        
        
        UIView.animate(withDuration: 3.0, delay: 1.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.3, options: [], animations: {
            
            if self.axis == .horizontal {
                self.stackView.frame.origin.x -= self.labels.first!.frame.width * 15
            } else {
                self.stackView.frame.origin.y -= self.labels.first!.frame.height * 15
            }
            
        }, completion: { _ in
            
            guard self.isAnimating else {
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                
                self.reset()
                
                if self.isAnimating {
                    self.animate()
                }
            })
            
        })
    }
    
    private func reset() {
        setNeedsLayout()
        layoutIfNeeded()
    }
}

private func label(with index: Int, highlighted: Bool) -> UILabel {
    
    let label = UILabel()
    label.text = "\(index)"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
    if highlighted {
        label.backgroundColor = label.tintColor
    } else if index % 2 == 0 {
        label.backgroundColor = .white
    } else {
        label.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
    }
    
    return label
}
