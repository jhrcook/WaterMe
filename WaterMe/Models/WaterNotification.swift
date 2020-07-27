//
//  WaterNotification.swift
//  WaterMe
//
//  Created by Joshua on 7/26/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation


enum WaterNotificationType: String, Codable {
    case numeric
    case weekday
}


enum Weekday: String, Codable, CaseIterable {
    case Saturday, Sunday, Monday, Tuesday, Wednesday, Thursday, Friday
}


struct WaterNotification: Codable {
    
    /// The type of watering notification.
    ///
    /// The `numeric` type are notifications sent every set number of days. The `weekday` type is sent on specified days of the week.
    var type: WaterNotificationType
    
    /// The number of days between watering reminders.
    var numberOfDays: Int?
    
    /// The day of the week in which to send reminders.
    var weekday: Weekday?
    /// How frequently to set reminders for weekdays.
    var weekdayFrequency: Int?
    
    /// Whether a notification has been set or not.
    var notificationHasBeenScheduled: Bool = false
    
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
    init(weekday: Weekday, weekdayFrequency: Int) {
        self.type = .weekday
        
        self.weekday = weekday
        self.weekdayFrequency = weekdayFrequency
        
        self.numberOfDays = nil
    }
}
