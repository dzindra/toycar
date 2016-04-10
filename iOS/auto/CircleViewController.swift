//
//  CircleViewController.swift
//  auto
//
//  Created by Džindra on 08.04.16.
//  Copyright © 2016 Dzindra. All rights reserved.
//

import UIKit

class CircleViewController: UIViewController, Updatable {
    @IBOutlet weak var circleView: TouchView!
    @IBOutlet weak var lightSwitch: UISwitch!
    @IBOutlet weak var indicatorLeft: NSLayoutConstraint!
    @IBOutlet weak var indicatorTop: NSLayoutConstraint!
    @IBOutlet weak var indicator: TouchView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        circleView.circle = true
        circleView.touchBlock = { [weak self] loc, orig, active in
            self?.indicator.hidden = !active
            if active {
                self?.touched(loc, orig: orig)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    func update() {
        lightSwitch.on = CarService.instance.lights
    }
    
    func getM1(a: Double) -> Double {
        switch a {
        case 0.0..<90.0:
            return 1
        case 90.0..<270.0:
            return 1.0-(a-90.0)/90.0
        case 270..<360:
            return (a-270.0)/45.0-1.0
        default:
            return -1
        }
    }
    
    func getM2(a: Double) -> Double {
        switch a {
        case 0..<90:
            return a/90.0
        case 180..<270:
            return 1-(a-180)/45
        case 270..<360:
            return (a-270)/90-1
        default:
            return 1
        }
    }
   
    func touched(loc: CGPoint, orig: CGPoint) {
        indicatorTop.constant = orig.y-10
        indicatorLeft.constant = orig.x-10
        
        var a = Double(atan2(loc.y, -loc.x))
        if a<0 {
            a+=M_PI*2
        }
        
        a *= 180/M_PI
        
        var dist = Double(hypot(loc.x,loc.y))
        if dist<0.2 {
            dist = 0
        }
        CarService.instance.setSpeed(CarService.motorStop+Int(getM1(a)*dist*Double(CarService.motorStop)), CarService.motorStop+Int(getM2(a)*dist*Double(CarService.motorStop)))
        //print("\(CarService.instance.motor1-1023) \(CarService.instance.motor2-1023)")
    }

    @IBAction func lightsChanged(sender: UISwitch) {
        CarService.instance.lights = sender.on
    }
}
