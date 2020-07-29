//
//  WaterNotification.swift
//  WaterMe
//
//  Created by Joshua on 7/26/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation
import UserNotifications


enum WaterNotificationType: String, Codable {
    case numeric
    case weekday
}





struct WaterNotification: Codable {
    
    /// The type of watering notification.
    ///
    /// The `numeric` type are notifications sent every set number of days. The `weekday` type is sent on specified days of the week.
    var type: WaterNotificationType
    
    /// The number of days between watering reminders.
    var numberOfDays: Int?
    
    /// The day of the week in which to send reminders.
    var weekday: Date.Weekday?
    /// How frequently to set reminders for weekdays.
    var weekdayFrequency: Int?
    
    /// A formatted summary of the notification.
    var formattedNotificationSummary: String {
        let prefix = "Reminder scheduled for every"
        if self.type == .weekday {
            if weekdayFrequency! == 1 {
                return "\(prefix) \(weekday!.rawValue)"
            } else if weekdayFrequency! == 2 {
                 return "\(prefix) other \(weekday!.rawValue)"
            } else {
                return "\(prefix) two \(weekday!.rawValue)s"
            }
        } else {
            if numberOfDays! == 1 {
                return "\(prefix) day"
            } else {
                return "\(prefix) \(numberOfDays!) days"
            }
        }
    }
    
    var dateOfLastSetNotification: Date = Date()
    
    var dateOfNextNotification: Date {
        if type == .numeric {
            if let numberOfDays = numberOfDays {
                var date = Calendar.current.date(byAdding: .day, value: numberOfDays, to: dateOfLastSetNotification)!
                let hour: Int = UserDefaults.standard.integer(forKey: UserDefaultKeys.timeForNotifications)
                date = Calendar.current.date(bySettingHour: hour, minute: 00, second: 00, of: date)!
                return date
            } else {
                fatalError("No `numberOfDays` value for a `.numeric` notification.")
            }
        } else {
            if let weekday = weekday, let weekdayFrequency = weekdayFrequency {
                var nextDate = Date()
                for _ in 0..<weekdayFrequency {
                    nextDate = nextDate.next(weekday, considerToday: false)
                }
                return nextDate
            } else {
                fatalError("No `weekday` or `weekdayFrequency` value for a `.weekday` notification.")
            }
        }
    }
    
    var notificationTimeInterval: TimeInterval {
        let dateDuration = Calendar.current.dateComponents([.second], from: Date(), to: dateOfNextNotification)
        return Double(dateDuration.second!)
    }
    
    /// Create a notification to be scheduled every set numbrer of days.
    /// - Parameter numberOfDays: The number of ways between reminders.
    init(numberOfDays: Int) {
        self.type = .numeric
        
        self.numberOfDays = numberOfDays
        
        self.weekday = nil
        self.weekdayFrequency = nil
    }
    
    
    /// Create a notification to be scheduled on a specific day of the week with a certain frequency.
    /// - Parameters:
    ///   - weekday: The day of the week.
    ///   - weekdayFrequency: Frequency of weekly notifications.
    init(weekday: Date.Weekday, weekdayFrequency: Int) {
        self.type = .weekday
        
        self.weekday = weekday
        self.weekdayFrequency = weekdayFrequency
        
        self.numberOfDays = nil
    }
    
    /// Add the plant to the list of plants for the notification for the correct date.
    /// - Parameter plant: Plant for reminder.
    func scheduleNotificationFor(_ plant: Plant) {
        var gnc = GardenNotificationCenter()
        gnc.add(plant, toDate: dateOfNextNotification)
    }
}
