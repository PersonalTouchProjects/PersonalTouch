//
//  LongPressTrialView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/8/10.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

protocol LongPressTrialViewDataSource: NSObjectProtocol {
    func numberOfColumn(_ tapTrialView: LongPressTrialView) -> Int
    func numberOfRow(_ tapTrialView: LongPressTrialView) -> Int
    func targetColumn(_ tapTrialView: LongPressTrialView) -> Int
    func targetRow(_ tapTrialView: LongPressTrialView) -> Int
    func targetSize(_ tapTrialView: LongPressTrialView) -> CGSize
}

extension LongPressTrialViewDataSource {
    func targetSize(_ tapTrialView: LongPressTrialView) -> CGSize {
        return frameSize
    }
}

private let frameSize = CGSize(width: 44, height: 44)

class LongPressTrialView: TrialView {
    
    var dataSource: LongPressTrialViewDataSource? {
        didSet { if superview != nil { reloadData() } }
    }
    
    let targetView: UIView = TargetView()
    let longPressGestureRecognizer = UILongPressGestureRecognizer()
    
    private var columns = 1
    private var rows    = 1
    private var column  = 0
    private var row     = 0
    private var size    = frameSize
    
    private(set) var success: Bool = false
    
    private var beganLocation: CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(targetView)
        
        longPressGestureRecognizer.addTarget(self, action: #selector(handleLongPress))
        longPressGestureRecognizer.cancelsTouchesInView = false
        targetView.addGestureRecognizer(longPressGestureRecognizer)
        
        let _ = longPressGestureRecognizer.observe(\.state) { (recognizer, change) in
            
            print("observed")
            
            if recognizer.state == .possible {
                print("possible")
            }
            if recognizer.state == .began {
                print("began")
            }
            if recognizer.state == .changed {
                print("moved")
            }
        }
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
        
        let width  = contentView.bounds.width  / CGFloat(columns)
        let height = contentView.bounds.height / CGFloat(rows)
        
        let columnMidX = width  * (CGFloat(column) + 1/2)
        let rowMidY    = height * (CGFloat(row)    + 1/2)
        
        targetView.frame = CGRect(
            x: columnMidX - size.width/2,
            y: rowMidY - size.width/2,
            width: size.width,
            height: size.height
        )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first, event?.allTouches?.count == 1 else {
            return
        }
        
        let location = touch.location(in: targetView)
        if targetView.bounds.contains(location) {
            beganLocation = location
            targetView.alpha = 0.5
        } else {
            targetView.alpha = 1.0
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first, event?.allTouches?.count == 1 else {
            return
        }
        
        if let beganLocation = beganLocation {
            let location = touch.location(in: targetView)
            
            let dx = beganLocation.x - location.y
            let dy = beganLocation.y - location.y
            let dz = sqrt(dx * dx + dy * dy)
            
            //print(dz)
            
            if dz > longPressGestureRecognizer.allowableMovement {
                targetView.alpha = 1.0
                self.beganLocation = nil
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        targetView.alpha = 1.0
        beganLocation = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        targetView.alpha = 1.0
        beganLocation = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began && targetView.bounds.contains(sender.location(in: targetView)) {
            // print("success")
            success = true
            
            targetView.alpha = 1.0
            targetView.backgroundColor = UIColor(red:0.23, green:0.65, blue:0.34, alpha:1.00)
            
            beganLocation = nil
            
        } else if !success {
            targetView.alpha = 1.0
            targetView.backgroundColor = self.tintColor
            
            beganLocation = nil
        }
    }
    
    func reloadData() {
        
        reset()
        
        success = false
        
        targetView.alpha = 1.0
        targetView.backgroundColor = self.tintColor
        
        beganLocation = nil
        
        columns = dataSource?.numberOfColumn(self) ?? 1
        rows    = dataSource?.numberOfRow(self)    ?? 1
        column  = dataSource?.targetColumn(self)   ?? 0
        row     = dataSource?.targetRow(self)      ?? 0
        size    = dataSource?.targetSize(self)     ?? frameSize
        
        assert(column >= 0 && column < columns, "Out of bounds")
        assert(row >= 0 && row < rows, "Out of bounds")
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension LongPressTrialView {
    
    final class TargetView: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = self.tintColor
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        /*
        override func draw(_ rect: CGRect) {
            
            UIColor.white.setFill()
            
            var frame = CGRect(
                x: rect.midX - 15,
                y: rect.midY - 2,
                width: 30,
                height: 4
            )
            var rectangle = UIBezierPath(rect: frame)
            rectangle.fill()
            
            
            frame = CGRect(
                x: rect.midX - 2,
                y: rect.midY - 15,
                width: 4,
                height: 30
            )
            rectangle = UIBezierPath(rect: frame)
            rectangle.fill()
        }
        */
    }
}
