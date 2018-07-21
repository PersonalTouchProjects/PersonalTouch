//
//  HomeViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let descriptionLabel = UILabel()
    let startExamButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Exam", comment: "")
        
        view.backgroundColor = .white
        
        descriptionLabel.text = NSLocalizedString("Exam Description", comment: "")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textAlignment = .center
        
        startExamButton.setTitle(NSLocalizedString("Start Exam", comment: ""), for: .normal)
        startExamButton.setTitleColor(.white, for: .normal)
        startExamButton.setBackgroundImage(UIImage.primaryButtonBackgroundImage(color: view.tintColor), for: .normal)
        startExamButton.addTarget(self, action: #selector(handleButton(_:)), for: .touchUpInside)
        
        view.addSubview(descriptionLabel)
        view.addSubview(startExamButton)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        startExamButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: view.readableContentGuide.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: view.readableContentGuide.rightAnchor),
            
            startExamButton.widthAnchor.constraint(equalToConstant: 343),
            startExamButton.heightAnchor.constraint(equalToConstant: 50),
            startExamButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startExamButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
    
    @objc func handleButton(_ sender: UIButton) {
        
        func presentTaskViewController(_ vc: TaskViewController) {
            
            vc.taskResultManager = TaskResultManager(session: Session())
            
            let navController = UINavigationController(rootViewController: vc)
//            navController.setNavigationBarHidden(true, animated: false)
            navController.modalTransitionStyle = .flipHorizontal
            
            self.present(navController, animated: true, completion: nil)
        }
        
        // present alert controller
        let alert = UIAlertController(title: "測驗", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "點擊", style: .default) { _ in
            presentTaskViewController(TapTaskInstructionViewController())
        })
        alert.addAction(UIAlertAction(title: "掃動", style: .default) { _ in
            presentTaskViewController(SwipeTaskInstructionViewController())
        })
        alert.addAction(UIAlertAction(title: "拖拉放", style: .default) { _ in
            presentTaskViewController(DragAndDropTaskInstructionViewController())
        })
        alert.addAction(UIAlertAction(title: "滾動", style: .default) { _ in
            presentTaskViewController(ScrollTaskInstructionViewController())
        })
        alert.addAction(UIAlertAction(title: "縮放", style: .default) { _ in
            presentTaskViewController(PinchTaskInstructionViewController())
        })
        alert.addAction(UIAlertAction(title: "旋轉", style: .default) { _ in
            presentTaskViewController(RotationTaskInstructionViewController())
        })
        alert.addAction(UIAlertAction(title: "測試", style: .default) { _ in
            presentTaskViewController(TaskInstructionViewController())
        })
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = sender.frame
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
