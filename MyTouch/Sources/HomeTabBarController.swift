//
//  HomeTabBarController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/16.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return [.landscapeLeft, .landscapeRight]
        default:
            return [.portrait]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor(hex: 0x00b894)
        tabBar.unselectedItemTintColor = UIColor(hex: 0xb2bec3)
    }
}
