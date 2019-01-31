//
//  HomeNavigationController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/1/16.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class HomeNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = UIColor(hex: 0x00b894)
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
