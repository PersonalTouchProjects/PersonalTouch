//
//  TaskCollectionViewCell.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/21.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TaskCollectionViewCell: UICollectionViewCell {
    
    let taskTitleLabel = UILabel()
    
    private let borderView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.clipsToBounds = false
        
        borderView.backgroundColor = .white
        borderView.layer.cornerRadius = 8
        borderView.layer.shadowColor = UIColor.black.cgColor
        borderView.layer.shadowOffset = .zero
        borderView.layer.shadowRadius = 4
        borderView.layer.shadowOpacity = 0.1
        borderView.layer.masksToBounds = false
        
        contentView.addSubview(borderView)
        contentView.addSubview(taskTitleLabel)
        
        borderView.translatesAutoresizingMaskIntoConstraints = false
        taskTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            borderView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            borderView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            taskTitleLabel.topAnchor.constraintEqualToSystemSpacingBelow(contentView.topAnchor, multiplier: 1.0),
            taskTitleLabel.leftAnchor.constraintEqualToSystemSpacingAfter(contentView.leftAnchor, multiplier: 1.0),
            
            contentView.rightAnchor.constraintEqualToSystemSpacingAfter(taskTitleLabel.rightAnchor, multiplier: 1.0),
            contentView.bottomAnchor.constraintEqualToSystemSpacingBelow(taskTitleLabel.bottomAnchor, multiplier: 1.0)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            borderView.backgroundColor = UIColor(white: isHighlighted ? 0.95 : 1.0, alpha: 1.0)
        }
    }
}
