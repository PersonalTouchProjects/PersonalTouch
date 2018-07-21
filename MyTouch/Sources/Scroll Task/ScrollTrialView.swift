//
//  ScrollTrialView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

protocol ScrollTrialViewDataSource: NSObjectProtocol {
    func numberOfRows(_ scrollTrialView: ScrollTrialView) -> Int
    func targetRow(_ scrollTrialView: ScrollTrialView) -> Int
    func destinationRow(_ scrollTrialView: ScrollTrialView) -> Int
    func axis(_ scrollTrialView: ScrollTrialView) -> ScrollTrial.Axis
}

class ScrollTrialView: TrialScrollView {
        
    enum Distance: String {
        case short, long
        case unknown
    }
    
    var dataSource: ScrollTrialViewDataSource? {
        didSet { if superview != nil { reloadData() } }
    }
    
    let scrollView = TouchTrackingScrollView()
    let targetView = TouchThroughView()
    let destinationView = DashedBorderView()
    
    private var numberOfRows:   Int = 1
    private var targetRow:      Int = 0
    private var destinationRow: Int = 0
    private var axis: ScrollTrial.Axis = .none
    
    private(set) var success: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        scrollView.delaysContentTouches = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.delegate = self
        
        targetView.backgroundColor = tintColor
        
        scrollView.addSubview(targetView)

        addSubview(scrollView)
        addSubview(destinationView)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if superview == nil && newSuperview != nil {
            self.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        scrollView.contentSize = scrollView.bounds.size
        
        if axis == .horizontal {
            
            scrollView.contentInset.left = scrollView.bounds.width * 10
            scrollView.contentInset.right = scrollView.bounds.width * 10
            
            let width   = scrollView.bounds.width / CGFloat(numberOfRows)
            let height  = scrollView.bounds.height
            let offsetX = width * CGFloat(targetRow)
            
            targetView.frame = CGRect(
                x: scrollView.bounds.minX + offsetX,
                y: scrollView.bounds.minY,
                width: width,
                height: height
            )
            
            destinationView.frame = CGRect(
                x: bounds.minX + width * CGFloat(destinationRow),
                y: bounds.minY,
                width: width,
                height: height
            )
            
        } else if axis == .vertical {
            
            scrollView.contentInset.top = scrollView.bounds.height * 10
            scrollView.contentInset.bottom = scrollView.bounds.height * 10
            
            let width   = scrollView.bounds.width
            let height  = scrollView.bounds.height / CGFloat(numberOfRows)
            let offsetY = height * CGFloat(targetRow)
            
            targetView.frame = CGRect(
                x: scrollView.bounds.minX,
                y: scrollView.bounds.minY + offsetY,
                width: width,
                height: height
            )
            
            destinationView.frame = CGRect(
                x: bounds.minX,
                y: bounds.minY + height * CGFloat(destinationRow),
                width: width,
                height: height
            )
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        
        scrollView.reset()
        
        success = false
        
        numberOfRows   = dataSource?.numberOfRows(self)   ?? 1
        targetRow      = dataSource?.targetRow(self)      ?? 0
        destinationRow = dataSource?.destinationRow(self) ?? 0
        axis           = dataSource?.axis(self)           ?? .none
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension ScrollTrialView: UIScrollViewDelegate {
    
    // TODO: success?
}

extension ScrollTrialView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
