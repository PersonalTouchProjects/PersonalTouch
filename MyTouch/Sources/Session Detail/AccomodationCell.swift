//
//  AccomodationCell.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/16.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class AccomodationCell: MyTouchBaseCell {
    
    var holdDurationText: String?
    var ignoreRepeatText: String?
    var accomodationText: String?
    
    let button: UIButton = ActionButton()

    private let titleLabel = UILabel()
    private let itemViewStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.text = "Accomodation Suggestions"
        
        itemViewStack.axis = .vertical
        itemViewStack.alignment = .fill
        itemViewStack.spacing = 0.0
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .medium)
        button.setTitle("Go to Settings", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage.primaryButtonBackgroundImage(color: UIColor(hex: 0x00b894)), for: .normal)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(itemViewStack)
        containerView.addSubview(button)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemViewStack.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: containerView.topAnchor, multiplier: 2.0),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.readableContentGuide.leadingAnchor, multiplier: 1.0),
            titleLabel.trailingAnchor.constraint(equalToSystemSpacingBefore: containerView.readableContentGuide.trailingAnchor, multiplier: 1.0),
            
            itemViewStack.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1.0),
            itemViewStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            itemViewStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            button.topAnchor.constraint(equalToSystemSpacingBelow: itemViewStack.bottomAnchor, multiplier: 2.0),
            button.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            button.bottomAnchor.constraint(equalToSystemSpacingAbove: containerView.bottomAnchor, multiplier: 2.0)
        ])
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        itemViewStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        itemViews().enumerated().forEach { itemViewStack.insertArrangedSubview($1, at: $0) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func itemViews() -> [ItemView] {
        
        var results: [ItemView] = []
        
        if let text = holdDurationText {
            let itemView = ItemView()
            itemView.titleLabel.text = "Hold Duration"
            itemView.valueLabel.text = text
            itemView.unitLabel.text = "Sec."
            itemView.separator.isHidden = results.count == 0
            results.append(itemView)
        }
        if let text = ignoreRepeatText {
            let itemView = ItemView()
            itemView.titleLabel.text = "Ignore Repeat"
            itemView.valueLabel.text = text
            itemView.unitLabel.text = "Sec."
            itemView.separator.isHidden = results.count == 0
            results.append(itemView)
        }
        if let text = accomodationText {
            let itemView = ItemView()
            itemView.titleLabel.text = "Touch Accomodation"
            itemView.valueLabel.text = text
            itemView.unitLabel.text = "Sec."
            itemView.extraLabel.text = "Use initial touch location"
            itemView.separator.isHidden = results.count == 0
            results.append(itemView)
        }
        
        return results
    }
}

extension AccomodationCell {
    
    private class ItemView: UIView {
        
        let titleLabel = UILabel()
        let valueLabel = UILabel()
        let unitLabel = UILabel()
        let extraLabel = UILabel()
        let separator = UIView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            
            valueLabel.font = UIFont.systemFont(ofSize: 48, weight: .regular)
            valueLabel.adjustsFontSizeToFitWidth = true
            valueLabel.minimumScaleFactor = 0.5
            
            unitLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            extraLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            
            let valueStack = UIStackView(arrangedSubviews: [valueLabel, unitLabel])
            valueStack.axis = .horizontal
            valueStack.alignment = .firstBaseline
            valueStack.spacing = 4.0
            
            let stack = UIStackView(arrangedSubviews: [valueStack, extraLabel])
            stack.axis = .vertical
            stack.alignment = .trailing
            
            separator.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            
            addSubview(titleLabel)
            addSubview(stack)
            addSubview(separator)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            stack.translatesAutoresizingMaskIntoConstraints = false
            separator.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2.0),
                titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: readableContentGuide.leadingAnchor, multiplier: 1.0),
                
                stack.trailingAnchor.constraint(equalToSystemSpacingBefore: readableContentGuide.trailingAnchor, multiplier: 1.0),
                stack.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1.0),
                stack.bottomAnchor.constraint(equalToSystemSpacingAbove: bottomAnchor, multiplier: 1.0),
                
                separator.topAnchor.constraint(equalTo: topAnchor),
                separator.leadingAnchor.constraint(equalToSystemSpacingAfter: readableContentGuide.leadingAnchor, multiplier: 0.5),
                separator.trailingAnchor.constraint(equalToSystemSpacingBefore: readableContentGuide.trailingAnchor, multiplier: 0.5),
                separator.heightAnchor.constraint(equalToConstant: 1.0),
            ])
            
            // add observation
            
            let _ = extraLabel.observe(\.text, options: [.initial, .new]) { (label, change) in
                if let newValue = change.newValue, newValue  == nil {
                    label.isHidden = true
                } else {
                    label.isHidden = false
                }
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    private class ActionButton: UIButton {
        
        override var intrinsicContentSize: CGSize {
            let size = super.intrinsicContentSize
            let width = max(size.width + 36, 100)
            let height = max(size.height + 12, 40)
            return CGSize(width: width, height: height)
        }
    }
}
