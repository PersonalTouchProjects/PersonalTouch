//
//  SwipeTrialView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/18.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

protocol SwipeTrialViewDataSource: NSObjectProtocol {
    func swipeArea(_ swipeTrialView: SwipeTrialView) -> SwipeTrialView.SwipeArea
    func direction(_ swipeTrialView: SwipeTrialView) -> SwipeTrial.Direction
}

class SwipeTrialView: TrialView {
    
    enum SwipeArea {
        case left, right
        case none
    }
    
    var dataSource: SwipeTrialViewDataSource? {
        didSet { if superview != nil { reloadData() } }
    }
    
    let arrowView = UIImageView(image: UIImage(named: "arrow"))
    let areaView = UIView()
    let backgroundView = UIView()
    let tzuchuanRecognizer = TzuChuanGestureRecognizer()
    
    private var swipeArea = SwipeArea.none
    private var targetDirection = SwipeTrial.Direction.none
    private(set) var recognizedDirection = SwipeTrial.Direction.none
    
    private(set) var success: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        arrowView.tintColor = .white
        areaView.backgroundColor = tintColor
        backgroundView.backgroundColor = .black
        
        contentView.addSubview(backgroundView)
        contentView.addSubview(areaView)
        contentView.addSubview(arrowView)
        
        tzuchuanRecognizer.addTarget(self, action: #selector(handleSwipe(_:)))
        tzuchuanRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(tzuchuanRecognizer)
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
        backgroundView.frame = bounds
        
        areaView.frame = CGRect(
            x: contentView.bounds.minX,
            y: contentView.bounds.minY,
            width: contentView.bounds.width / 2,
            height: contentView.bounds.height
        )
        if swipeArea == .right {
            areaView.frame.origin.x += areaView.bounds.width
        }
        
        arrowView.transform = .identity
        
        arrowView.frame.size = arrowView.intrinsicContentSize
        arrowView.center = areaView.center
        
        arrowView.transform = CGAffineTransform(rotationAngle: targetDirection.rotationRadian)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleSwipe(_ sender: TzuChuanGestureRecognizer) {
        recognizedDirection = SwipeTrial.Direction(rawValue: sender.direction.rawValue) ?? .none
    }
    
    func reloadData() {
        
        reset()
        
        success = false

        swipeArea           = dataSource?.swipeArea(self) ?? .none
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
        case .upRight:   angle = 45
        case .up:        angle = 90
        case .upLeft:    angle = 135
        case .left:      angle = 180
        case .downLeft:  angle = 225
        case .down:      angle = 270
        case .downRight: angle = 315
        default:         angle = 0
        }
        
        return -angle * .pi / 180
    }
}
