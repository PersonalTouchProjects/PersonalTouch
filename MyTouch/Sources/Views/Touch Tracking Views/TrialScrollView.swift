//
//  TrialScrollView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TrialScrollView: TouchTrackingScrollView, TrialViewProtocol {
    
    private(set) var gestureRecognizerEvents = [GestureRecognizerEvent]()
    
    private let _delegate = TrialViewGestureRecognizerDelegate()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func reset() {
        super.reset()
        gestureRecognizerEvents.removeAll()
    }
    
    private func setup() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(_handleTap(_:)))
        tap.cancelsTouchesInView = false
        tap.delegate = _delegate
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(_handleLongPress(_:)))
        longPress.cancelsTouchesInView = false
        longPress.delegate = _delegate
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(_handlePan(_:)))
        pan.cancelsTouchesInView = false
        pan.delegate = _delegate
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(_handleSwipe(_:)))
        swipe.direction = [.right, .left, .up, .down]
        swipe.cancelsTouchesInView = false
        swipe.delegate = _delegate
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(_handlePinch(_:)))
        pinch.cancelsTouchesInView = false
        pinch.delegate = _delegate
        
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(_handleRotation(_:)))
        rotation.cancelsTouchesInView = false
        rotation.delegate = _delegate
        
        addGestureRecognizer(tap)
        addGestureRecognizer(longPress)
        addGestureRecognizer(pan)
        addGestureRecognizer(swipe)
        addGestureRecognizer(pinch)
        addGestureRecognizer(rotation)
        
    }
    
    @objc private func _handleTap(_ sender: UITapGestureRecognizer) {
        self.gestureRecognizerEvents.append(TapGestureRecognizerEvent(recognizer: sender))
    }
    
    @objc private func _handleLongPress(_ sender: UILongPressGestureRecognizer) {
        self.gestureRecognizerEvents.append(LongPressGestureRecognizerEvent(recognizer: sender))
    }
    
    @objc private func _handlePan(_ sender: UIPanGestureRecognizer) {
        self.gestureRecognizerEvents.append(PanGestureRecognizerEvent(recognizer: sender))
    }
    
    @objc private func _handleSwipe(_ sender: UISwipeGestureRecognizer) {
        self.gestureRecognizerEvents.append(SwipeGestureRecognizerEvent(recognizer: sender))
    }
    
    @objc private func _handlePinch(_ sender: UIPinchGestureRecognizer) {
        self.gestureRecognizerEvents.append(PinchGestureRecognizerEvent(recognizer: sender))
    }
    
    @objc private func _handleRotation(_ sender: UIRotationGestureRecognizer) {
        self.gestureRecognizerEvents.append(RotationGestureRecognizerEvent(recognizer: sender))
    }
}
