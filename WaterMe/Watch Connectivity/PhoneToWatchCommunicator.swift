//
//  PhoneAndWatchCommunicator.swift
//  WaterMe
//
//  Created by Joshua on 8/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import UIKit
import WatchConnectivity

class PhoneToWatchCommunicator: NSObject, WCSessionDelegate {

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

extension PhoneToWatchCommunicator {
    
    func addToWatch(_ plant: Plant) {
        
    }
    
    func deleteFromWatch(_ plant: Plant) {
        
    }
    
    func updateOnWatch(_ plant: Plant) {
        
    }
    
    func transferImageToWatch(_ plant: Plant) {
        
    }
    
    func sendAllDataToWatch(_ garden: Garden) {
        
    }
}


// Receiving Data

extension PhoneToWatchCommunicator {
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        <#code#>
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        <#code#>
    }
}


extension PhoneToWatchCommunicator {
    func sessionDidDeactivate(_ session: WCSession) {
        print("WC session deactivated.")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WC session deactivated")
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        print("WC session: Watch state did change.")
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("WC session: Watch reachability state did change.")
    }
}
