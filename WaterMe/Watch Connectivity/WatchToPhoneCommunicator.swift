//
//  WatchToPhoneCommunicator.swift
//  WaterMeWatchApp Extension
//
//  Created by Joshua on 8/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import UIKit
import WatchConnectivity

class WatchToPhoneCommunicator: NSObject, WCSessionDelegate {

    private let session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Error during Watch Connectivity activation: \(error.localizedDescription)")
        } else {
            print("Watch Connectivity session activated without error.")
        }
    }
}


// Sending Data

extension WatchToPhoneCommunicator {
    func sendWateringUpdate(_ plant: PlantWatch) {

    }

    func requestAllApplicationData() {

    }
}


// Receiving Data

extension WatchToPhoneCommunicator {
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        <#code#>
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        <#code#>
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        <#code#>
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        <#code#>
    }
}
