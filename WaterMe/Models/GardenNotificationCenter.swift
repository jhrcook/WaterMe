//
//  GardenNotificationCenter.swift
//  WaterMe
//
//  Created by Joshua on 7/28/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation
import UserNotifications


class GardenNotification: Codable, Identifiable {
    let id = UUID()
    let date: Date
    var plantIds: [UUID] = []
    
    init(date: Date) {
        self.date = date
    }
    
    init(date: Date, plants: [Plant]) {
        self.date = date
        self.plantIds = plants.map { $0.id }
    }
    
    init(date: Date, plant: Plant) {
        self.date = date
        self.plantIds = [plant.id]
    }
    
    func contains(_ plant: Plant) -> Bool {
        return plantIds.contains(plant.id)
    }
    
    func isSameDateAs(_ comparisonDate: Date) -> Bool {
        Calendar.current.isDate(self.date, inSameDayAs: comparisonDate)
    }
    
    func add(_ plant: Plant) {
        print("Adding plant to notification.")
        plantIds.append(plant.id)
        scheduleNotification()
    }
    
    func remove(_ plant: Plant) {
        print("Remove plant from notification.")
        plantIds = plantIds.filter { $0 != plant.id }
        scheduleNotification()
    }
    
    func scheduleNotification() {
        
        if plantIds.count == 0 {
            removeOldNotification()
            return
        }
        
        print("Scheduling notification id: \(id.uuidString)")
        
        // Request permission.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        // Set notification.
        let content = UNMutableNotificationContent()
        if plantIds.count == 1 {
            content.title = "You have 1 plant to water"
        } else {
            content.title = "You have \(plantIds.count) plants to water"
        }
        content.subtitle = "Don't forget to check on your plants!"
        content.sound = UNNotificationSound.default
        
        print("Notification title: '\(content.title)'")

        let dateDuration = Calendar.current.dateComponents([.second], from: Date(), to: date)
        let timeInterval = Double(dateDuration.second!)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    
    func removeOldNotification() {
        print("Removing notification id \(id.uuidString)")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
    
}


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
        print("Saving notification records.")
        let encoder = JSONEncoder()
        if let encodedData  = try? encoder.encode(scheduledNotifications) {
            UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.gardenNotificationCenterKey)
        }
    }
    
    
    mutating func addPlant(_ plant: Plant, toDate date: Date) {
        for notification in scheduledNotifications {
            if notification.contains(plant) {
                if notification.isSameDateAs(date) {
                    print("Plant already appropriately scheduled.")
                    return
                }
                notification.remove(plant)
            } else {
                if notification.isSameDateAs(date) {
                    notification.add(plant)
                }
            }
        }
        
        let allNotificationDates = scheduledNotifications.map { $0.date }
        if !allNotificationDates.contains(date) {
            let newNotification = GardenNotification(date: date, plant: plant)
            scheduledNotifications.append(newNotification)
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
