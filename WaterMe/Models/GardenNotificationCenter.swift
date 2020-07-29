//
//  GardenNotificationCenter.swift
//  WaterMe
//
//  Created by Joshua on 7/28/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation
import UserNotifications


struct GardenNotificationCenter {
    
    var scheduledNotifications: [GardenNotification]
    
    init() {
        if let encodedNC = UserDefaults.standard.data(forKey: UserDefaultKeys.gardenNotificationCenterKey) {
            let decoder = JSONDecoder()
            if let decodedNC = try? decoder.decode([GardenNotification].self, from: encodedNC) {
                self.scheduledNotifications = decodedNC
                return
            }
        }
        
        print("Unable to read in notifications - setting empty array.")
        self.scheduledNotifications = []
    }
    
    
    func save() {
        print("Saving \(scheduledNotifications.count) notification records.")
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(scheduledNotifications)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.gardenNotificationCenterKey)
        } catch {
            print("Unable to encode notification data.")
        }
        
    }
    
    
    mutating func add(_ plant: Plant, toDate date: Date) {
        
        // Check all existing notifications.
        scheduledNotifications = scheduledNotifications.map {
            print($0.id.uuidString)
            if $0.contains(plant) {
                if $0.isSameDateAs(date) {
                    return $0
                } else {
                    var newNotif = $0
                    newNotif.remove(plant)
                    return newNotif
                }
            } else {
                if $0.isSameDateAs(date) {
                    var newNotif = $0
                    newNotif.add(plant)
                    return newNotif
                }
            }
            return $0
        }
        
        // Create a new notification if there is none with the date `date`.
        let isSameDate = scheduledNotifications.map { $0.isSameDateAs(date) }
        if scheduledNotifications.count == 0 || !isSameDate.allSatisfy({$0}) {
            let newNotification = GardenNotification(date: date, plant: plant)
            scheduledNotifications.append(newNotification)
        }
        
        save()
    }
    
    
    mutating func remove(_ plant: Plant) {
        scheduledNotifications = scheduledNotifications.map {
            if $0.contains(plant) {
                var newNotif = $0
                newNotif.remove(plant)
                return newNotif
            }
            return $0
        }
        save()
    }
    
    
    func rescheduleAllNotifications() {
        for notification in scheduledNotifications {
            notification.scheduleNotification()
        }
    }
    
    mutating func clearAllNotifications() {
        print("Clearing all notifications.")
        for notification in scheduledNotifications {
            notification.removeOldNotification()
        }
        scheduledNotifications = []
        save()
    }
    
}
