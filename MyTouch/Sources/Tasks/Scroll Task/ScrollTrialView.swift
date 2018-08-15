//
//  ScrollTrialView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

protocol ScrollTrialViewDataSource: NSObjectProtocol {
    func numberOfItems(_ scrollTrialView: ScrollTrialView) -> Int
    func initialItem(_ scrollTrialView: ScrollTrialView) -> Int
    func targetItem(_ scrollTrialView: ScrollTrialView) -> Int
    func axis(_ scrollTrialView: ScrollTrialView) -> ScrollTrial.Axis
}

class ScrollTrialView: TrialCollectionView {
    
    var trialDataSource: ScrollTrialViewDataSource? {
        didSet { if superview != nil { reloadData() } }
    }
    
    private let visibleItems: CGFloat = 4
    
    private var numberOfItems: Int = 1
    private var initialItem:   Int = 0
    private var targetItem:    Int = 0
    private var axis: ScrollTrial.Axis = .none {
        didSet {
            switch axis {
            case .horizontal:
                self.showsHorizontalScrollIndicator = true
                self.showsVerticalScrollIndicator = false
                self.flowLayout.scrollDirection = .horizontal
            case .vertical:
                self.showsHorizontalScrollIndicator = false
                self.showsVerticalScrollIndicator = true
                self.flowLayout.scrollDirection = .vertical
            default:
                self.showsHorizontalScrollIndicator = true
                self.showsVerticalScrollIndicator = false
                self.flowLayout.scrollDirection = .horizontal
            }
        }
    }
    
    private var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    private(set) var success: Bool = false
    private(set) var initialOffset: CGPoint = .zero
    private(set) var targetOffset:  CGPoint = .zero
    private(set) var finalOffset:   CGPoint = .zero
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let hintLabel = UILabel()
    
    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        backgroundColor = .white
        delaysContentTouches = false
        
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        dataSource = self
        delegate = self
        
        hintLabel.textColor = .white
        hintLabel.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 8
        
        insertSubview(blurView, at: 100000)
        insertSubview(hintLabel, aboveSubview: blurView)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hintLabel.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            hintLabel.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
            
            blurView.widthAnchor.constraint(equalTo: hintLabel.widthAnchor, multiplier: 1.0, constant: 20),
            blurView.heightAnchor.constraint(equalTo: hintLabel.heightAnchor, multiplier: 1.0, constant: 20),
            
            blurView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            blurView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 40)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if superview == nil && newSuperview != nil {
            self.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if flowLayout.scrollDirection == .horizontal {
            let width = bounds.width / visibleItems
            flowLayout.itemSize = CGSize(width: width, height: bounds.height)
        } else {
            let height = bounds.height / visibleItems
            flowLayout.itemSize = CGSize(width: bounds.width, height: height)
        }
    }
    
    override func reloadData() {
        
        reset()
        
        success = false
        
        numberOfItems = trialDataSource?.numberOfItems(self) ?? 1
        initialItem   = trialDataSource?.initialItem(self)   ?? 0
        targetItem    = trialDataSource?.targetItem(self)    ?? 0
        axis          = trialDataSource?.axis(self)          ?? .none
        
        super.reloadData()
        setNeedsLayout()
        layoutIfNeeded()
        
        hintLabel.text = "目標：\(targetItem+1)"
        
        if flowLayout.scrollDirection == .horizontal {
            let width = bounds.width / visibleItems
            contentOffset.x = (CGFloat(initialItem) - 0.5) * width
            
            targetOffset = CGPoint(x: CGFloat(targetItem) * width, y: bounds.minY)
        } else {
            let height = bounds.height / visibleItems
            contentOffset.y = (CGFloat(initialItem) - 0.5) * height
            
            targetOffset = CGPoint(x: bounds.minX, y: CGFloat(targetItem) * height)
        }
        
        initialOffset = contentOffset
    }
}

extension ScrollTrialView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        // label
        if cell.contentView.viewWithTag(10000) == nil {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 42, weight: .bold)
            label.tag = 10000
            cell.contentView.addSubview(label)
            label.frame = cell.contentView.bounds
            label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        if let label = cell.contentView.viewWithTag(10000) as? UILabel {
            label.text = "\(indexPath.item + 1)"
        }
        // end of label
        
        // background color
        if indexPath.item == targetItem {
            cell.contentView.backgroundColor = tintColor
        }
        else if indexPath.item % 2 == 0 {
            cell.contentView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        } else {
            cell.contentView.backgroundColor = .white
        }
        
        return cell
    }
    
    // UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == targetItem {
            success = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == targetItem {
            success = false
        }
    }
    
    // UIScrollViewDelegate
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        finalOffset = targetContentOffset.pointee
    }
}

extension ScrollTrialView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
