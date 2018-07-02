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

class TapTrialView: TouchTrackingView {

    var dataSource: TapTrialViewDataSource?
    
    let targetView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        targetView.backgroundColor = tintColor
        targetView.layer.cornerRadius = 8.0
        
        addSubview(targetView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let columns = dataSource?.numberOfColumn(self) ?? 1
        let rows    = dataSource?.numberOfRow(self)    ?? 1
        let column  = dataSource?.targetColumn(self)   ?? 1
        let row     = dataSource?.targetRow(self)      ?? 1
        let size    = dataSource?.targetSize(self)     ?? CGSize(width: 80, height: 80)
        
        assert(column >= 0 && column < columns, "Out of bounds")
        assert(row >= 0 && row < rows, "Out of bounds")
        
        let width  = bounds.width  / CGFloat(columns)
        let height = bounds.height / CGFloat(rows)
        
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

}
