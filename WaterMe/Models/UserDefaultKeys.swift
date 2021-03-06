//
//  UserDefaultKeys.swift
//  WaterMe
//
//  Created by Joshua on 7/27/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

struct UserDefaultKeys {
    static let snoozeDuration = "snoozeDuration"
    static let dateForNotifications = "dateForNotifications"
    
    static let plantsArrayKey = "plants"
    static let gardenPlantOrder = "gardenPlantOrder"
    
    static let gardenNotificationCenterKey = "GardenNotificationCenter"
    
    static let allowLongPressWatering =  "allowLongPressWatering"
}

#if os(watchOS)
extension UserDefaultKeys {
    static let watchHasRequestedInitalData = "watchHasRequestedInitalData"
}
#endif
