//
//  CarService.swift
//  auto
//
//  Created by Džindra on 08.04.16.
//  Copyright © 2016 Dzindra. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

class CarService {
    static let motorMin = 0
    static let motorMax = 2046
    static let motorStop = 1023
    
    static let SSID = "Auto!"
    static let instance = CarService(host: "192.168.4.1", port: 6666)
    
    let port: UInt16
    let host: String
    let socket: GCDAsyncUdpSocket
    var timer: NSTimer?
    
    var motor1: Int = 1023 {
        didSet {
            if motor1 > CarService.motorMax { motor1 = CarService.motorMax }
            if motor1 < CarService.motorMin { motor1 = CarService.motorMin }
        }
    }
    var motor2: Int = 1023 {
        didSet {
            if motor2 > CarService.motorMax { motor2 = CarService.motorMax }
            if motor2 < CarService.motorMin { motor2 = CarService.motorMin }
        }
    }
    var lights: Bool = false
    
    init(host: String, port: UInt16) {
        self.host = host
        self.port = port
        self.socket = GCDAsyncUdpSocket()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(CarService.sendData), userInfo: nil, repeats: true)
    }
    
    @objc func sendData() {
        let data = String(format:"A%03X%03X%@", motor1, motor2, lights ? "1":"0")
        //print ("Sending \(data)")
        socket.sendData(data.dataUsingEncoding(NSUTF8StringEncoding), toHost: host, port: port, withTimeout: 1, tag: 0)
    }
    
    func setSpeed(motor1: Int, _ motor2: Int) {
        self.motor1 = motor1
        self.motor2 = motor2
    }
    
    func setSpeed(motor1: Int, _ motor2: Int, _ lights: Bool) {
        self.motor1 = motor1
        self.motor2 = motor2
        self.lights = lights
    }
    
    func setZeroSpeed() {
        setSpeed(CarService.motorStop, CarService.motorStop, false)
    }
    
    func currentSSID() -> String? {
        guard let ifc = CNCopySupportedInterfaces() as [AnyObject]?  else { return nil }
        for intf in ifc {
            if let intfs = intf as? String, ni = CNCopyCurrentNetworkInfo(intfs) as Dictionary?, ssid = ni[kCNNetworkInfoKeySSID] as? String {
                return ssid
            }
        }
        return nil
    }
    
    func isReady() -> Bool {
        return currentSSID() == CarService.SSID
    }

}
