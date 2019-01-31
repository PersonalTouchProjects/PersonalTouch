//
//  SessionDetailBaseCell.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/31.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class MyTouchBaseCell: UITableViewCell {

    enum CornerStyle {
        case single, top, bottom, middle
    }
    
    var cornerStyle: CornerStyle = .single {
        didSet {
            switch cornerStyle {
            case .single:
                containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            case .top:
                containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case .bottom:
                containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            case .middle:
                containerView.layer.maskedCorners = []
            }
        }
    }
    
    let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        containerView.backgroundColor = .white
        containerView.clipsToBounds = false
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowOpacity = 0.15
        containerView.layer.shadowRadius = 2.0
        containerView.layer.cornerRadius = 10.0
        
        contentView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
//            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        containerView.backgroundColor = highlighted ? UIColor(hex: 0xdfe6e9) : UIColor.white
    }
}
