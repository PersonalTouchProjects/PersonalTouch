//
//  PinchTrialView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

protocol PinchTrialViewDataSource: NSObjectProtocol {
    func targetScale(_ pinchTrialView: PinchTrialView) -> CGFloat
}

class PinchTrialView: TrialView {
    
    var dataSource: PinchTrialViewDataSource? {
        didSet { if superview != nil { reloadData() } }
    }
    
    let targetView = TouchThroughView()
    let destinationView = TouchThroughView()
    let pinchGestureRecognizer = UIPinchGestureRecognizer()
    
    private var targetScale: CGFloat = 1.0
    private var currentScale: CGFloat = 1.0 {
        didSet { setNeedsLayout() }
    }
    private var pinchBeganFrame: CGRect?
    
    private(set) var initialFrame: CGRect = .zero
    private(set) var success: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        targetView.backgroundColor = tintColor
        targetView.layer.cornerRadius = 8.0
        
        destinationView.layer.masksToBounds = true
        destinationView.layer.cornerRadius = 8.0
        destinationView.layer.borderWidth = 2.0
        destinationView.layer.borderColor = UIColor.black.cgColor
        
        contentView.addSubview(targetView)
        contentView.addSubview(destinationView)
        
        pinchGestureRecognizer.addTarget(self, action: #selector(handlePinch(_:)))
        pinchGestureRecognizer.cancelsTouchesInView = false
        
        addGestureRecognizer(pinchGestureRecognizer)
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
        
        let width = contentView.bounds.width / 3
        let height = contentView.bounds.height / 3
        
        initialFrame = CGRect(
            x: contentView.bounds.midX - width / 2,
            y: contentView.bounds.midY - height / 2,
            width: width,
            height: height
        )
        
        let destinationWidth = width * targetScale
        let destinationHeight = height * targetScale
        
        destinationView.frame = CGRect(
            x: contentView.bounds.midX - destinationWidth / 2,
            y: contentView.bounds.midY - destinationHeight / 2,
            width: destinationWidth,
            height: destinationHeight
        )
        
        let currentWidth: CGFloat
        let currentHeight: CGFloat
        
        if let pinchBeganFrame = pinchBeganFrame {
            currentWidth = pinchBeganFrame.size.width * currentScale
            currentHeight = pinchBeganFrame.size.height * currentScale
        } else {
            currentWidth = initialFrame.size.width
            currentHeight = initialFrame.size.height
        }
        
        targetView.frame = CGRect(
            x: contentView.bounds.midX - currentWidth / 2,
            y: contentView.bounds.midY - currentHeight / 2,
            width: currentWidth,
            height: currentHeight
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handlePinch(_ sender: UIPinchGestureRecognizer) {
        
        switch sender.state {
        case .began:
            pinchBeganFrame = targetView.frame
        default:
            break
        }
        
        currentScale = sender.scale
    }
    
    func reloadData() {
        
        reset()
        
        targetScale = dataSource?.targetScale(self) ?? 1.0
        currentScale = 1.0
        pinchBeganFrame = nil
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}
