//
//  AccomodationCell.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/16.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class AccomodationCell: MyTouchBaseCell {
    
    var session: Session?
    
    let button = UIButton()
    
    private let titleLabel = UILabel()
    private let itemViewStack = UIStackView()
    
    private var buttonConstraints: [NSLayoutConstraint] = []
    
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
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 18, bottom: 8, right: 18)
        
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
            containerView.bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: itemViewStack.bottomAnchor, multiplier: 2.0),
        ])
        
        buttonConstraints = [
            button.topAnchor.constraint(equalToSystemSpacingBelow: itemViewStack.bottomAnchor, multiplier: 2.0),
            button.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            button.bottomAnchor.constraint(equalToSystemSpacingAbove: containerView.bottomAnchor, multiplier: 2.0)
        ]
        
        NSLayoutConstraint.activate(buttonConstraints)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        layoutItemViews()
    }
    
    func layoutItemViews() {
        
        itemViewStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard let session = session else {
            return
        }

        switch session.state {
        case .analyzing:
            button.isHidden = true
            itemViewStack.insertArrangedSubview(analyzingView(), at: 0)
            NSLayoutConstraint.deactivate(buttonConstraints)
            
        case .local:
            button.isHidden = false
            button.setTitle("Upload", for: .normal)
            itemViewStack.insertArrangedSubview(localSessionView(), at: 0)
            NSLayoutConstraint.activate(buttonConstraints)
            
        case .error:
            button.isHidden = false
            button.setTitle("Test Again", for: .normal)
            itemViewStack.insertArrangedSubview(errorView(), at: 0)
            NSLayoutConstraint.activate(buttonConstraints)
            
        case .completed:
            button.isHidden = false
            button.setTitle("Go to Settings", for: .normal)
            itemViews().enumerated().forEach { itemViewStack.insertArrangedSubview($1, at: $0) }
            NSLayoutConstraint.activate(buttonConstraints)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func analyzingView() -> UIView {
        let view = PromptView()
//        view.imageView.backgroundColor = session?.state.color ?? UIColor.gray
        view.imageView.image = UIImage(named: "image_analyzing_1")
        view.titleLabel.text = "正在分析中"
        return view
        
    }
    
    private func localSessionView() -> UIView {
        let view = PromptView()
//        view.imageView.backgroundColor = session?.state.color ?? UIColor.gray
        view.imageView.image = UIImage(named: "image_cached")
        view.titleLabel.text = "資料尚未上傳至伺服器"
        return view
    }
    
    private func errorView() -> UIView {
        let view = PromptView()
//        view.imageView.backgroundColor = session?.state.color ?? UIColor.gray
        view.imageView.image = UIImage(named: "image_error")
        view.titleLabel.text = "發生不可預期之錯誤"
        return view
    }
    
    private func itemViews() -> [ItemView] {
        
        guard let session = session, session.state == .completed else {
            return []
        }
        
        var results: [ItemView] = []
        
        if let value = session.holdDuration, value != 0 {
            let itemView = ItemView()
            itemView.titleLabel.text = "Hold Duration"
            itemView.valueLabel.text = "\(value)"
            itemView.unitLabel.text = "Sec."
            itemView.separator.isHidden = results.count == 0
            results.append(itemView)
        }
        if let value = session.ignoreRepeat, value != 0 {
            let itemView = ItemView()
            itemView.titleLabel.text = "Ignore Repeat"
            itemView.valueLabel.text = "\(value)"
            itemView.unitLabel.text = "Sec."
            itemView.separator.isHidden = results.count == 0
            results.append(itemView)
        }
        if let value = session.touchAssistant {
            if case .initial(let sec) = value {
                let itemView = ItemView()
                itemView.titleLabel.text = "Touch Accomodation"
                itemView.valueLabel.text = "\(sec)"
                itemView.unitLabel.text = "Sec."
                itemView.extraLabel.text = "Use initial touch location"
                itemView.separator.isHidden = results.count == 0
                results.append(itemView)
            }
            if case .final(let sec) = value {
                let itemView = ItemView()
                itemView.titleLabel.text = "Touch Accomodation"
                itemView.valueLabel.text = "\(sec)"
                itemView.unitLabel.text = "Sec."
                itemView.extraLabel.text = "Use final touch location"
                itemView.separator.isHidden = results.count == 0
                results.append(itemView)
            }
        }
        
        return results
        
    }
    
    override func prepareForReuse() {
        session = nil
        itemViewStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        super.prepareForReuse()
    }
}

extension AccomodationCell {
    
    private class PromptView: UIView {
        
        let imageView = UIImageView()
        let titleLabel = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
//            imageView.backgroundColor = UIColor.gray
            imageView.image = UIImage(named: "image_analyzing_1")
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            titleLabel.textAlignment = .center
            
            addSubview(imageView)
            addSubview(titleLabel)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2.0),
                imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 100),
                imageView.heightAnchor.constraint(equalToConstant: 100),
                
                titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: imageView.bottomAnchor, multiplier: 2.0),
                titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
                
                titleLabel.bottomAnchor.constraint(equalToSystemSpacingAbove: bottomAnchor, multiplier: 2.0)
            ])
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
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
}
