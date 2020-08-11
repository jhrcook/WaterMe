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
    var id: String
    
    var name: String
    var imageName: String? = nil
    
    var dateLastWatered: Date? = nil
    var wasWateredToday: Bool {
        if let date = dateLastWatered {
            return Calendar.current.isDateInToday(date)
        }
        return false
    }
    
    var dateOfNextNotification: Date? = nil
    var notificationWasTriggered: Bool {
        if let dateOfNextNotification = dateOfNextNotification {
            return dateOfNextNotification < Date()
        }
        return false
    }
    
    init() {
        self.name = ""
        self.id = UUID().uuidString
    }
    
    init(name: String) {
        self.name = name
    }
    
    init(id: String, name: String) {
        self.id = id
        self.init(name: name)
    }
    
    init(id: String, name: String, imageName: String?, dateLastWatered: Date?,
         dateOfNextNotification: Date?) {
        self.init(id: id, name: name)
        self.imageName = imageName
        self.dateLastWatered = dateLastWatered
        self.dateOfNextNotification = dateOfNextNotification
    }
}
