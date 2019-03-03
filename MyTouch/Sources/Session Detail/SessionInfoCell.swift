//
//  SessionInfoCell.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/17.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class SessionInfoCell: MyTouchBaseCell {

    var items: [Item] = []
    
    let titleLabel = UILabel()
    private let itemViewStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        itemViewStack.axis = .vertical
        itemViewStack.alignment = .fill
        itemViewStack.spacing = 0.0
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(itemViewStack)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemViewStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: containerView.topAnchor, multiplier: 2.0),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.readableContentGuide.leadingAnchor, multiplier: 1.0),
            titleLabel.trailingAnchor.constraint(equalToSystemSpacingBefore: containerView.readableContentGuide.trailingAnchor, multiplier: 1.0),
            
            itemViewStack.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1.0),
            itemViewStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            itemViewStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            itemViewStack.bottomAnchor.constraint(equalToSystemSpacingAbove: containerView.bottomAnchor, multiplier: 1.0)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        layoutItemViews()
    }
    
    func layoutItemViews() {
        itemViewStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        itemViews().enumerated().forEach { itemViewStack.insertArrangedSubview($1, at: $0) }
    }
    
    private func itemViews() -> [ItemView] {
        
        let results: [ItemView] = items.map { item in
            let itemView = ItemView()
            itemView.titleLabel.text = item.title
            itemView.textLabel.text = item.text
            return itemView
        }
        
        results.last?.separator.isHidden = true
        
        return results
    }
    
}

extension SessionInfoCell {
    
    struct Item {
        var title: String
        var text: String
    }
    
    private class ItemView: UIView {
        
        let titleLabel = UILabel()
        let textLabel = UILabel()
        let separator = UIView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            textLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            textLabel.textColor = UIColor(white: 0.3, alpha: 1.0)
            
            separator.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            
            addSubview(titleLabel)
            addSubview(textLabel)
            addSubview(separator)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            separator.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1.5),
                titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: readableContentGuide.leadingAnchor, multiplier: 1.0),
                titleLabel.bottomAnchor.constraint(equalToSystemSpacingAbove: bottomAnchor, multiplier: 1.5),
                
                textLabel.firstBaselineAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor),
                textLabel.trailingAnchor.constraint(equalToSystemSpacingBefore: readableContentGuide.trailingAnchor, multiplier: 1.0),
                textLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 1.0),
                
                separator.bottomAnchor.constraint(equalTo: bottomAnchor),
                separator.leadingAnchor.constraint(equalToSystemSpacingAfter: readableContentGuide.leadingAnchor, multiplier: 0.5),
                separator.trailingAnchor.constraint(equalToSystemSpacingBefore: readableContentGuide.trailingAnchor, multiplier: 0.5),
                separator.heightAnchor.constraint(equalToConstant: 1.0),
            ])
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    override func prepareForReuse() {
        items.removeAll()
        itemViewStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        super.prepareForReuse()
    }
}
