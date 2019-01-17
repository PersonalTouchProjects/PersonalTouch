//
//  SessionBriefCell.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/17.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class SessionBriefCell: UITableViewCell {
    
    let briefLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(briefLabel)
        
        briefLabel.numberOfLines = 0
        briefLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            briefLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            briefLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            briefLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            briefLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func attributedText(for text: String) -> NSAttributedString {
        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        style.lineSpacing = 8.0
        style.alignment = .center
        
        let attrs = [
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)
        ]
        
        return NSAttributedString(string: text, attributes: attrs)
    }
}
