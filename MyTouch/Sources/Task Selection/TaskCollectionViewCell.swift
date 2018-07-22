//
//  TaskCollectionViewCell.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/21.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TaskCollectionViewCell: UICollectionViewCell {
    
    enum IndicatorColor {
        case red, yellow, green
        case clear
    }
    
    var indicatorColor = IndicatorColor.clear {
        didSet {
            switch indicatorColor {
            case .red:    indicatorView.backgroundColor = UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1.0)
            case .yellow: indicatorView.backgroundColor = UIColor(red: 255/255.0, green: 204/255.0, blue: 0/255.0, alpha: 1.0)
            case .green:  indicatorView.backgroundColor = UIColor(red: 76/255.0, green: 217/255.0, blue: 100/255.0, alpha: 1.0)
            case .clear:  indicatorView.backgroundColor = .clear
            }
        }
    }
    
    var isCompleted = false {
        didSet {
            contentView.alpha = isCompleted ? 0.5 : 1.0
        }
    }
    
    let taskTitleLabel = UILabel()
    let subtitleLabel  = UILabel()
    
    private let borderView    = UIView()
    private let indicatorView = UIView()
    
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
        
        indicatorView.layer.cornerRadius = 2
        indicatorView.backgroundColor = .clear
        
        taskTitleLabel.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        subtitleLabel.numberOfLines = 0
        
        let labelStack = UIStackView(arrangedSubviews: [taskTitleLabel, subtitleLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 8
        labelStack.distribution = .equalSpacing
        labelStack.alignment = .leading
        
        contentView.addSubview(borderView)
        contentView.addSubview(indicatorView)
        contentView.addSubview(labelStack)
        
        borderView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            borderView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            borderView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            indicatorView.centerYAnchor.constraint(equalTo: labelStack.centerYAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: 4),
            indicatorView.topAnchor.constraintEqualToSystemSpacingBelow(contentView.topAnchor, multiplier: 1.0),
            indicatorView.leftAnchor.constraintEqualToSystemSpacingAfter(contentView.leftAnchor, multiplier: 1.0),
            
            labelStack.leftAnchor.constraintEqualToSystemSpacingAfter(indicatorView.rightAnchor, multiplier: 1.0),
            labelStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            contentView.rightAnchor.constraintEqualToSystemSpacingAfter(labelStack.rightAnchor, multiplier: 1.0),
            contentView.bottomAnchor.constraintEqualToSystemSpacingBelow(indicatorView.bottomAnchor, multiplier: 1.0)
            
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taskTitleLabel.text = nil
        subtitleLabel.text  = nil
        indicatorColor      = .clear
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
