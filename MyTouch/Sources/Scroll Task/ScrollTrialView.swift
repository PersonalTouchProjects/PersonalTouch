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

class ScrollTrialView: TrialView {
    
    enum Distance: String {
        case short, long
        case unknown
    }
    
    var dataSource: ScrollTrialViewDataSource? {
        didSet { if superview != nil { reloadData() } }
    }
    
    let scrollView = UIScrollView()
    let targetView = UIView()
    let destinationView = UIView()
    
    private var numberOfRows:   Int = 1
    private var targetRow:      Int = 0
    private var destinationRow: Int = 0
    private var axis: ScrollTrial.Axis = .none
    
    private(set) var success: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.panGestureRecognizer.cancelsTouchesInView = false
//        scrollView.panGestureRecognizer.delegate = self
        scrollView.delaysContentTouches = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.delegate = self
        
        targetView.tintColor = .white
        targetView.backgroundColor = tintColor
        targetView.layer.cornerRadius = 8.0
        targetView.layer.masksToBounds = true
        
        destinationView.layer.masksToBounds = true
        destinationView.layer.cornerRadius = 8.0
        destinationView.layer.borderWidth = 2.0
        destinationView.layer.borderColor = UIColor.black.cgColor
        
        contentView.addSubview(scrollView)
//        contentView.addSubview(destinationView)
        
        scrollView.addSubview(targetView)
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
        
        scrollView.frame = contentView.bounds
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
    
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        
        
    }
    
    func reloadData() {
        
        reset()
        
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.panGestureRecognizer.cancelsTouchesInView = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        scrollView.isScrollEnabled = false
        
        print(rawTracks.first?.rawTouches.map({ $0.location }))
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        
    }
}

