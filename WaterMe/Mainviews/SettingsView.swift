//
//  SettingsView.swift
//  WaterMe
//
//  Created by Joshua on 7/26/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var snoozeDuration: String = String(UserDefaults.standard.integer(forKey: "snoozeDuration"))
    @State private var timeForNotifications: Date = UserDefaults.standard.object(forKey: "timeForNotifications") as? Date ?? Date()
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: HStack{
                    Image(systemName: "bell")
                    Text("NOTIFICATIONS")
                }) {
                    HStack {
                        Text("Snooze duration")
                        Spacer()
                        TextField("", text: $snoozeDuration)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("days")
                    }
                    
                    VStack() {
                        HStack {
                            Text("Time of day to receive notifications")
                            Spacer()
                        }
                        
                        DatePicker("Select a time to receive notifications.",
                                   selection: $timeForNotifications,
                                   displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                    }
                }
                
                
                Section(header: HStack {
                    Image(systemName: "info.circle")
                    Text("ABOUT")
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
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
