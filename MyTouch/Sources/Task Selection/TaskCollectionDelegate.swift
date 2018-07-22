//
//  TaskCollectionDataSource.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/22.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

final class TaskCollectionDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let tapTask         = Task<TapTrial>()
    let swipeTask       = Task<SwipeTrial>()
    let dragAndDropTask = Task<DragAndDropTrial>()
    let scrollTask      = Task<ScrollTrial>()
    let pinchTask       = Task<PinchTrial>()
    let rotationTask    = Task<RotationTrial>()
    
    weak var viewController: TaskCollectionViewController?
    
    convenience init(viewController: TaskCollectionViewController) {
        self.init()
        self.viewController = viewController
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TaskCollectionViewCell
        
        switch indexPath.item {
        case 0:
            cell.taskTitleLabel.text = "Tap"
            cell.subtitleLabel.text  = "Tap on the target"
            cell.isCompleted         = !tapTask.trials.isEmpty
            
        case 1:
            cell.taskTitleLabel.text = "Swipe"
            cell.subtitleLabel.text  = "Swipe on target direction"
            cell.isCompleted         = !swipeTask.trials.isEmpty
            
        case 2:
            cell.taskTitleLabel.text = "Darg And Drop"
            cell.subtitleLabel.text  = "Drag the rectangle and drop it into target area"
            cell.isCompleted         = !dragAndDropTask.trials.isEmpty
            
        case 3:
            cell.taskTitleLabel.text = "Scroll"
            cell.subtitleLabel.text  = "Scroll to target offset"
            cell.isCompleted         = !scrollTask.trials.isEmpty
            
        case 4:
            cell.taskTitleLabel.text = "Pinch"
            cell.subtitleLabel.text  = "Zoom in or zoom out"
            cell.isCompleted         = !pinchTask.trials.isEmpty
            
        case 5:
            cell.taskTitleLabel.text = "Rotation"
            cell.subtitleLabel.text  = "Turn the compass to the north"
            cell.isCompleted         = !rotationTask.trials.isEmpty
            
        default:
            break
        }
        
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var taskViewController: TaskViewController?
        
        switch indexPath.item {
        case 0: taskViewController = TapTaskInstructionViewController()
        case 1: taskViewController = SwipeTaskInstructionViewController()
        case 2: taskViewController = DragAndDropTaskInstructionViewController()
        case 3: taskViewController = ScrollTaskInstructionViewController()
        case 4: taskViewController = PinchTaskInstructionViewController()
        case 5: taskViewController = RotationTaskInstructionViewController()
            
        default:
            break
        }
        
        if let taskViewController = taskViewController, let viewController = viewController {
            let navController = UINavigationController(rootViewController: taskViewController)
            navController.modalTransitionStyle = .flipHorizontal
            
            viewController.present(navController, animated: true, completion: nil)
        }
    }
}

