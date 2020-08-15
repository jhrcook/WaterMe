//
//  WCDataManager.swift
//  WaterMe
//
//  Created by Joshua on 8/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

enum DataDictionaryKey: String {
    case datatype, data
}


enum PhoneToWatchDataType: String {
    case addPlant
    case deletePlant
    case updatePlant
    case imageFile
    case allData
}


enum WatchToPhoneDataType: String {
    case waterPlant
    case requestAllData
}


enum WCMessageResponse: String {
    case response
    
    enum WCResponseType: String {
        case success
        case failure
    }
}


enum PlantWatchComponent: String {
    case id, name, imageName, dateLastWatered, dateOfNextNotification, randomImageIndex
}


struct WCDataManager {
    
    func convert(date: Date?) -> String {
        if let date = date {
            return String(date.timeIntervalSince1970)
        }
        return ""
    }
    
    func convert(stringDate: String) -> Date? {
        if stringDate == "" { return nil }
        if let timeIntervalSince1970 = Double(stringDate) {
            return Date(timeIntervalSince1970: timeIntervalSince1970)
        }
        return nil
    }
}


#if os(iOS)
extension WCDataManager {
    
    func packageMessageInfo(datatype: PhoneToWatchDataType, data: Any) -> [String : Any] {
        let info: [String : Any] = [
            DataDictionaryKey.datatype.rawValue : datatype.rawValue,
            DataDictionaryKey.data.rawValue : data
        ]
        return info
    }
    
    func convert(plantForWatch plant: Plant) -> [String : Any] {
        let plantInfo: [String : Any] = [
            PlantWatchComponent.id.rawValue: plant.id,
            PlantWatchComponent.name.rawValue: plant.name,
            PlantWatchComponent.imageName.rawValue: plant.imageName ?? "",
            PlantWatchComponent.dateLastWatered.rawValue: convert(date: plant.dateLastWatered),
            PlantWatchComponent.dateOfNextNotification.rawValue: convert(date: plant.wateringNotification?.dateOfNextNotification),
            PlantWatchComponent.randomImageIndex.rawValue: plant.randomImageIndex
        ]
        return plantInfo
    }
    
    func convert(plantsForWatch plants: [Plant]) -> [[String : Any]] {
        return plants.map { convert(plantForWatch: $0) }
    }
    
}
#endif


#if os(watchOS)
extension WCDataManager {
    
    func packageMessageInfo(datatype: WatchToPhoneDataType, info: Any) -> [String : Any] {
        let info: [String : Any] = [
            DataDictionaryKey.datatype.rawValue : datatype.rawValue,
            DataDictionaryKey.data.rawValue : info
        ]
        return info
    }
    
    func convert(plantInfo: [String : Any]) -> PlantWatch {
        
        let id = plantInfo[PlantWatchComponent.id.rawValue] as? String ?? UUID().uuidString
        let name = plantInfo[PlantWatchComponent.name.rawValue] as? String ?? ""
        
        var imageName: String? = plantInfo[PlantWatchComponent.imageName.rawValue] as? String ?? nil
        if imageName == "" { imageName = nil }
        
        
        func unwrapDateFromString(key: String) -> Date? {
            let stringValue = plantInfo[key] as? String ?? nil
            if stringValue != nil {
                return convert(stringDate: stringValue!)
            }
            return nil
        }
        
        let dateLastWatered = unwrapDateFromString(key: PlantWatchComponent.dateLastWatered.rawValue)
        
        let dateOfNextNotification = unwrapDateFromString(key: PlantWatchComponent.dateOfNextNotification.rawValue)
        
        let randomImageIndex: Int = plantInfo[PlantWatchComponent.randomImageIndex.rawValue] as? Int ?? 1
        
        return PlantWatch(id: id,
                          name: name,
                          imageName: imageName,
                          dateLastWatered: dateLastWatered,
                          dateOfNextNotification: dateOfNextNotification,
                          randomImageIndex: randomImageIndex)
    }
    
    func convert(plantsInfo: [[String : Any]]) -> [PlantWatch] {
        return plantsInfo.map { convert(plantInfo: $0) }
    }
}
#endif


enum WatchConnectivityDataError: Error, LocalizedError {
    case inappropriateDataType(String)
    case unknownDataType(String)
    case noDataTypeIndicated
    
    var errorDescription: String? {
        switch self {
        case .inappropriateDataType(let datatype):
            return NSLocalizedString("The data type '\(datatype)' is not handled by this data transfer method.", comment: "")
        case .unknownDataType(let datatype):
            return NSLocalizedString("The data type '\(datatype)' is unknown.", comment: "")
        case .noDataTypeIndicated:
            return NSLocalizedString("No data type key specified in data.", comment: "")
        }
    }
}
