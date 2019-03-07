//
//  SubjectSummaryViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/3/7.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class SubjectSummaryViewController: UIViewController {

    let subject: Subject
    let callback: (UIViewController, Bool) -> Void
    
    init(subject: Subject, callback: @escaping (UIViewController, Bool) -> Void) {
        self.subject = subject
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel = UILabel()
    let textLabel = UILabel()
    let tableView = UITableView()
    
    let confirmButton = UIButton()
    let cancelButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        titleLabel.text = "受測者資料"
        titleLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        
        textLabel.text = "道燈投，劇說為友全子一對工：業二也光是水影正學一口，的的說學性員多，新有起往我人然傷曾作能學片件幾解，經數去小著市有智子易別好在，快說感。"
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.numberOfLines = 0
        
        tableView.register(ItemCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .medium)
        confirmButton.setTitle("使用這筆資料", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.setBackgroundImage(UIImage.primaryButtonBackgroundImage(color: UIColor(hex: 0x00b894)), for: .normal)
        confirmButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 18, bottom: 8, right: 18)
        confirmButton.addTarget(self, action: #selector(handleConfirmButton), for: .touchUpInside)
        
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .regular)
        cancelButton.setTitle("全部重填", for: .normal)
        cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(textLabel)
        view.addSubview(tableView)
        view.addSubview(confirmButton)
        view.addSubview(cancelButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2.0),
            titleLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            
            textLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 2.0),
            textLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: textLabel.bottomAnchor, multiplier: 2.0),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            confirmButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 15),
            confirmButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            confirmButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 280),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 0),
            cancelButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            cancelButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 280),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
    }
    
    @objc private func handleConfirmButton() {
        callback(self, true)
    }
    
    @objc private func handleCancelButton() {
        callback(self, false)
    }
}

extension SubjectSummaryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "姓名"
            cell.valueLabel.text = subject.name
            
        case 1:
            cell.titleLabel.text = "出生年"
            cell.valueLabel.text = "\(subject.birthYear)"
            
        case 2:
            cell.titleLabel.text = "性別"
            cell.valueLabel.text = subject.gender.rawValue.localizedUppercase
            
        case 3:
            cell.titleLabel.text = "慣用手"
            cell.valueLabel.text = subject.dominantHand.rawValue.localizedUppercase
            
        case 4:
            cell.titleLabel.text = "診斷"
            cell.valueLabel.text = subject.impairment.rawValue.localizedUppercase
            
        case 5:
            cell.titleLabel.text = "症狀"
            var texts = [String]()
            if subject.slowMovement {
                texts.append("行動遲緩")
            }
            if subject.rapidFatigue {
                texts.append("易於疲勞")
            }
            if subject.poorCoordination {
                texts.append("缺乏協調性")
            }
            if subject.lowStrength {
                texts.append("低張")
            }
            if subject.difficultyGripping {
                texts.append("執行抓取動作有困難")
            }
            if subject.difficultyHolding {
                texts.append("執行抓握動作有困難")
            }
            if subject.tremor {
                texts.append("顫抖")
            }
            if subject.spasm {
                texts.append("痙攣、抽搐")
            }
            if subject.lackOfSensation {
                texts.append("知覺失調")
            }
            if subject.difficultyControllingDirection {
                texts.append("difficulty controlling direction")
            }
            if subject.difficultyControllingDistance {
                texts.append("difficulty controlling distance")
            }
            
            cell.valueLabel.text = texts.joined(separator: "\n")
            
        default:
            break
        }
        
        return cell
    }
}

extension SubjectSummaryViewController {
    
    private class ItemCell: UITableViewCell {
        
        let titleLabel = UILabel()
        let valueLabel = UILabel()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            
            valueLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            valueLabel.textColor = UIColor(white: 0.3, alpha: 1.0)
            valueLabel.textAlignment = .right
            valueLabel.numberOfLines = 0
            
            addSubview(titleLabel)
            addSubview(valueLabel)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            valueLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1.0),
                titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: readableContentGuide.leadingAnchor, multiplier: 1.0),
                titleLabel.bottomAnchor.constraint(equalToSystemSpacingAbove: bottomAnchor, multiplier: 1.0),
                
                valueLabel.firstBaselineAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor),
                valueLabel.trailingAnchor.constraint(equalToSystemSpacingBefore: readableContentGuide.trailingAnchor, multiplier: 1.0),
                valueLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 1.0),
            ])
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func prepareForReuse() {
            titleLabel.text = nil
            valueLabel.text = nil
            super.prepareForReuse()
        }
    }
    
}
