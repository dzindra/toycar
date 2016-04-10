//
//  AppDelegate.swift
//  auto
//
//  Created by Džindra on 02.04.16.
//  Copyright © 2016 Dzindra. All rights reserved.
//

import UIKit

protocol Updatable {
    func update()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        CarService.instance.setZeroSpeed()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        CarService.instance.setZeroSpeed()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        update()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        update()
    }

    func update() {
        if let tabBar = self.window?.rootViewController as? TabBarViewController {
            tabBar.viewControllers?.forEach { vc in
                if let updatable = vc as? Updatable where vc.isViewLoaded() {
                    updatable.update()
                }
            }
        }
    }

}

