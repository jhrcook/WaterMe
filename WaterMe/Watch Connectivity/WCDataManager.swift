//
//  WCDataManager.swift
//  WaterMe
//
//  Created by Joshua on 8/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation


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


struct WCDataManager {
    
}


#if os(iOS)
extension WCDataManager {
    func convert(plantForWatch plant: Plant) -> [String : Any] {
        return [String : Any]()
    }
}
#endif


#if os(watchOS)
extension WCDataManager {
    func convert(plantInfo: [String : Any]) -> PlantWatch {
        return PlantWatch()
    }
}
#endif
