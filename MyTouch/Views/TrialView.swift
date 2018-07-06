//
//  TrialView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/4.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TrialView: TouchTrackingView {
    
    let contentView = TrialContentView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        insertSubview(contentView, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }
}

final class TrialContentView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}
