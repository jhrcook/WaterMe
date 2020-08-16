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

extension WatchToPhoneCommunicator {
    func sendWateringUpdate(_ plant: PlantWatch) {
        print("Sending watering update for plant: \(plant.name)")
        let info = WCDataManager().packageMessageInfo(datatype: .waterPlant, info: plant.id)
        print(info)
//        session.sendMessageOrTransfer(info: info)
        session.sendMessage(info, replyHandler: { replyMessage in
            print("reply message \(replyMessage)")
        }, errorHandler: { errorHandler in
            print("error: \(errorHandler.localizedDescription)")
        })
    }

    func requestAllApplicationData() {
        print("Requesting all application data.")
        let info = WCDataManager().packageMessageInfo(datatype: .requestAllData, info: "")
        session.sendMessageOrTransfer(info: info)
    }
}


// Receiving Data

extension WatchToPhoneCommunicator {
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        do {
            print("Message recieved and attempting to parse.")
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
            } else {
                throw WatchConnectivityDataError.unknownDataType(dataTypeString)
            }
        } else {
            throw WatchConnectivityDataError.noDataTypeIndicated
        }
        
    }

    
    private func addPlant(plantInfo: [String : Any]) {
        let plant = WCDataManager().convert(plantInfo: plantInfo)
        print("Adding plant: '\(plant.name)'.")
        let garden = GardenWatch()
        garden.plants.append(plant)
        updateGardenDelegateInForeground()
    }
    
    
    private func deletePlants(plantIds: [String]) {
        print("Deleting \(plantIds.count) plant(s).")
        let garden = GardenWatch()
        garden.delete(plantIds: plantIds)
        updateGardenDelegateInForeground()
    }
    
    
    private func updatePlant(plantInfo: [String : Any]) {
        let garden = GardenWatch()
        let plant = WCDataManager().convert(plantInfo: plantInfo)
        print("Updating plant: '\(plant.name)'")
        garden.update(plant, addIfNew: true, updatePlantOrder: true)
        updateGardenDelegateInForeground()
    }
    
    
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        #warning("TO-DO: File recieved but not parsed.")
    }
    
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        do {
            print("Recieved application context and trying to parse.")
            try parseApplicationContext(info: applicationContext)
        } catch {
            print("Error in parsing application context: \(error.localizedDescription)")
        }
    }
    
    
    func parseApplicationContext(info: [String : Any]) throws {
        if let dataTypeString = info[DataDictionaryKey.datatype.rawValue] as? String {
            if let dataType = PhoneToWatchDataType.init(rawValue: dataTypeString) {
                switch dataType {
                case .allData:
                    print("All plant data recieved!")
                    setGardenPlants(fromInfo: info[DataDictionaryKey.data.rawValue] as? [[String : Any]] ?? [[String : Any]]())
                    setRequestedInitialDataToTrue()
                default:
                    throw WatchConnectivityDataError.inappropriateDataType(dataType.rawValue)
                }
            } else {
                throw WatchConnectivityDataError.unknownDataType(dataTypeString)
            }
        } else {
            throw WatchConnectivityDataError.noDataTypeIndicated
        }
    }
    
    
    func setGardenPlants(fromInfo plantInfo: [[String : Any]]) {
        let garden = GardenWatch()
        garden.deleteAllPlants()
        let plants = WCDataManager().convert(plantsInfo: plantInfo)
        print("Replacing current data with \(plants) plant(s)")
        garden.plants = plants
        garden.sortPlants()
        updateGardenDelegateInForeground()
    }
    
    private func setRequestedInitialDataToTrue() {
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.watchHasRequestedInitalData)
    }
    
    
    private func updateGardenDelegateInForeground() {
        if let gardenDelegate = gardenDelegate {
            DispatchQueue.main.async {
                gardenDelegate.gardenDidChange()
            }
        }
    }
}
