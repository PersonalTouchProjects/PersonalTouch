//
//  SwipeTrialView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/18.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

protocol SwipeTrialViewDataSource: NSObjectProtocol {
    func direction(_ swipeTrialView: SwipeTrialView) -> SwipeTrial.Direction
}

class SwipeTrialView: TrialView {
    
    var dataSource: SwipeTrialViewDataSource? {
        didSet { if superview != nil { reloadData() } }
    }
    
    let arrowView = UIImageView(image: UIImage(named: "arrow"))
    
    let upRecognizer = UISwipeGestureRecognizer()
    let downRecognizer = UISwipeGestureRecognizer()
    let leftRecognizer = UISwipeGestureRecognizer()
    let rightRecognizer = UISwipeGestureRecognizer()
    
    private var targetDirection = SwipeTrial.Direction.none
    private(set) var recognizedDirection = SwipeTrial.Direction.none
    
    private(set) var success: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(arrowView)
        
        upRecognizer.direction = .up
        upRecognizer.cancelsTouchesInView = false
        upRecognizer.addTarget(self, action: #selector(handleSwipe(_:)))
        
        downRecognizer.direction = .down
        downRecognizer.cancelsTouchesInView = false
        downRecognizer.addTarget(self, action: #selector(handleSwipe(_:)))
        
        leftRecognizer.direction = .left
        leftRecognizer.cancelsTouchesInView = false
        leftRecognizer.addTarget(self, action: #selector(handleSwipe(_:)))
        
        rightRecognizer.direction = .right
        rightRecognizer.cancelsTouchesInView = false
        rightRecognizer.addTarget(self, action: #selector(handleSwipe(_:)))
        
        addGestureRecognizer(upRecognizer)
        addGestureRecognizer(downRecognizer)
        addGestureRecognizer(leftRecognizer)
        addGestureRecognizer(rightRecognizer)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if superview == nil && newSuperview != nil {
            self.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
        
        arrowView.transform = .identity
        
        arrowView.frame.size = arrowView.intrinsicContentSize
        arrowView.center = contentView.center
        
        arrowView.transform = CGAffineTransform(rotationAngle: targetDirection.rotationRadian)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        
        switch (sender.direction, targetDirection) {
        case (.up, .up):
            success = true
            recognizedDirection = .up
        case (.up, _):
            recognizedDirection = .up
            
        case (.down, .down):
            success = true
            recognizedDirection = .down
        case (.up, _):
            recognizedDirection = .down
            
        case (.left, .left):
            success = true
            recognizedDirection = .left
        case (.left, _):
            recognizedDirection = .left
            
        case (.right, .right):
            success = true
            recognizedDirection = .right
        case (.right, _):
            recognizedDirection = .right
            
        default:
            break
        }
    }
    
    func reloadData() {
        
        reset()
        
        success = false

        targetDirection     = dataSource?.direction(self) ?? .none
        recognizedDirection = .none
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}

private extension SwipeTrial.Direction {
    
    var rotationRadian: CGFloat {
        
        let angle: CGFloat
        switch self {
        case .right:     angle = 0
        case .up:        angle = 90
        case .left:      angle = 180
        case .down:      angle = 270
        default:         angle = 0
        }
        
        return -angle * .pi / 180
    }
}
