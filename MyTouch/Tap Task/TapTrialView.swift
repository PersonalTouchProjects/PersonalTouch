//
//  TapTrialView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/2.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

protocol TapTrialViewDataSource: NSObjectProtocol {
    func numberOfColumn(_ tapTrialView: TapTrialView) -> Int
    func numberOfRow(_ tapTrialView: TapTrialView) -> Int
    func targetColumn(_ tapTrialView: TapTrialView) -> Int
    func targetRow(_ tapTrialView: TapTrialView) -> Int
    func targetSize(_ tapTrialView: TapTrialView) -> CGSize
}

class TapTrialView: TrialView {

    var dataSource: TapTrialViewDataSource? {
        didSet { if superview != nil { reloadData() } }
    }
    
    let targetView: UIView = TargetView()
    
    private var columns = 1
    private var rows    = 1
    private var column  = 0
    private var row     = 0
    private var size    = CGSize(width: 80, height: 80)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        targetView.backgroundColor = tintColor
//        targetView.layer.cornerRadius = 8.0
        
        contentView.addSubview(targetView)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        
        reset()
        
        columns = dataSource?.numberOfColumn(self) ?? 1
        rows    = dataSource?.numberOfRow(self)    ?? 1
        column  = dataSource?.targetColumn(self)   ?? 0
        row     = dataSource?.targetRow(self)      ?? 0
        size    = dataSource?.targetSize(self)     ?? CGSize(width: 80, height: 80)
        
        assert(column >= 0 && column < columns, "Out of bounds")
        assert(row >= 0 && row < rows, "Out of bounds")
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}

private extension TapTrialView {
    
    class TargetView: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = .clear
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ rect: CGRect) {
            
            self.tintColor.setFill()
            
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
    }
}
