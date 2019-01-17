//
//  SessionListCell.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/16.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class SessionListCell: UITableViewCell {

    let borderView = UIView()
    
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
        
        selectionStyle = .none
        
        borderView.backgroundColor = .white
        borderView.clipsToBounds = false
        borderView.layer.masksToBounds = false
        borderView.layer.shadowColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        borderView.layer.shadowOffset = CGSize.zero
        borderView.layer.shadowOpacity = 0.15
        borderView.layer.shadowRadius = 2.0
        borderView.layer.cornerRadius = 10.0
        
        iconView.layer.cornerRadius = 14
        iconView.backgroundColor = UIColor(red:0.00, green:0.64, blue:0.94, alpha:1.00)
        
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
        
        contentView.addSubview(borderView)
        contentView.addSubview(iconView)
        contentView.addSubview(labelStack)
        
        borderView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            borderView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            iconView.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 20),
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),
            
            labelStack.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 20),
            labelStack.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 12),
            labelStack.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -12),
            
            dateSeparator.widthAnchor.constraint(equalToConstant: 1),
            versionSeparator.widthAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        borderView.backgroundColor = highlighted ? UIColor(white: 230/255, alpha: 1.0) : UIColor.white
    }

}
