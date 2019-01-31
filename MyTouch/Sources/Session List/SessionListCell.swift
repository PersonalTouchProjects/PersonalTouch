//
//  SessionListCell.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/16.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class SessionListCell: MyTouchBaseCell {
    
    let iconView = UIView()
    let dateSeparator = UIView()
    let versionSeparator = UIView()
    
    let dateLabel = UILabel()
    let stateLabel = UILabel()
    let titleLabel = UILabel()
    let osLabel = UILabel()
    let versionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconView.layer.cornerRadius = 14
        iconView.backgroundColor = UIColor(hex: 0x00b894)
        
        dateSeparator.backgroundColor = UIColor(white: 204/255, alpha: 1.0)
        versionSeparator.backgroundColor = UIColor(white: 204/255, alpha: 1.0)
        
        titleLabel.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .semibold)
        
        dateLabel.textColor = UIColor(white: 102/255, alpha: 1.0)
        dateLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .medium)
        
        stateLabel.textColor = UIColor(white: 102/255, alpha: 1.0)
        stateLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .medium)
        
        osLabel.textColor = UIColor(white: 102/255, alpha: 1.0)
        osLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .medium)
        
        versionLabel.textColor = UIColor(white: 102/255, alpha: 1.0)
        versionLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .medium)
        
        let dateStack = UIStackView(arrangedSubviews: [dateLabel, dateSeparator, stateLabel])
        dateStack.axis = .horizontal
        dateStack.alignment = .fill
        dateStack.spacing = 4.0
        
        let versionStack = UIStackView(arrangedSubviews: [osLabel, versionSeparator, versionLabel])
        versionStack.axis = .horizontal
        versionStack.alignment = .fill
        versionStack.spacing = 4.0
        
        let labelStack = UIStackView(arrangedSubviews: [dateStack, titleLabel, versionStack])
        labelStack.axis = .vertical
        labelStack.alignment = .leading
        labelStack.spacing = 6.0
        
        containerView.addSubview(iconView)
        containerView.addSubview(labelStack)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),
            
            labelStack.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 20),
            labelStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            labelStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            dateSeparator.widthAnchor.constraint(equalToConstant: 1),
            versionSeparator.widthAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
