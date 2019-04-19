//
//  SettingsStepByStepViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/4/11.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class SettingsStepByStepViewController: UIViewController {

    let titleLabel = UILabel()
    
    let scrollView = UIScrollView()
    let scrollContentView = UIView()
    
    let button = UIButton()
    let bottomView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        titleLabel.text = "如何設定觸控調節"
        titleLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        
        scrollView.alwaysBounceVertical = true
        
        bottomView.backgroundColor = UIColor.white
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .medium)
        button.setTitle("立即前往設定", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage.primaryButtonBackgroundImage(color: UIColor(hex: 0x00b894)), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 18, bottom: 8, right: 18)
        button.addTarget(self, action: #selector(handleButton(sender:)), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        view.addSubview(bottomView)
        view.addSubview(button)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        bottomView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        scrollView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        bottomView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        scrollView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 80),
            
            button.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
        ])
        
        // layout scrollview contents
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
        
        let stepView1 = StepView()
        stepView1.textLabel.text = "1. 前往「設定」app，點擊「一般」。"
        stepView1.imageView.image = UIImage(named: "image_settings_general_en")
        
        let stepView2 = StepView()
        stepView2.textLabel.text = "2. 點擊「輔助使用」選項。"
        stepView2.imageView.image = UIImage(named: "image_settings_accessibility_en")
        
        let stepView3 = StepView()
        stepView3.textLabel.text = "3. 點擊「觸控調節」選項。"
        stepView3.imageView.image = UIImage(named: "image_settings_accommodations_en")
        
        let stepView4 = StepView()
        stepView4.textLabel.text = "4. 根據測驗結果調整各項設定值。"
        stepView4.imageView.image = UIImage(named: "image_settings_configs_en")
        
        
        let stackView = UIStackView(arrangedSubviews: [stepView1, stepView2, stepView3, stepView4])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        
        scrollContentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -20)
        ])
        
    }
    
    @objc private func handleButton(sender: UIButton) {
        UIApplication.shared.open(URL(string: "App-Prefs:root=General&path=ACCESSIBILITY")!, options: [:]) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension SettingsStepByStepViewController {
    
    private class StepView: UIView {
        
        let textLabel = UILabel()
        let imageView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            textLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            imageView.contentMode = .scaleAspectFit
            
            addSubview(textLabel)
            addSubview(imageView)
            
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                textLabel.topAnchor.constraint(equalTo: topAnchor),
                textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                
                imageView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 8),
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
//                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/3),
            ])
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
