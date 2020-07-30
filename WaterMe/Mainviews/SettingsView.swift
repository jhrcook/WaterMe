//
//  SettingsView.swift
//  WaterMe
//
//  Created by Joshua on 7/26/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var garden: Garden
    
    @State private var snoozeDuration: String = String(UserDefaults.standard.integer(forKey: UserDefaultKeys.snoozeDuration))
    @State private var dateForNotifications: Date = UserDefaults.standard.object(forKey: UserDefaultKeys.dateForNotifications) as? Date ?? Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
    
    @State private var cancelExistingNotifications = false
    @State private var removePlantNotifications = false
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: HStack{
                    Image(systemName: "bell")
                    Text("Notifications")
                }) {
                    HStack {
                        Text("Snooze duration")
                        Spacer()
                        TextField("", text: $snoozeDuration)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("days")
                    }
                    
                    DatePicker("Time of day to receive notifications",
                               selection: $dateForNotifications,
                               displayedComponents: .hourAndMinute)
                    
                    // Cancel scheduled notifications.
                    Button(action: {
                        self.cancelExistingNotifications.toggle()
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "pause").foregroundColor(.red)
                            Text("Pasue notifications").foregroundColor(.red)
                            Spacer()
                        }
                    }
                    .alert(isPresented: $cancelExistingNotifications) {
                        Alert(title: Text("Pasue notifications?"),
                              message: Text("Are you sure you want to cancel all scheduled notifications? They will resume next time the plant is watered."),
                              primaryButton: .default(Text("No")),
                              secondaryButton: .destructive(Text("Pause")) {
                                var nc = GardenNotificationCenter()
                                nc.clearAllNotifications()
                            })
                    }
                    
                    // Cancel scheduled notifications and remove notifications from plants.
                    Button(action: {
                        self.removePlantNotifications.toggle()
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "bell.slash").foregroundColor(.red)
                            Text("Remove notifications from plants").foregroundColor(.red)
                            Spacer()
                        }
                    }
                    .alert(isPresented: $removePlantNotifications) {
                        Alert(title: Text("Remove notifications?"),
                              message: Text("Are you sure you want to remove notifications from all plants?"),
                              primaryButton: .default(Text("No")),
                              secondaryButton: .destructive(Text("Remove")) {
                                // Cancel scheduled notifications.
                                var nc = GardenNotificationCenter()
                                nc.clearAllNotifications()
                                
                                // Remove notifications from plants.
                                self.garden.plants = self.garden.plants.map { plant in
                                    var newPlant = plant
                                    newPlant.wateringNotification = nil
                                    return newPlant
                                }
                            })
                    }
                }
                
                
                
                Section(header: HStack {
                    Image(systemName: "info.circle")
                    Text("About")
                }) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("0.0.0.9000")
                    }
                    
                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("Joshua Cook")
                    }
                }
                
            }
            .navigationBarTitle("Settings")
            .onDisappear {
                print("Setting UserDefault values.")
                UserDefaults.standard.set(self.snoozeDuration, forKey: UserDefaultKeys.snoozeDuration)
                UserDefaults.standard.set(self.dateForNotifications, forKey: UserDefaultKeys.dateForNotifications)
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(garden: Garden())
    }
}
