//
//  PlantWatch.swift
//  WaterMe
//
//  Created by Joshua on 8/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

enum PlantWatchVersion: Int, Codable {
    case one = 1
}

struct PlantWatch: Identifiable, Codable {
    let version: PlantWatchVersion = .one
    let id: String
    
    var name: String
    var imageName: String? = nil
    
    let dateLastWatered: Date?
    var wasWateredToday: Bool {
        if let date = dateLastWatered {
            return Calendar.current.isDateInToday(date)
        }
        return false
    }
    
    var hasNotification = false
    var notificationWasTriggered = false
}
