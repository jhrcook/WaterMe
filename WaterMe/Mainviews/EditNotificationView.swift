//
//  EditNotificationView.swift
//  WaterMe
//
//  Created by Joshua on 7/27/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct EditNotificationView: View {
    
    @Binding var plant: Plant
    @ObservedObject var garden: Garden
    var watchCommunicator: PhoneToWatchCommunicator
    
    @State var plantHasNotificationsSet: Bool
    @State private var selectedNotificationType: WaterNotificationType
    
    @State private var dayOfTheWeek: Date.Weekday
    @State private var weekdayFrequency: Int
    @State private var numberOfDaysPerNotification: Int
    
    init(plant: Binding<Plant>, garden: Garden, watchCommunicator: PhoneToWatchCommunicator) {
        _plant = plant
        self.garden = garden
        self.watchCommunicator = watchCommunicator
        
        _plantHasNotificationsSet = State(initialValue: plant.wrappedValue.wateringNotification != nil)
        _selectedNotificationType = State(initialValue: plant.wrappedValue.wateringNotification?.type ?? WaterNotificationType.weekday)
        
        _dayOfTheWeek = State(initialValue: plant.wrappedValue.wateringNotification?.weekday ?? .Saturday)
        _weekdayFrequency = State(initialValue: plant.wrappedValue.wateringNotification?.weekdayFrequency ?? 1)
        _numberOfDaysPerNotification = State(initialValue: plant.wrappedValue.wateringNotification?.numberOfDays ?? 3)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $plantHasNotificationsSet) {
                        Text("Use notifications")
                    }
                }
                
                if plantHasNotificationsSet {
                    Section {
                        Picker(selection: $selectedNotificationType, label: Text("Type of scheduling pattern")) {
                            Text("By day of the week").tag(WaterNotificationType.weekday)
                            Text("By number of days").tag(WaterNotificationType.numeric)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        if selectedNotificationType == .weekday {
                            // Picker for using either weekday or number of days.
                            Picker(selection: $dayOfTheWeek, label: Text("Day")) {
                                ForEach(Date.Weekday.allCases, id: \.self) { day in
                                    Text(day.rawValue)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .labelsHidden()
                            
                            Picker(selection: $weekdayFrequency, label: Text("Cadence of weekly reminders.")) {
                                Text("Every week").tag(1)
                                Text("Every other week").tag(2)
                                Text("Every 2 weeks").tag(3)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .labelsHidden()
                            
                        } else {
                            // Picker for number of days or weeks.
                            Picker(selection: $numberOfDaysPerNotification, label: Text("Day")) {
                                ForEach(1...30, id: \.self) { number in
                                    Text(String(number))
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .labelsHidden()
                        }
                    }
                }
            }
            .navigationBarTitle("Water reminders")
            .onDisappear {
                
                // Remove old notification.
                if self.plant.wateringNotification != nil {
                    var gnc = GardenNotificationCenter()
                    gnc.remove(self.plant)
                }
                
                // Set the notification to `nil` if the switch is Off.
                if !self.plantHasNotificationsSet {
                    self.plant.wateringNotification = nil
                    self.garden.update(self.plant)
                    self.watchCommunicator.updateOnWatch(self.plant)
                    return
                }
                
                // Make new notification.
                switch self.selectedNotificationType {
                case .weekday:
                    let notification = WaterNotification(weekday: self.dayOfTheWeek, weekdayFrequency: self.weekdayFrequency)
                    self.plant.wateringNotification = notification
                case .numeric:
                    let notification = WaterNotification(numberOfDays: self.numberOfDaysPerNotification)
                    self.plant.wateringNotification = notification
                }
                
                // Schedule the notification and update garden.
                self.plant.scheduleNotification()
                self.garden.update(self.plant)
                self.watchCommunicator.updateOnWatch(self.plant)
            }
        }
    }
}

struct EditNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditNotificationView(plant: .constant(Plant(name: "Test plant")), garden: Garden(), watchCommunicator: PhoneToWatchCommunicator())
        }
    }
}
