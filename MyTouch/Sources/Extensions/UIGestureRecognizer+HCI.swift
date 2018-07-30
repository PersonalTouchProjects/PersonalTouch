//
//  UIGestureRecognizer+HCI.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/30.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

private struct AssociatedKeys {
    static var kHoldDurationKey = "kHoldDurationKey"
    static var kFirstTouchBeganDateKey = "kFirstTouchBeganDateKey"
}

private var _holdDuration: TimeInterval?

extension UIGestureRecognizer {
    
    // MARK: - Runtime Properties
    
    var holdDuration: TimeInterval? {
        set {
            let duration = NSNumber(value: newValue ?? .greatestFiniteMagnitude)
            objc_setAssociatedObject(self, &AssociatedKeys.kHoldDurationKey, duration, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            if let duration = objc_getAssociatedObject(self, &AssociatedKeys.kHoldDurationKey) as? NSNumber {
                if duration.doubleValue == .greatestFiniteMagnitude {
                    return nil
                }
                return duration.doubleValue
            }
            return nil
        }
    }
    
    private var firstTouchBeganDate: Date? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.kFirstTouchBeganDateKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kFirstTouchBeganDateKey) as? Date
        }
    }
    
    
    // MARK: - Swizzled Methods
    
    @objc dynamic private func hci_setState(_ newValue: UIGestureRecognizerState) {
        
        guard let holdDuration = holdDuration, let beganDate = firstTouchBeganDate else {
            self.hci_setState(newValue)
            return
        }
        
        if Date().timeIntervalSince(beganDate) >= holdDuration {
            firstTouchBeganDate = nil
            self.hci_setState(newValue)
        }
    }
    
    @objc dynamic private func hci_swizzled_touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        
        if holdDuration != nil, firstTouchBeganDate == nil {
            firstTouchBeganDate = Date(timeIntervalSinceNow: -ProcessInfo.processInfo.systemUptime).addingTimeInterval(event.timestamp)
        }
        
        self.hci_swizzled_touchesBegan(touches, with: event)
    }
    
    @objc dynamic private func hci_swizzled_touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        firstTouchBeganDate = nil
        self.hci_swizzled_touchesEnded(touches, with: event)
    }
    
    @objc dynamic private func hci_swizzled_touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        firstTouchBeganDate = nil
        self.hci_swizzled_touchesCancelled(touches, with: event)
    }
    
    
    // MARK: - Swizzling
    
    static func swizzle() {
        swizzleState()
        swizzleTouchesBegan()
        swizzleTouchesEnded()
        swizzleTouchesCancelled()
    }
    
    static private func swizzleState() {
        
        let originalSelector = #selector(setter: UIGestureRecognizer.state)
        let swizzledSelector = #selector(UIGestureRecognizer.hci_setState(_:))
        
        guard let originalMethod = class_getInstanceMethod(self, originalSelector) else { return }
        guard let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) else { return }
        
        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
    
    static private func swizzleTouchesBegan() {
        
        let originalSelector = #selector(UIGestureRecognizer.touchesBegan(_:with:))
        let swizzledSelector = #selector(UIGestureRecognizer.hci_swizzled_touchesBegan(_:with:))
        
        guard let originalMethod = class_getInstanceMethod(self, originalSelector) else { return }
        guard let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) else { return }
        
        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))

        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
    
    static private func swizzleTouchesEnded() {
        
        let originalSelector = #selector(UIGestureRecognizer.touchesEnded(_:with:))
        let swizzledSelector = #selector(UIGestureRecognizer.hci_swizzled_touchesEnded(_:with:))
        
        guard let originalMethod = class_getInstanceMethod(self, originalSelector) else { return }
        guard let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) else { return }
        
        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
    
    static private func swizzleTouchesCancelled() {
        
        let originalSelector = #selector(UIGestureRecognizer.touchesCancelled(_:with:))
        let swizzledSelector = #selector(UIGestureRecognizer.hci_swizzled_touchesCancelled(_:with:))
        
        guard let originalMethod = class_getInstanceMethod(self, originalSelector) else { return }
        guard let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) else { return }
        
        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}
