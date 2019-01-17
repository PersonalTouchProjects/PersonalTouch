//
//  AccomodationCell.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/16.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class AccomodationCell: UITableViewCell {

    let gradientView = GradientView()
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    let unitLabel = UILabel()
    let extraLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        gradientView.clipsToBounds = true
        gradientView.layer.cornerRadius = 10.0
        
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        
        valueLabel.textColor = UIColor.white
        valueLabel.font = UIFont.systemFont(ofSize: 48, weight: .regular)
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.5
        
        unitLabel.textColor = UIColor.white
        unitLabel.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        
        extraLabel.textColor = UIColor.white
        extraLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        let valueStack = UIStackView(arrangedSubviews: [valueLabel, unitLabel])
        valueStack.axis = .horizontal
        valueStack.alignment = .firstBaseline
        valueStack.spacing = 4.0
        
        let stack = UIStackView(arrangedSubviews: [valueStack, extraLabel])
        stack.axis = .vertical
        stack.alignment = .trailing
        
        contentView.addSubview(gradientView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(stack)
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            gradientView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16),
            
            stack.centerYAnchor.constraint(equalTo: gradientView.centerYAnchor),
            stack.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -8)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        valueLabel.text = nil
        unitLabel.text = nil
        extraLabel.text = nil
    }
}

extension AccomodationCell {
    
    class GradientView: UIView {
        var fromColor = UIColor(red:0.00, green:0.67, blue:0.96, alpha:1.00) {
            didSet { setupGradient() }
        }
        var toColor = UIColor(red:0.00, green:0.62, blue:0.90, alpha:1.00) {
            didSet { setupGradient() }
        }
        
        let gradientLayer = CAGradientLayer()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.addSublayer(gradientLayer)
            setupGradient()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var frame: CGRect {
            didSet { setupGradient() }
        }
        
        override var bounds: CGRect {
            didSet { setupGradient() }
        }
        
        private func setupGradient() {
            
            gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.locations = [0, 1]
            gradientLayer.frame = bounds
        }
    }
    
}

