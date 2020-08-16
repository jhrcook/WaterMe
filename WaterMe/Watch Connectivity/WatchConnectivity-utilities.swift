//
//  WatchConnectivityUtilities.swift
//  WaterMe
//
//  Created by Joshua on 8/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation
import WatchConnectivity


fileprivate func messageReplyType(_ replyMessage: [String : Any]) -> WCMessageResponse.WCResponseType? {
    if let response = replyMessage[WCMessageResponse.response.rawValue] as? String {
        if let responseType = WCMessageResponse.WCResponseType(rawValue: response) {
            return responseType
        }
    }
    return nil
}


extension WCSession {
    
    #if os(iOS)
    func checkConnectivityWithWatch(_ session: WCSession) -> Bool {
        return WCSession.isSupported() && session.isPaired && session.isWatchAppInstalled
    }
    #endif
    
    
    func sendMessageOrTransfer(info: [String : Any]) {
        #if os(iOS)
        if !checkConnectivityWithWatch(self) {
            print("No device paired with phone - returning early")
            return
        }
        #endif
        
        if self.activationState == .activated {
            print("Attempting to send message.")
            
            self.sendMessage(info, replyHandler: { replyMessage in
                if let response = messageReplyType(replyMessage) {
                    switch response {
                    case .success:
                        print("Message successfully recieved.")
                    default:
                        print("Message failed, attempting transfer.")
                        self.transferUserInfo(info)
                    }
                }
            }, errorHandler: { errorHandler in
                print("Error on sending message: \(errorHandler.localizedDescription)")
                print("Attempting transfer.")
                self.transferUserInfo(info)
            })
        }
    }
}
