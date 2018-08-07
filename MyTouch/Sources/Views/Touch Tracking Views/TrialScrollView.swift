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
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(_handleSwipe(_:)))
        swipeUp.direction = .up
        swipeUp.cancelsTouchesInView = false
        swipeUp.delegate = _delegate
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(_handleSwipe(_:)))
        swipeLeft.direction = .left
        swipeLeft.cancelsTouchesInView = false
        swipeLeft.delegate = _delegate
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(_handleSwipe(_:)))
        swipeRight.direction = .right
        swipeRight.cancelsTouchesInView = false
        swipeRight.delegate = _delegate
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(_handleSwipe(_:)))
        swipeDown.direction = .down
        swipeDown.cancelsTouchesInView = false
        swipeDown.delegate = _delegate
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(_handlePinch(_:)))
        pinch.cancelsTouchesInView = false
        pinch.delegate = _delegate
        
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(_handleRotation(_:)))
        rotation.cancelsTouchesInView = false
        rotation.delegate = _delegate
        
        addGestureRecognizer(tap)
        addGestureRecognizer(longPress)
        addGestureRecognizer(pan)
        addGestureRecognizer(swipeUp)
        addGestureRecognizer(swipeLeft)
        addGestureRecognizer(swipeRight)
        addGestureRecognizer(swipeDown)
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
