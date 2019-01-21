//
//  SessionInfoCell.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/17.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class SessionInfoCell: UITableViewCell {

    let separator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        separator.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1.0)
        
        addSubview(separator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let left: CGFloat
        let right: CGFloat
        
        if self.traitCollection.horizontalSizeClass == .compact {
            left = layoutMargins.left
            right = 0.0
        } else {
            left = layoutMargins.left
            right = layoutMargins.right
        }
        
        let height: CGFloat = 1.0 / (window?.screen.scale ?? UIScreen.main.scale)
        let width: CGFloat = bounds.width - left - right
        
        separator.frame = CGRect(
            x: left,
            y: bounds.maxY - height,
            width: width,
            height: height
        )
    }
}
