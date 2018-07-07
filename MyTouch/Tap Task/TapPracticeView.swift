//
//  TapTaskExampleView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/30.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

@available(*, deprecated)
class TapPracticeView: TouchTrackingView {

    let targetView = UIView()
    let targetSize = CGSize(width: 80, height: 80)
    
    let tzuChuan = TzuChuanGestureRecognizer()
    let tapGestureRecognizer = UITapGestureRecognizer()
    let touchUpInsideGestureRecognizer = TouchUpInsideGestureRecognizer()
    private(set) var tapRecognized = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        targetView.backgroundColor = tintColor
        targetView.layer.cornerRadius = 8.0
        
        addSubview(targetView)
        
        tapGestureRecognizer.addTarget(self, action: #selector(handleTap(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self
        addGestureRecognizer(tapGestureRecognizer)
        
        tzuChuan.addTarget(self, action: #selector(handleTzuChuan(_:)))
        tzuChuan.cancelsTouchesInView = false
        tzuChuan.delegate = self
        addGestureRecognizer(tzuChuan)
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
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        if targetView.bounds.contains(sender.location(in: targetView)) {
            tapRecognized = true
        }
    }
    
    @objc func handleTzuChuan(_ sender: TzuChuanGestureRecognizer) {
//        print(sender.direction.rawValue)
    }
    
    override func reset() {
        super.reset()
        tapRecognized = false
    }
}

extension TapPracticeView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

