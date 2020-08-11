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
        do {
            try parseIncomingMessageOrTransfer(info: message)
            replyHandler([WCMessageResponse.response.rawValue : WCMessageResponse.WCResponseType.success])
        } catch {
            print("Error in parsing recieved message: \(error.localizedDescription)")
            replyHandler([WCMessageResponse.response.rawValue : WCMessageResponse.WCResponseType.success])
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
            if let dataType = PhoneToWatchDataType(rawValue: dataTypeString) {
                switch dataType {
                case .addPlant:
                    addPlant(plantInfo: info[DataDictionaryKey.data.rawValue] as? [String : Any] ?? [String : Any]())
                case .deletePlant:
                    deletePlants(plantIds: info[DataDictionaryKey.data.rawValue] as? [String] ?? [String]())
                case .updatePlant:
                    updatePlant(plantInfo: info[DataDictionaryKey.data.rawValue] as? [String : Any] ?? [String : Any]())
                case .imageFile, .allData:
                    throw WatchConnectivityDataError.inappropriateDataType(dataType.rawValue)
                }
            }
        }
        
    }

    
    private func addPlant(plantInfo: [String : Any]) {
        let plant = WCDataManager().convert(plantInfo: plantInfo)
        let garden = GardenWatch()
        garden.plants.append(plant)
    }
    
    
    private func deletePlants(plantIds: [String]) {
        let garden = GardenWatch()
        garden.plants = garden.plants.filter { !plantIds.contains($0.id) }
    }
    
    
    private func updatePlant(plantInfo: [String : Any]) {
        let garden = GardenWatch()
        let plant = WCDataManager().convert(plantInfo: plantInfo)
        garden.update(plant, addIfNew: true, updatePlantOrder: true)
    }
    
    
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        <#code#>
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        <#code#>
    }
}
