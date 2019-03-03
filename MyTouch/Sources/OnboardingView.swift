//
//  OnboardingView.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/3/3.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class OnboardingView: UIView {
    
    let containerView = UIView()
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let textLabel = UILabel()
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // Container view
        
        containerView.backgroundColor = .white
        containerView.clipsToBounds = false
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowOpacity = 0.15
        containerView.layer.shadowRadius = 2.0
        containerView.layer.cornerRadius = 10.0
        
        addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
        ])
        
    
        // Subviews
        
        imageView.image = UIImage(named: "compass")
        imageView.tintColor = UIColor.black
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.font = UIFont.systemFont(ofSize: 27)
        titleLabel.text = "歡迎使用 MyTouch"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        let textParagraphStyle = NSMutableParagraphStyle()
        textParagraphStyle.lineHeightMultiple = 1.25
        textParagraphStyle.lineBreakMode = .byWordWrapping
        
        let textAttrs: [NSAttributedString.Key: Any] = [
            .paragraphStyle: textParagraphStyle,
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        
        let text = "於入最中公同及親了。月事念樹裡生保年指在思少員王技制的不毛響選、長能方向極，票領研因真未看的務，被念到觀存司的如善現緊。布會地生留經之跑要題計長們並布能我時回賣不的？應據有西產，港我進生。笑帶等的大思環情頭業、提鄉父條不參然經工光樂香月活的到。"
        textLabel.attributedText = NSAttributedString(string: text, attributes: textAttrs)
        textLabel.numberOfLines = 0
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.5
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .medium)
        button.setTitle("開始測驗", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage.primaryButtonBackgroundImage(color: UIColor(hex: 0x00b894)), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 18, bottom: 8, right: 18)
        
        
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(textLabel)
        containerView.addSubview(button)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.leadingAnchor, multiplier: 1.0),
            titleLabel.trailingAnchor.constraint(equalToSystemSpacingBefore: containerView.trailingAnchor, multiplier: 1.0),
            
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            textLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            
            button.topAnchor.constraint(greaterThanOrEqualTo: textLabel.bottomAnchor),
            button.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 280)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
