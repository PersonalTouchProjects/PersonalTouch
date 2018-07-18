//
//  DragAndDropTrialView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/18.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

protocol DragAndDropTrialViewDataSource: NSObjectProtocol {
    func direction(_ dragAndDropTrialView: DragAndDropTrialView) -> DragAndDropTrialView.Direction
    func distance(_ dragAndDropTrialView: DragAndDropTrialView) -> DragAndDropTrialView.Distance
    func targetSize(_ dragAndDropTrialView: DragAndDropTrialView) -> CGSize
}

class DragAndDropTrialView: TrialView {
    
    enum Direction: String {
        case up, left, right, down
        case upLeft, upRight, downLeft, downRight
        case none
    }
    
    enum Distance: String {
        case short, long
        case unknown
    }
    
    var dataSource: DragAndDropTrialViewDataSource? {
        didSet { if superview != nil { reloadData() } }
    }
    
    
    let targetView = TapTrialView.TargetView()
    let destinationView = UIView()
    let panGestureRecognizer = UIPanGestureRecognizer()
    
    private(set) var initialFrame = CGRect.zero
    private var targetOffset: CGPoint? {
        didSet { setNeedsLayout() }
    }
    
    private var distance = Distance.unknown
    private var direction = Direction.none
    private var targetSize = CGSize.zero
    
    private(set) var success: Bool = false
    
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
        
        addSubview(destinationView)
        addSubview(targetView)
        
        panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        panGestureRecognizer.cancelsTouchesInView = false
        
        targetView.addGestureRecognizer(panGestureRecognizer)
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
        
        // destination frame
        destinationView.frame.size = targetSize
        let length = min(contentView.bounds.width, contentView.bounds.height) / 5
        let offset = direction.offset
        let multiplier = distance.multiplier
        
        destinationView.center = CGPoint(
            x: contentView.frame.midX + round(length * multiplier * offset.x),
            y: contentView.frame.midY + round(length * multiplier * offset.y)
        )
        
        // current target frame
        targetView.frame.size = targetSize
        if let offset = targetOffset {
            targetView.frame.origin = offset
        } else {
            targetView.center = contentView.center
            initialFrame = targetView.frame
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        
        if let currentOffset = targetOffset {
            
            let translation = sender.translation(in: self)
            targetOffset = CGPoint(
                x: currentOffset.x + translation.x,
                y: currentOffset.y + translation.y
            )
            sender.setTranslation(.zero, in: self)
        }
        
        switch sender.state {
        case .began:
            targetOffset = targetView.frame.origin
            
        case .ended, .failed, .cancelled:
            sender.isEnabled = false
            
        default:
            break
        }
    }
    
    func reloadData() {
        
        reset()
        
        success = false
        
        distance   = dataSource?.distance(self)   ?? .unknown
        direction  = dataSource?.direction(self)  ?? .none
        targetSize = dataSource?.targetSize(self) ?? .zero
        
        targetOffset = nil
        panGestureRecognizer.isEnabled = true
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension DragAndDropTrialView.Distance {
    
    var multiplier: CGFloat {
        switch self {
        case .unknown: return 0
        case .short:   return 1
        case .long:    return 2
        }
    }
}

extension DragAndDropTrialView.Direction {
    
    var offset: CGPoint {
        
        let m = CGFloat(sqrt(2))
        
        let x: CGFloat, y: CGFloat
        
        switch self {
        case .up:    (x, y) = (0, -1)
        case .left:  (x, y) = (-1, 0)
        case .down:  (x, y) = (0, 1)
        case .right: (x, y) = (1, 0)
            
        case .upLeft:    (x, y) = (-1/m, -1/m)
        case .upRight:   (x, y) = (1/m, -1/m)
        case .downLeft:  (x, y) = (-1/m, 1/m)
        case .downRight: (x, y) = (1/m, 1/m)
        
        default: (x, y) = (0, 0)
        }
        
        return CGPoint(x: x, y: y)
    }
}
