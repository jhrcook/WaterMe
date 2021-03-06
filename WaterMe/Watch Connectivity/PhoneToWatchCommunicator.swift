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
    
    var gardenDelegate: GardenDelegate? = nil
    
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
        let dm = WCDataManager()
        let info = dm.packageMessageInfo(datatype: .addPlant,
                                         data: dm.convert(plantForWatch: plant))
        session.sendMessageOrTransfer(info: info)
    }
    
    
    func deleteFromWatch(_ plant: Plant) {
        let dm = WCDataManager()
        let info = dm.packageMessageInfo(datatype: .deletePlant,
                                         data: [plant.id])
        session.sendMessageOrTransfer(info: info)
    }
    
    
    func updateOnWatch(_ plant: Plant) {
        let dm = WCDataManager()
        let info = dm.packageMessageInfo(datatype: .updatePlant, data: dm.convert(plantForWatch: plant))
        session.sendMessageOrTransfer(info: info)
    }
    
    
    func transferImageToWatch(_ plant: Plant, andSendUpdatedPlant sendUpdatedPlant: Bool = true) {
        print("Transfering image from plant '\(plant.name)'.")
        guard let originalImageName = plant.imageName else { return }
        
        let originalImageURL = getDocumentsDirectory().appendingPathComponent(originalImageName)
        do {
            print("Copying and resizing image to send to watch.")
            let newImageURL = try copyResizeCompressJPEG(url: originalImageURL)
            session.transferFile(newImageURL, metadata: [PhoneToWatchDataType.imageFilename.rawValue : originalImageName])
            if sendUpdatedPlant { updateOnWatch(plant) }
        } catch {
            print("error in resizing image: \(error.localizedDescription)")
        }
    }
    
    
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        if let error = error {
            print("File transfer did finish with error: \(error.localizedDescription)")
        } else {
            print("File transfer did finish without error.")
        }
    }
    
    
    func sendAllDataToWatch(_ garden: Garden) {
        let dm = WCDataManager()
        let info = dm.packageMessageInfo(datatype: .allData, data: dm.convert(plantsForWatch: garden.plants))
        do {
            try session.updateApplicationContext(info)
            print("Sent application context.")
        } catch {
            print("Unable to update application context: \(error.localizedDescription)")
        }
    }
}


// Receiving Data

extension PhoneToWatchCommunicator {
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        do {
            try parseIncomingMessageOrTransfer(info: message)
            replyHandler([WCMessageResponse.response.rawValue : WCMessageResponse.WCResponseType.success.rawValue])
        } catch {
            print("Error in parsing recieved message: \(error.localizedDescription)")
            replyHandler([WCMessageResponse.response.rawValue : WCMessageResponse.WCResponseType.failure.rawValue])
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        do {
            try parseIncomingMessageOrTransfer(info: userInfo)
        } catch {
            print("Error in recieved transfer: \(error.localizedDescription)")
        }
    }
    
    private func parseIncomingMessageOrTransfer(info: [String : Any]) throws {
        if let dataTypeString = info[DataDictionaryKey.datatype.rawValue] as? String {
            if let dataType = WatchToPhoneDataType(rawValue: dataTypeString) {
                switch dataType {
                case .requestAllData:
                    sendAllDataToWatch(Garden())
                case .waterPlant:
                    waterPlant(id: info[DataDictionaryKey.data.rawValue] as? String ?? "")
                }
            } else {
                throw WatchConnectivityDataError.unknownDataType(dataTypeString)
            }
        } else {
            throw WatchConnectivityDataError.noDataTypeIndicated
        }
    }
    
    func waterPlant(id: String) {
        let garden = Garden()
        garden.water(plantId: id)
        if id != "" {
             updateGardenDelegateInForeground()
        }
    }
    
    private func updateGardenDelegateInForeground() {
        if let gardenDelegate = gardenDelegate {
            DispatchQueue.main.async {
                gardenDelegate.gardenDidChange()
            }
        }
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
