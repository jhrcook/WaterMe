//
//  GardenNotification.swift
//  WaterMe
//
//  Created by Joshua on 7/29/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation
import UserNotifications


struct GardenNotification: Codable, Identifiable {
    let id: UUID
    let date: Date
    var plantIds: [UUID] = []
    
    var notificationTitle: String {
        if plantIds.count == 1 {
            return "You have 1 plant to water"
        } else {
            return "You have \(plantIds.count) plants to water"
        }
    }
    
    init(date: Date) {
        self.id = UUID()
        self.date = date
    }
    
    init(date: Date, plants: [Plant]) {
        self.id = UUID()
        self.date = date
        self.plantIds = plants.map { $0.id }
    }
    
    init(date: Date, plant: Plant) {
        self.id = UUID()
        self.date = date
        self.plantIds = [plant.id]
    }
    
    func contains(_ plant: Plant) -> Bool {
        return plantIds.contains(plant.id)
    }
    
    func isSameDateAs(_ comparisonDate: Date) -> Bool {
        Calendar.current.isDate(self.date, inSameDayAs: comparisonDate)
    }
    
    mutating func add(_ plant: Plant) {
        print("Adding plant to notification.")
        plantIds.append(plant.id)
        scheduleNotification()
    }
    
    mutating func remove(_ plant: Plant) {
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
        
        if !requestUserNotificationPermission() {
            print("Do not have permission to schedule notifications.")
            return
        }
        
        // Set notification.
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.subtitle = "Don't forget to check on your plants!"
        content.sound = UNNotificationSound.default
        
        print("Notification title: '\(content.title)'")

        let dateDuration = Calendar.current.dateComponents([.second], from: Date(), to: date)
        let timeInterval = Double(dateDuration.second!)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    
    func requestUserNotificationPermission() -> Bool {
        var result = true
        
        // Request permission.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("UserNotification request successful.")
                result = true
            } else if let error = error {
                print("UserNotification request NOT successful.")
                print(error.localizedDescription)
                result = false
            }
        }
        
        return result
    }
    
    
    func removeOldNotification() {
        print("Removing notification id \(id.uuidString)")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
    
}
