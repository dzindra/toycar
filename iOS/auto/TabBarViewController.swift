//
//  TabBarViewController.swift
//  auto
//
//  Created by Džindra on 08.04.16.
//  Copyright © 2016 Dzindra. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    var shouldShowWarning: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldShowWarning {
            if !CarService.instance.isReady() {
                performSegueWithIdentifier("warning", sender: self)
            }
        } else {
            shouldShowWarning = true
        }
        
        
    }
    
    @IBAction func unwindToTabbar(segue:UIStoryboardSegue) {
        shouldShowWarning = false
    }
}
