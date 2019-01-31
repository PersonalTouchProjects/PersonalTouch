//
//  SessionBriefCell.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/17.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class SessionBriefView: UIView {
    
    let briefLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(briefLabel)
        
        briefLabel.numberOfLines = 0
        briefLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            briefLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1.0),
            briefLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            briefLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            briefLabel.bottomAnchor.constraint(equalToSystemSpacingAbove: bottomAnchor, multiplier: 1.0),
//            briefLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
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
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)
        ]
        
        return NSAttributedString(string: text, attributes: attrs)
    }
}
