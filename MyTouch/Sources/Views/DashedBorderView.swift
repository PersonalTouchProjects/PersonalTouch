//
//  DashedBorderView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/21.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class DashedBorderView: TouchTrackingView {

    var lineColor: UIColor = UIColor.black
    
    var lineWidth: CGFloat = 4
        
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 0)
        path.lineWidth = lineWidth
        
        let dashes: [CGFloat] = [lineWidth, lineWidth]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = CGLineCap.butt
        
        lineColor.setStroke()
        
        path.stroke()
    }
}
