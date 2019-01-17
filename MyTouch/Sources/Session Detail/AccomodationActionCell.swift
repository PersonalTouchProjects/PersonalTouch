//
//  AccomodationActionCell.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/17.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

protocol AccomodationActionCellDelegate: NSObjectProtocol {
    func actionCellDidSelectButton(cell: AccomodationActionCell)
}

class AccomodationActionCell: UITableViewCell {

    weak var delegate: AccomodationActionCellDelegate?
    
    let button: UIButton = Button(type: .custom)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .medium)
        button.setTitle("Go to Settings", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage.primaryButtonBackgroundImage(color: UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.00)), for: .normal)
        button.addTarget(self, action: #selector(handleButton(sender:)), for: .touchUpInside)
        
        selectionStyle = .none
        
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 160),
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleButton(sender: UIButton) {
        delegate?.actionCellDidSelectButton(cell: self)
    }
}

private extension AccomodationActionCell {
    
    class Button: UIButton {
        override var intrinsicContentSize: CGSize {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width + 36, height: 36)
        }
    }
    
}
