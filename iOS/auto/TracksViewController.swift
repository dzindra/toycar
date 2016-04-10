//
//  TracksViewController.swift
//  auto
//
//  Created by Džindra on 02.04.16.
//  Copyright © 2016 Dzindra. All rights reserved.
//

import UIKit

class TracksViewController: UIViewController, Updatable {
    @IBOutlet weak var m1Slider: TouchView!
    @IBOutlet weak var m2Slider: TouchView!
    @IBOutlet weak var auxSwitch: UISwitch!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var m1indicator: UIView!
    @IBOutlet weak var m1indicatorBottom: NSLayoutConstraint!
    @IBOutlet weak var m2indicator: UIView!
    @IBOutlet weak var m2indicatorBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        m1Slider.circle = false
        m2Slider.circle = false
        
        m1Slider.touchBlock = { [weak self] loc, orig, active in
            guard let aself = self else {return}
            aself.m1indicator.hidden = !active
            if active {
                aself.handleTouch(loc,orig,active,aself.m1Slider)
            }
        }
        m2Slider.touchBlock = { [weak self] loc, orig, active in
            guard let aself = self else {return}
            aself.m2indicator.hidden = !active
            if active {
                aself.handleTouch(loc,orig,active,aself.m2Slider)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    func handleTouch(loc:CGPoint, _ orig:CGPoint, _ active: Bool, _ view:TouchView) {
        var v = CarService.motorStop
        if abs(loc.y)>0.2 {
            v+=Int(loc.y*CGFloat(CarService.motorStop))
        }
        //print("\(v) \(loc)" )
        if view == m1Slider {
            CarService.instance.motor1 = v
            m1indicatorBottom.constant = orig.y-10
        } else {
            CarService.instance.motor2 = v
            m2indicatorBottom.constant = orig.y-10
        }
    }
    
    
    @IBAction func sliderChanged(sender: AnyObject) {
        CarService.instance.lights = auxSwitch.on
    }
    
    func update() {
        auxSwitch.on = CarService.instance.lights
    }
    
}

