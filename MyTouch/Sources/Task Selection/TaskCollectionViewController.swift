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
        collectionView.dataSource = collectionViewDelegate
        collectionView.delegate   = collectionViewDelegate
        collectionView.backgroundColor      = .clear
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    lazy var collectionViewDelegate: TaskCollectionDelegate = {
        return TaskCollectionDelegate(viewController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Tasks"

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancelButton(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleActionButton(_:)))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        
        navigationItem.rightBarButtonItem?.isEnabled = SessionManager.shared.isCompleted
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
        
        let alertController = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Leave", style: .destructive) { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Stay", style: .default, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        alertController.preferredAction = cancelAction
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func handleActionButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
