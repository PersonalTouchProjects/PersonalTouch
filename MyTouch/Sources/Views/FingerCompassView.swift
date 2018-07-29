//
//  FingerCompassView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/26.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class FingerCompassView: UIView {

    var expectedAngle: CGFloat = 0.0 {
        didSet { setNeedsDisplay() }
    }
    var currentAngle: CGFloat = 0.0 {
        didSet { setNeedsDisplay() }
    }
    
    private var _rotationBeginAngle: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let rotationGestureRecoginzer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        addGestureRecognizer(rotationGestureRecoginzer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleRotation(_ sender: UIRotationGestureRecognizer) {
        
        switch sender.state {
        case .began:
            _rotationBeginAngle = currentAngle
            
        case .changed:
            currentAngle = _rotationBeginAngle! + sender.rotation
            
        case .ended, .cancelled, .failed:
            _rotationBeginAngle = nil
            
        default:
            break
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let matched = abs(currentAngle - expectedAngle).degree < 1
        
        let backgroundPath = UIBezierPath(rect: rect)
        if matched {
            tintColor.setFill()
        } else {
            UIColor.white.setFill()
        }
        backgroundPath.fill()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let line = UIBezierPath(arcCenter: center, radius: max(rect.width, rect.height), startAngle: expectedAngle, endAngle: expectedAngle, clockwise: true)
        line.addLine(to: center)
        line.close()

        if matched {
            UIColor.white.setStroke()
        } else {
            tintColor.setStroke()
        }
        line.setLineDash([10,10], count: 2, phase: 0)
        line.lineWidth = 2.0
        line.stroke()
        
        let circle = UIBezierPath(arcCenter: center, radius: 204, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        circle.close()
        
        UIColor.white.setFill()
        circle.fill()
        
        tintColor.setStroke()
        circle.lineWidth = 2.0
        circle.stroke()
        
        if !matched {
            let sector = UIBezierPath(arcCenter: center, radius: 200, startAngle: expectedAngle, endAngle: currentAngle, clockwise: currentAngle > expectedAngle)
            sector.addLine(to: center)
            sector.close()
            
            tintColor.setFill()
            sector.fill()
        }
    }
}

extension FloatingPoint {
    
    var degree: Self {
        return self * 180 / .pi
    }
    
    var radian: Self {
        return self * .pi / 180
    }
}
