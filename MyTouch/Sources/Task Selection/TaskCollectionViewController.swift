//
//  TaskCollectionViewController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/21.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

class TaskCollectionViewController: TaskViewController {

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
    
    private var taskViewControllers = [(title: String, subtitle: String, vc: () -> TaskViewController)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Tasks"
        
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissTask))
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let numberOfColumns = 4
        let gutter: CGFloat = 8
        let inset = UIEdgeInsets(top: gutter*2, left: gutter, bottom: gutter*2, right: gutter)
        
        let width = max((collectionView.bounds.width - inset.left - inset.right) / CGFloat(numberOfColumns) - gutter, 0)
        let height = width * 1/3
        
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.minimumLineSpacing = gutter
        flowLayout.minimumInteritemSpacing = gutter
        flowLayout.sectionInset = inset
    }
    
    @objc private func handleCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension TaskCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TaskCollectionViewCell
        
        let data = taskViewControllers[indexPath.item]
        cell.taskTitleLabel.text = data.title
        cell.subtitleLabel.text = data.subtitle
        
        if let session = taskResultManager?.session {
            switch indexPath.item {
            case 0: cell.isCompleted = session.tapTask         != nil //cell.indicatorColor = session.tapTask         == nil ? .red : .green
            case 1: cell.isCompleted = session.swipeTask       != nil
            case 2: cell.isCompleted = session.dragAndDropTask != nil
            case 3: cell.isCompleted = session.scrollTask      != nil
            case 4: cell.isCompleted = session.pinchTask       != nil
            case 5: cell.isCompleted = session.rotationTask    != nil
            default: cell.isCompleted = false
            }
        }
        
        return cell
    }
}

extension TaskCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let viewController = taskViewControllers[indexPath.item].vc()
        viewController.taskResultManager = taskResultManager
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalTransitionStyle = .flipHorizontal
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        if let session = taskResultManager?.session {
            switch indexPath.item {
            case 0: return session.tapTask         == nil
            case 1: return session.swipeTask       == nil
            case 2: return session.dragAndDropTask == nil
            case 3: return session.scrollTask      == nil
            case 4: return session.pinchTask       == nil
            case 5: return session.rotationTask    == nil
            default: return true
            }
        }
        return true
    }
}

private func _taskViewControllers() -> [(String, String, () -> TaskViewController)] {
    
    let array: [(String, String, () -> TaskViewController)] = [
        ("Tap", "Tap on the target", { TapTaskInstructionViewController() }),
        ("Swipe", "Swipe on target direction", { SwipeTaskInstructionViewController() }),
        ("Darg And Drop", "Drag the rectangle and drop it into target area", { DragAndDropTaskInstructionViewController() }),
        ("Scroll", "Scroll to target offset", { ScrollTaskInstructionViewController() }),
        ("Pinch", "Zoom in or zoom out", { PinchTaskInstructionViewController() }),
        ("Rotation", "Turn the compass to the north", { RotationTaskInstructionViewController() })
    ]
    
    return array
}

