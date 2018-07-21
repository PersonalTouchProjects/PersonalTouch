//
//  TaskCollectionViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/21.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TaskCollectionViewController: UIViewController {

    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private var taskViewControllers = [(String, () -> TaskViewController)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Tasks"
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isTranslucent = false
        
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        taskViewControllers = _taskViewControllers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let numberOfColumns = 4
        let gutter: CGFloat = 8
        let inset = UIEdgeInsets(top: gutter*2, left: gutter, bottom: gutter*2, right: gutter)
        
        let width = max((collectionView.bounds.width - inset.left - inset.right) / CGFloat(numberOfColumns) - gutter, 0)
        let height = width * 2/3
        
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.minimumLineSpacing = gutter
        flowLayout.minimumInteritemSpacing = gutter
        flowLayout.sectionInset = inset
    }
}

extension TaskCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TaskCollectionViewCell
        
        let taskViewControllerData = taskViewControllers[indexPath.item]
        cell.taskTitleLabel.text = taskViewControllerData.0
        
        return cell
    }
}

extension TaskCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let taskViewControllerData = taskViewControllers[indexPath.item]
        let viewController = taskViewControllerData.1()
        
        viewController.taskResultManager = TaskResultManager(session: Session())
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalTransitionStyle = .flipHorizontal
        
        self.present(navController, animated: true, completion: nil)
    }
}

private func _taskViewControllers() -> [(String, () -> TaskViewController)] {
    
    let array: [(String, () -> TaskViewController)] = [
        ("Tap", { TapTaskInstructionViewController() }),
        ("Swipe", { SwipeTaskInstructionViewController() }),
        ("Darg And Drop", { DragAndDropTaskInstructionViewController() }),
        ("Scroll", { ScrollTaskInstructionViewController() }),
        ("Pinch", { PinchTaskInstructionViewController() }),
        ("Rotation", { RotationTaskInstructionViewController() })
    ]
    
    return array
}
