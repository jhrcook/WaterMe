//
//  PhoneAndWatchCommunicator.swift
//  WaterMe
//
//  Created by Joshua on 8/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import UIKit
import WatchConnectivity

class PhoneAndWatchCommunicator: NSObject, WCSessionDelegate {

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



// iOS Specific Methods

#if os(iOS)
extension PhoneAndWatchCommunicator {
    /// Is the Watch supported, paired, and app installed?
    /// - Returns: Boolean value to answer this question.
    func checkConnectivityWithWatch() -> Bool {
        return WCSession.isSupported() && session.isPaired && session.isWatchAppInstalled
    }
}
#endif


#if os(iOS)
extension PhoneAndWatchCommunicator {
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
#endif
