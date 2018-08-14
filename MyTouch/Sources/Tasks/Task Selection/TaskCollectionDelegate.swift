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
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TaskCollectionViewCell
        
        switch indexPath.item {
        case 0:
            cell.taskTitleLabel.text = "點擊"
            cell.subtitleLabel.text  = "點擊螢幕上的十字"
            cell.isCompleted         = !tapTask.trials.isEmpty
            
        case 1:
            cell.taskTitleLabel.text = "掃動"
            cell.subtitleLabel.text  = "順著指定方向掃動"
            cell.isCompleted         = !swipeTask.trials.isEmpty
            
        case 2:
            cell.taskTitleLabel.text = "拖曳"
            cell.subtitleLabel.text  = "將矩形拖曳至目標區域"
            cell.isCompleted         = !dragAndDropTask.trials.isEmpty
            
        case 3:
            cell.taskTitleLabel.text = "水平滾動"
            cell.subtitleLabel.text  = "將矩形滾動至目標區域"
            cell.isCompleted         = !horizontalScrollTask.trials.isEmpty
            
        case 4:
            cell.taskTitleLabel.text = "垂直滾動"
            cell.subtitleLabel.text  = "將矩形滾動至目標區域"
            cell.isCompleted         = !verticalScrollTask.trials.isEmpty
            
        case 5:
            cell.taskTitleLabel.text = "雙指縮放"
            cell.subtitleLabel.text  = "將矩形放大或縮小至目標大小"
            cell.isCompleted         = !pinchTask.trials.isEmpty
            
        case 6:
            cell.taskTitleLabel.text = "雙指旋轉"
            cell.subtitleLabel.text  = "將指北針旋轉至正北"
            cell.isCompleted         = !rotationTask.trials.isEmpty
            
        case 7:
            cell.taskTitleLabel.text = "長按"
            cell.subtitleLabel.text  = "長按目標方塊"
            cell.isCompleted         = !longPressTask.trials.isEmpty
            
        default:
            break
        }
        
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var taskViewController: UIViewController?
        
        switch indexPath.item {
        case 0:
            let vc = TapTaskInstructionViewController()
            vc.task = tapTask
            taskViewController = vc
            
        case 1:
            let vc = SwipeTaskInstructionViewController()
            vc.task = swipeTask
            taskViewController = vc
            
        case 2:
            let vc = DragAndDropTaskInstructionViewController()
            vc.task = dragAndDropTask
            taskViewController = vc
            
        case 3:
            let vc = ScrollTaskInstructionViewController()
            vc.axis = .horizontal
            vc.task = horizontalScrollTask
            taskViewController = vc
            
        case 4:
            let vc = ScrollTaskInstructionViewController()
            vc.axis = .vertical
            vc.task = verticalScrollTask
            taskViewController = vc
            
        case 5:
            let vc = PinchTaskInstructionViewController()
            vc.task = pinchTask
            taskViewController = vc
            
        case 6:
            let vc = RotationTaskInstructionViewController()
            vc.task = rotationTask
            taskViewController = vc
            
        case 7:
            let vc = LongPressTaskInstructionViewController()
            vc.task = longPressTask
            taskViewController = vc
            
        default:
            break
        }
        
        if let taskViewController = taskViewController, let viewController = viewController {
            let navController = UINavigationController(rootViewController: taskViewController)
            navController.modalTransitionStyle = .flipHorizontal
            
            viewController.present(navController, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        switch indexPath.item {
        case 0: return tapTask.trials.isEmpty
        case 1: return swipeTask.trials.isEmpty
        case 2: return dragAndDropTask.trials.isEmpty
        case 3: return horizontalScrollTask.trials.isEmpty
        case 4: return verticalScrollTask.trials.isEmpty
        case 5: return pinchTask.trials.isEmpty
        case 6: return rotationTask.trials.isEmpty
        case 7: return longPressTask.trials.isEmpty
        default:
            return true
        }
    }
}

