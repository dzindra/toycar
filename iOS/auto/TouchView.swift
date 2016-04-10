//
//  TouchView.swift
//  auto
//
//  Created by Džindra on 08.04.16.
//  Copyright © 2016 Dzindra. All rights reserved.
//

import UIKit

class TouchView: UIView {
    var circle: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    var touchBlock: ((CGPoint, CGPoint, Bool)->Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = circle ? bounds.width/2.0 : 0
    }
    
    func handleTouch(touch: UITouch, _ active: Bool) {
        let loc = touch.locationInView(self)
        let w = self.bounds.width/2
        let h = self.bounds.height/2
        let x = w - loc.x
        let y = h - loc.y
        touchBlock?(CGPoint(x: max(-1,min(1,x/w)), y: max(-1,min(1,y/h))), loc, active)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if let touch = touches.first {
            handleTouch(touch, true)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        if let touch = touches.first {
            handleTouch(touch, true)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if let touch = touches.first {
            handleTouch(touch, false)
        }
    }

}
