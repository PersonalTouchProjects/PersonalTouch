//
//  NSLayoutAnchor+HCI.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/31.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

extension NSLayoutXAxisAnchor {
    
    func constraint(equalToSystemSpacingBefore before: NSLayoutXAxisAnchor, multiplier: CGFloat) -> NSLayoutConstraint {
        return before.constraint(equalToSystemSpacingAfter: self, multiplier: multiplier)
    }
}

extension NSLayoutYAxisAnchor {
    
    func constraint(equalToSystemSpacingAbove above: NSLayoutYAxisAnchor, multiplier: CGFloat) -> NSLayoutConstraint {
        return above.constraint(equalToSystemSpacingBelow: self, multiplier: multiplier)
    }
}
