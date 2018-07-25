//
//  RotationTrialView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

protocol RotationTrialViewDataSource: NSObjectProtocol {
    func targetAngle(_ rotationTrialView: RotationTrialView) -> CGFloat
}


class RotationTrialView: TrialView {
    
    var dataSource: RotationTrialViewDataSource? {
        didSet { if superview != nil { reloadData() } }
    }
    
    let dashedLineView = DashedLineView()
    let compassView = UIImageView(image: UIImage(named: "compass"))
    let rotationGestureRecognizer = UIRotationGestureRecognizer()
    
    private(set) var initialAngle: CGFloat = 0.0
    private var currentGestureAngle: CGFloat? {
        didSet { setNeedsLayout() }
    }
    private var rotationBeganAngle: CGFloat?
    
    private(set) var success: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dashedLineView.lineWidth = 10
        dashedLineView.lineColor = .lightGray
        dashedLineView.horizontal = false
        
        contentView.addSubview(dashedLineView)
        contentView.addSubview(compassView)
        
        dashedLineView.translatesAutoresizingMaskIntoConstraints = false
        compassView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dashedLineView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dashedLineView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dashedLineView.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            dashedLineView.widthAnchor.constraint(equalToConstant: 4),
            
            compassView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            compassView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            compassView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5, constant: 0.0),
            compassView.widthAnchor.constraint(equalTo: compassView.heightAnchor)
        ])
        
        rotationGestureRecognizer.addTarget(self, action: #selector(handleRotation(_:)))
        rotationGestureRecognizer.cancelsTouchesInView = false
        
        addGestureRecognizer(rotationGestureRecognizer)
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
        
        if let beganAngle = rotationBeganAngle, let currentAngle = currentGestureAngle {
            compassView.transform = CGAffineTransform(rotationAngle: beganAngle + currentAngle)
        } else {
            compassView.transform = CGAffineTransform(rotationAngle: initialAngle)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleRotation(_ sender: UIRotationGestureRecognizer) {
        
        switch sender.state {
        case .began:
            rotationBeganAngle = compassView.transform.rotation
            success = true
        default:
            break
        }

        currentGestureAngle = sender.rotation
    }
    
    func reloadData() {
        
        reset()
        
        rotationBeganAngle = nil
        currentGestureAngle = nil
        success = false
        
        initialAngle = dataSource?.targetAngle(self) ?? 0.0
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}
