//
//  WarningViewController.swift
//  auto
//
//  Created by Džindra on 08.04.16.
//  Copyright © 2016 Dzindra. All rights reserved.
//

import UIKit

class WarningViewController: UIViewController {
    
    @IBAction func settingsTapped(sender: AnyObject) {
        if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
            if UIApplication.sharedApplication().openURL(appSettings) {
                self.performSegueWithIdentifier("close", sender: self)
            }
        }
    }

}
