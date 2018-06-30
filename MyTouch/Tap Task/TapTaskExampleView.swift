//
//  TapTaskExampleView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/30.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TapTaskExampleView: TouchTrackingView {

    let targetView = UIView()
    let targetSize = CGSize(width: 80, height: 80)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isMultipleTouchEnabled = true
        isTrackEnabled = true
        isVisualLogEnabled = true
        
        targetView.backgroundColor = tintColor
        targetView.layer.cornerRadius = 8.0
        
        addSubview(targetView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        targetView.frame = CGRect(
            x: bounds.midX - targetSize.width/2,
            y: bounds.midY - targetSize.width/2,
            width: targetSize.width,
            height: targetSize.height
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
