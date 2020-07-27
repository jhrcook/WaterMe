//
//  SettingsView.swift
//  WaterMe
//
//  Created by Joshua on 7/26/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var snoozeDuration: String = String(UserDefaults.standard.integer(forKey: UserDefaultKeys.snoozeDuration))
    @State private var timeForNotifications: Date = UserDefaults.standard.object(forKey: UserDefaultKeys.timeForNotifications) as? Date ?? Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
    
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
                               selection: $timeForNotifications,
                               displayedComponents: .hourAndMinute)
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
                UserDefaults.standard.set(self.timeForNotifications, forKey: UserDefaultKeys.timeForNotifications)
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}