//
//  TaskCollectionDataSource.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/22.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit

final class TaskCollectionDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let tapTask              = Task<TapTrial>()
    let swipeTask            = Task<SwipeTrial>()
    let dragAndDropTask      = Task<DragAndDropTrial>()
    let horizontalScrollTask = ScrollTask(horizontal: true)
    let verticalScrollTask   = ScrollTask(horizontal: false)
    let pinchTask            = Task<PinchTrial>()
    let rotationTask         = Task<RotationTrial>()
    let longPressTask        = Task<LongPressTrial>()
    
    weak var viewController: TaskCollectionViewController?
    
    convenience init(viewController: TaskCollectionViewController) {
        self.init()
        self.viewController = viewController
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TaskCollectionViewCell
        
        let configuration: [() -> Void] = [
            {
                cell.taskTitleLabel.text = "點擊"
                cell.subtitleLabel.text  = "點擊螢幕上的十字"
                cell.isCompleted         = !self.tapTask.trials.isEmpty
            },
            {
                cell.taskTitleLabel.text = "長按"
                cell.subtitleLabel.text  = "長按目標方塊"
                cell.isCompleted         = !self.longPressTask.trials.isEmpty
            },
            {
                cell.taskTitleLabel.text = "掃動"
                cell.subtitleLabel.text  = "順著指定方向掃動"
                cell.isCompleted         = !self.swipeTask.trials.isEmpty
            },
            {
                cell.taskTitleLabel.text = "水平滾動"
                cell.subtitleLabel.text  = "將矩形滾動至目標區域"
                cell.isCompleted         = !self.horizontalScrollTask.trials.isEmpty
            },
            {
                cell.taskTitleLabel.text = "垂直滾動"
                cell.subtitleLabel.text  = "將矩形滾動至目標區域"
                cell.isCompleted         = !self.verticalScrollTask.trials.isEmpty
            },
            {
                cell.taskTitleLabel.text = "雙指縮放"
                cell.subtitleLabel.text  = "將矩形放大或縮小至目標大小"
                cell.isCompleted         = !self.pinchTask.trials.isEmpty
            },
            {
                cell.taskTitleLabel.text = "雙指旋轉"
                cell.subtitleLabel.text  = "將指北針旋轉至正北"
                cell.isCompleted         = !self.rotationTask.trials.isEmpty
            }
        ]
        
        let op = configuration[indexPath.item]
        op()
        
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var taskViewController: UIViewController?
        
        let configuration: [() -> Void] = [
            {
                let vc = TapTaskInstructionViewController()
                vc.task = self.tapTask
                taskViewController = vc
            },
            {
                let vc = LongPressTaskInstructionViewController()
                vc.task = self.longPressTask
                taskViewController = vc
            },
            {
                let vc = SwipeTaskInstructionViewController()
                vc.task = self.swipeTask
                taskViewController = vc
            },
            {
                let vc = ScrollTaskInstructionViewController()
                vc.axis = .horizontal
                vc.task = self.horizontalScrollTask
                taskViewController = vc
            },
            {
                let vc = ScrollTaskInstructionViewController()
                vc.axis = .vertical
                vc.task = self.verticalScrollTask
                taskViewController = vc
            },
            {
                let vc = PinchTaskInstructionViewController()
                vc.task = self.pinchTask
                taskViewController = vc
            },
            {
                let vc = RotationTaskInstructionViewController()
                vc.task = self.rotationTask
                taskViewController = vc
            }
        ]
        
        let op = configuration[indexPath.row]
        op()
        
        if let taskViewController = taskViewController, let viewController = viewController {
            let navController = UINavigationController(rootViewController: taskViewController)
            navController.modalTransitionStyle = .flipHorizontal
            
            viewController.present(navController, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        switch indexPath.item {
        case 0: return tapTask.trials.isEmpty
        case 1: return longPressTask.trials.isEmpty
        case 2: return swipeTask.trials.isEmpty
        case 3: return horizontalScrollTask.trials.isEmpty
        case 4: return verticalScrollTask.trials.isEmpty
        case 5: return pinchTask.trials.isEmpty
        case 6: return rotationTask.trials.isEmpty
        default:
            return true
        }
    }
}

